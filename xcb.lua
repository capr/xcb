
--XCB binding.
--Written by Cosmin Apreutesei. Public Domain.

local ffi = require'ffi'
local glue = require'glue'
local err = require'xcb_err'
local xsettings = require'xcb_xsettings'
require'xcb_h'
require'xcb_icccm_h'
require'xcb_mwmutil_h'
local C = ffi.load'xcb'
local M = {C = C}
local print = print
ffi.cdef'void free(void*);'

local conn_errors = {
	'socket error',
	'extension not supported',
	'out of memory',
	'request too long',
	'parse error',
	'invalid screen',
	'FD parsing failed',
}

--for setting _NET_WM_PID and WM_CLIENT_MACHINE.
--NOTE: these are for Linux/GLIBC and OSX only!
ffi.cdef[[
int getpid();
int gethostname(char *name, size_t len);
typedef struct {
	char sysname[65];
	char nodename[65];
	char release[65];
	char version[65];
	char machine[65];
	char __domainname[65];
} xcb_utsname;
int uname(xcb_utsname* buf);
]]

function M.connect(displayname)

	local type, select, unpack, assert, error, ffi, bit, table, ipairs, require, glue =
	      type, select, unpack, assert, error, ffi, bit, table, ipairs, require, glue
	local cast = ffi.cast
	local free = glue.free

	local api = {C = C}
	setfenv(1, api)

	--helpers -----------------------------------------------------------------

	function iterator(iter_func, next_func, val_func)
		val_func = val_func or glue.pass
		local function next(state, last)
			if last then
				next_func(state)
			end
			if state.rem == 0 then return end
			return val_func(state.data)
		end
		return function(...)
			local state = iter_func(...)
			return next, state
		end
	end

	--connection --------------------------------------------------------------

	local c --xcb connection
	local screen_num --default screen number
	local cleanup = {} --disconnect handlers

	local function init(displayname)
		local snbuf = ffi.new'int[1]'
		c = C.xcb_connect(displayname, snbuf)
		screen_num = snbuf[0]
		local err = C.xcb_connection_has_error(c)
		if err ~= 0 then
			error(('xcb_connect error: %d (%s)'):format(err,
				conn_errors[err] or 'unknown'), 2)
		end
		api.c = c
	end

	--check a request cookie for errors (sync if needed)
	function check(cookie)
		local e = C.xcb_request_check(c, cookie)
		if e == nil then return cookie end
		local msg = err.format(e)
		free(e)
		error(msg, 2)
	end

	function flush()
		C.xcb_flush(c)
	end

	function disconnect()
		for i,handler in ipairs(cleanup) do
			handler()
		end
		C.xcb_disconnect(c)
		c = nil
	end

	--server ------------------------------------------------------------------

	local function str_tostring(str)
		local s = C.xcb_str_name(str)
		return ffi.string(s, str.name_len)
	end
	local extensions_iter = iterator(
		C.xcb_list_extensions_names_iterator, C.xcb_str_next, str_tostring)

	--load the list of supported server extensions into a hash
	extension_map = glue.memoize(function()
		local cookie = C.xcb_list_extensions(c)
		local reply = C.xcb_list_extensions_reply(c, cookie, nil)
		local t = {}
		for ext in extensions_iter(reply) do
			t[ext] = true
		end
		free(reply)
		return t
	end)

	--check if the server has a specific extension
	function extension(s)
		return extension_map()[s]
	end

	--events ------------------------------------------------------------------

	local peeked_event, peeked_etype

	--poll or wait for the next event.
	--return event, event_type | nil (if no event) | error().
	function poll(block)

		--poll the previously peeked event if any
		if peeked_event then
			local e, etype = peeked_event, peeked_etype
			peeked_event, peeked_etype = nil
			return e, etype
		end

		--poll/wait for event
		local poll_or_wait = block and
			C.xcb_wait_for_event or
			C.xcb_poll_for_event
		local e = poll_or_wait(c)

		if e == nil then return end --nothing on the pipe

		--check for errors
		if e.response_type == 0 then
			e = cast('xcb_generic_error_t*', e) --yap, just cast it
			local msg = err.format(e)
			free(e)
			error(msg)
		end

		ffi.gc(e, free)
		return e, bit.band(e.response_type, bit.bnot(0x80))
	end

	function peek()
		if not peeked_event then
			peeked_event, peeked_etype = poll()
		end
		return peeked_event, peeked_etype
	end

	--atoms -------------------------------------------------------------------

	local atom_map = {}    --{name = atom}
	local atom_revmap = {} --{atom = name}

	local mem_atom = glue.memoize(function(s)
		local cookie = C.xcb_intern_atom(c, 0, #s, s)
		local reply = C.xcb_intern_atom_reply(c, cookie, nil)
		local atom = reply.atom
		free(reply)
		atom_revmap[atom] = s
		return atom
	end, atom_map)

	--lookup/intern an atom
	atom = function(s)
		if type(s) ~= 'string' then return s end --pass through
		return mem_atom(s)
	end

	--atom reverse lookup
	atom_name = glue.memoize(function(atom)
		local cookie = C.xcb_get_atom_name(c, atom)
		local reply = C.xcb_get_atom_name_reply(c, cookie, nil)
		if reply == nil then return end
		local n = C.xcb_get_atom_name_name_length(reply)
		local s = C.xcb_get_atom_name_name(reply)
		local s = ffi.string(s, n)
		free(reply)
		atom_map[s] = atom
		return s
	end, atom_revmap)

	--make an atom list to be used as set_prop() value.
	function atom_list(...)
		local n = select('#', ...)
		local atoms = ffi.new('xcb_atom_t[?]', n)
		for i = 1,n do
			local v = select(i,...)
			atoms[i-1] = atom(v)
		end
		return atoms, n
	end

	--given a map {atom -> true} return the map {atom_name -> atom}
	function atom_names(t)
		local dt = {}
		for atom in pairs(t) do
			local name = atom_name(atom)
			if name then
				dt[name] = atom
			end
		end
		return dt
	end

	--screens -----------------------------------------------------------------

	--default screen. these days there's only one screen even in multi-monitor
	--settings. xinerama is used to manage multiple screens as a one big screen.
	local screen

	local screen_iterator = iterator(
		C.xcb_setup_roots_iterator, C.xcb_screen_next)

	function screens()
		return screen_iterator(C.xcb_get_setup(c))
	end

	local function find_screen(screen_num)
		local i = 0
		for screen in screens() do
			if i == screen_num then
				return screen
			end
			i = i + 1
		end
	end

	local function init_screen()
		screen = find_screen(screen_num)
		api.screen = screen
	end

	depths = iterator(
		C.xcb_screen_allowed_depths_iterator, C.xcb_depth_next)

	visuals = iterator(
		C.xcb_depth_visuals_iterator, C.xcb_visualtype_next)

	--check if a given screen has a bgra8 visual.
	function find_bgra8_visual(screen)
		for d in depths(screen) do
			if d.depth == 32 then
				for v in visuals(d) do
					if v.bits_per_rgb_value == 8 and v.blue_mask == 0xff then --BGRA8
						return d.depth, v.visual_id
					end
				end
			end
		end
	end

	--constructors and destructors --------------------------------------------

	function gen_id()
		return C.xcb_generate_id(c)
	end

	function create_window(...)
		return C.xcb_create_window(c, ...)
	end
	function destroy_window(...)
		return C.xcb_destroy_window(c, ...)
	end

	function create_colormap(...)
		return C.xcb_create_colormap(c, ...)
	end
	function free_colormap(...)
		return C.xcb_free_colormap(c, ...)
	end

	function open_font(fid, name, sz)
		C.xcb_open_font(c, fid, sz or #name, name)
	end
	function close_font(...)
		C.xcb_close_font(c, ...)
	end

	function create_glyph_cursor(...)
		C.xcb_create_glyph_cursor(c, ...)
	end

	function free_cursor(...)
		C.xcb_free_cursor(c, ...)
	end

	--window properties -------------------------------------------------------

	function list_props(win)
		local cookie = C.xcb_list_properties(c, win)
		local reply = C.xcb_list_properties_reply(c, cookie, nil)
		local n = C.xcb_list_properties_atoms_length(reply)
		local atomp = C.xcb_list_properties_atoms(reply)
		local t = {}
		for i=1,n do
			t[i] = atom_name(atomp[i-1])
		end
		free(reply)
		return t
	end

	function delete_prop(win, prop)
		C.xcb_delete_property(c, win, atom(prop))
	end

	local prop_formats = {
		[C.XCB_ATOM_STRING] = 8,
	}
	function set_prop(win, prop, type, val, sz)
		local format = prop_formats[type] or 32
		C.xcb_change_property(c, C.XCB_PROP_MODE_REPLACE, win,
			atom(prop), atom(type), format, sz, val)
	end

	--get a property value that spans multiple requests as a string.
	function get_long_prop(win, prop, type)
		local offset = 0
		local t = {}
		repeat
			local cookie = C.xcb_get_property(c, 0, win, atom(prop), atom(type), offset, 8192)
			local reply = C.xcb_get_property_reply(c, cookie, nil)
			if not reply then break end
			if reply.type ~= atom(type) then
				free(reply)
				break
			end
			local val = C.xcb_get_property_value(reply)
			if val == nil then
				free(reply)
				break
			end
			local len = C.xcb_get_property_value_length(reply)
			local s = ffi.string(val, len)
			t[#t+1] = s
			local more = reply.bytes_after ~= 0
			free(reply)
			offset = offset + len / (reply.format / 8)
		until not more
		return table.concat(t)
	end

	local function pass(reply, ...)
		free(reply)
		return ...
	end
	function get_prop(win, prop, type, decode, sz)
		local cookie = C.xcb_get_property(c, 0, win, atom(prop), atom(type), 0, sz or 0)
		local reply = C.xcb_get_property_reply(c, cookie, nil)
		if not reply then return end
		if reply.type ~= atom(type) then --property not found
			free(reply)
			return
		end
		if reply.bytes_after ~= 0 then
			free(reply)
			error('property value truncated', 2)
		end
		local val = C.xcb_get_property_value(reply)
		if val == nil then --when can this happen?
			free(reply)
			return
		end
		local len = C.xcb_get_property_value_length(reply)
		return pass(reply, decode(val, len / (reply.format / 8)))
	end

	function set_string_prop(win, prop, val, sz)
		set_prop(win, prop, C.XCB_ATOM_STRING, val, sz or #val)
	end

	function get_string_prop(win, prop)
		return get_prop(win, prop, C.XCB_ATOM_STRING, ffi.string)
	end

	function set_atom_prop(win, prop, val)
		set_prop(win, prop, C.XCB_ATOM_ATOM, atom_list(val))
	end

	function set_atom_map_prop(win, prop, t)
		local atoms, n = atom_list(unpack(glue.keys(t)))
		if n == 0 then
			delete_prop(win, prop)
		else
			set_prop(win, prop, C.XCB_ATOM_ATOM, atoms, n)
		end
	end

	local function decode_atom_map(val, len)
		local val = cast('xcb_atom_t*', val)
		local t = {}
		for i = 0, len-1 do
			t[val[i]] = true
		end
		return t
	end
	function get_atom_map_prop(win, prop)
		return get_prop(win, prop, C.XCB_ATOM_ATOM, decode_atom_map, 1024)
	end

	function set_cardinal_prop(win, prop, val)
		local buf = ffi.new('int32_t[1]', val)
		set_prop(win, prop, C.XCB_ATOM_CARDINAL, buf, 1)
	end

	local function decode_window(val, len)
		if len == 0 then return end
		return cast('xcb_window_t*', val)[0]
	end
	function get_window_prop(win, prop)
		return get_prop(win, prop, C.XCB_ATOM_WINDOW, decode_window, 1)
	end
	function set_window_prop(win, prop, target_win)
		local winbuf = ffi.new('xcb_window_t[1]', target_win)
		set_prop(win, prop, C.XCB_ATOM_WINDOW, winbuf, 1)
	end

	local function decode_window_list(val, len)
		val = cast('xcb_window_t*', val)
		local t = {}
		for i=1,len do
			t[i] = val[i-1]
		end
		return t
	end
	function get_window_list_prop(win, prop)
		return get_prop(win, prop, C.XCB_ATOM_WINDOW, decode_window_list, 1024)
	end

	--client message events ---------------------------------------------------

	function client_message_event(win, type, format)
		local e = ffi.new'xcb_client_message_event_t'
		e.window = win
		e.response_type = C.XCB_CLIENT_MESSAGE
		e.type = atom(type)
		e.format = format or 32
		return e
	end

	function list_event(win, type, datatype, val_func, ...)
		local e = client_message_event(win, type)
		for i = 1,5 do
			local v = select(i, ...)
			if v then
				e.data[datatype][i-1] = val_func(v)
			end
		end
		return e
	end

	function int32_list_event(win, type, ...)
		return list_event(win, type, 'data32', glue.pass, ...)
	end

	function atom_list_event(win, type, ...)
		return list_event(win, type, 'data32', atom, ...)
	end

	function send_client_message(win, e, propagate, mask)
		C.xcb_send_event(c, propagate or false, win, mask or 0, cast('const char*', e))
	end

	function send_client_message_to_root(e)
		local mask = bit.bor(
			--C.XCB_EVENT_MASK_STRUCTURE_NOTIFY,
			C.XCB_EVENT_MASK_SUBSTRUCTURE_NOTIFY,
			C.XCB_EVENT_MASK_SUBSTRUCTURE_REDIRECT)
		send_client_message(screen.root, e, false, mask)
	end

	--window attributes -------------------------------------------------------

	function get_attrs(win)
		local cookie = C.xcb_get_window_attributes(c, win)
		local reply = C.xcb_get_window_attributes_reply(c, cookie, nil)
		return ffi.gc(reply, free)
	end

	--helper to compose the mask and values array for xcb_create_window(),
	--xcb_change_window_attributes() and xcb_configure_window().
	function mask_and_values(t)
		local mask = 0
		local i, n = 0, glue.count(t)
		local values = ffi.new('uint32_t[?]', n)
		for maskbit, value in glue.sortedpairs(t) do
			assert(maskbit > mask) --values must be added in enum order!
			mask = bit.bor(mask, maskbit)
			values[i] = value
			i = i + 1
		end
		return mask, values
	end

	function change_attrs(win, t)
		local mask, values = mask_and_values(t)
		C.xcb_change_window_attributes(c, win, mask, values)
	end

	--window management -------------------------------------------------------

	function get_geometry(win)
		local cookie = C.xcb_get_geometry(c, win)
		local reply = C.xcb_get_geometry_reply(c, cookie, nil)
		return ffi.gc(reply, free)
	end

	net_supported_map = glue.memoize(function()
		return get_atom_map_prop(screen.root, '_NET_SUPPORTED')
	end)
	function net_supported(s)
		return net_supported_map()[atom(s)]
	end

	function get_netwm_states(win)
		return get_atom_map_prop(win, '_NET_WM_STATE')
	end
	function set_netwm_states(win, t) --before the window is mapped, use this.
		set_atom_map_prop(win, '_NET_WM_STATE', t)
	end
	function change_netwm_states(win, set, atom1, atom2) --after a window is mapped, use this.
		local e = atom_list_event(win, '_NET_WM_STATE', set and 1 or 0, atom1, atom2)
		send_client_message_to_root(e)
	end

	local function decode_wm_hints(val, len)
		return ffi.new('xcb_icccm_wm_hints_t', cast('xcb_icccm_wm_hints_t*', val)[0])
	end
	function get_wm_hints(win)
		return get_prop(win, C.XCB_ATOM_WM_HINTS, C.XCB_ATOM_WM_HINTS,
			decode_wm_hints, C.XCB_ICCCM_NUM_WM_HINTS_ELEMENTS)
	end
	function set_wm_hints(win, hints)
		set_prop(win, C.XCB_ATOM_WM_HINTS, C.XCB_ATOM_WM_HINTS, hints,
			C.XCB_ICCCM_NUM_WM_HINTS_ELEMENTS)
	end

	local function decode_wm_size_hints(val, len)
		return ffi.new('xcb_icccm_wm_size_hints_t', cast('xcb_icccm_wm_size_hints_t*', val)[0])
	end
	function get_wm_normal_hints(win)
		return get_prop(win, C.XCB_ATOM_WM_NORMAL_HINTS, C.XCB_ATOM_WM_SIZE_HINTS,
			decode_wm_size_hints, C.XCB_ICCCM_NUM_WM_SIZE_HINTS_ELEMENTS)
	end
	function set_wm_normal_hints(win, hints)
		set_prop(win, C.XCB_ATOM_WM_NORMAL_HINTS, C.XCB_ATOM_WM_SIZE_HINTS,
			hints, C.XCB_ICCCM_NUM_WM_SIZE_HINTS_ELEMENTS)
	end
	function set_minmax(win, minw, minh, maxw, maxh) --these are client rect sizes
		local hints = ffi.new'xcb_size_hints_t'
		hints.flags = 0
		if minw or minh then
			hints.flags = bit.bor(hints.flags, C.XCB_ICCCM_SIZE_HINT_P_MIN_SIZE)
			hints.min_width = minw or 0
			hints.min_height = minh or 0
		end
		if maxw or maxh then
			hints.flags = bit.bor(hints.flags, C.XCB_ICCCM_SIZE_HINT_P_MAX_SIZE)
			hints.max_width = maxw or 2^30 --just an arbitrarily large number
			hints.max_height = maxh or 2^30
		end
		set_wm_normal_hints(win, hints)
	end

	local function decode_motif_wm_hints(val, len)
		return ffi.new('xcb_motif_wm_hints_t', cast('xcb_motif_wm_hints_t*', val)[0])
	end
	function get_motif_wm_hints(win)
		get_prop(win, '_MOTIF_WM_HINTS', '_MOTIF_WM_HINTS',
			decode_motif_wm_hints, C.MOTIF_WM_HINTS_ELEMENTS)
	end
	function set_motif_wm_hints(win, hints)
		set_prop(win, '_MOTIF_WM_HINTS', '_MOTIF_WM_HINTS', hints,
			C.MOTIF_WM_HINTS_ELEMENTS)
	end

	local function decode_wm_state(val, len)
		assert(len >= 2)
		val = ffi.cast('int32_t*', val)
		return val[0], val[1] --XCB_ICCCM_WM_STATE_*, icon_window_id
	end
	function get_wm_state(win)
		return get_prop(win, 'WM_STATE', 'WM_STATE', decode_wm_state, 2)
	end

	function get_transient_for(win)
		return get_window_prop(win, C.XCB_ATOM_WM_TRANSIENT_FOR)
	end
	function set_transient_for(win, for_win)
		set_window_prop(win, C.XCB_ATOM_WM_TRANSIENT_FOR, for_win)
	end

	--request filling up the frame_extents property before the window is mapped.
	function request_frame_extents(win)
		local e = client_message_event(win, atom'_NET_REQUEST_FRAME_EXTENTS')
		send_client_message_to_root(e)
	end
	local function decode_extents(val)
		val = cast('int32_t*', val)
		return val[0], val[2], val[1], val[3] --left, top, right, bottom
	end
	function frame_extents(win)
		if not net_supported'_NET_REQUEST_FRAME_EXTENTS' then
			return 0, 0, 0, 0
		end
		return get_prop(win, '_NET_FRAME_EXTENTS', C.XCB_ATOM_CARDINAL, decode_extents, 4)
	end

	function map(win)
		C.xcb_map_window(c, win)
	end

	function unmap(win)
		C.xcb_unmap_window(c, win)
	end

	function get_net_active_window()
		return get_window_prop(screen.root, '_NET_ACTIVE_WINDOW')
	end

	function net_active_window_supported()
		return net_supported'_NET_ACTIVE_WINDOW'
	end

	function set_net_active_window(win, focused_win)
		local e = int32_list_event(win, '_NET_ACTIVE_WINDOW',
			1, --message comes from an app
			0, --timestamp
			focused_win or C.XCB_NONE)
		send_client_message_to_root(e)
	end

	function get_input_focus(win)
		local cookie = C.xcb_get_input_focus(c)
		local reply = C.xcb_get_input_focus_reply(c, cookie, nil)
		if reply == nil then return end
		local win = reply.focus
		free(reply)
		return win
	end

	function set_input_focus(win)
		C.xcb_set_input_focus_checked(c, C.XCB_INPUT_FOCUS_NONE, win, C.XCB_CURRENT_TIME)
	end

	function minimize(win)
		local e = client_message_event(win, 'WM_CHANGE_STATE')
		e.data.data32[0] = C.XCB_ICCCM_WM_STATE_ICONIC
		send_client_message_to_root(e)
	end

	function translate_coords(src_win, dst_win, x, y)
		local cookie = C.xcb_translate_coordinates(c, src_win, dst_win, x, y)
		local reply = C.xcb_translate_coordinates_reply(c, cookie, nil)
		assert(reply ~= nil)
		local x, y = reply.dst_x, reply.dst_y
		free(reply)
		return x, y
	end

	function config_window(win, t) --change origin, client size, border width.
		local mask, values = mask_and_values(t)
		C.xcb_configure_window(c, win, mask, values)
	end

	function change_zorder(win, mode, relto_win)
		--not using config_window() because it doesn't work with reparenting WMs.
		local e = client_message_event(win)
		send_client_message_to_root(e)
		local mask, values = mask_and_values{
			[C.XCB_CONFIG_WINDOW_STACK_MODE] = mode,
			[C.XCB_CONFIG_WINDOW_SIBLING] = relto_win,
		}
--[=[
typedef struct {
	int type;		/* ConfigureRequest */
	unsigned long serial;	/* # of last request processed by server */
	Bool send_event;	/* true if this came from a SendEvent request */
	Display *display;	/* Display the event was read from */
	Window parent;
	Window window;
	int x, y;
	int width, height;
	int border_width;
	Window above;
	int detail;		/* Above, Below, TopIf, BottomIf, Opposite */
	unsigned long value_mask;
} XConfigureRequestEvent;
]=]
	end

	function get_title(win)
		return xcb.get_string_prop(self.win, C.XCB_ATOM_WM_NAME)
	end
	function set_title(win, title)
		set_string_prop(win, C.XCB_ATOM_WM_NAME, title)
		set_string_prop(win, C.XCB_ATOM_WM_ICON_NAME, title)
	end

	function query_tree(win)
		local cookie = C.xcb_query_tree(c, win)
		local reply = C.xcb_query_tree_reply(c, cookie, nil)
		local winp = C.xcb_query_tree_children(reply)
		local n = C.xcb_query_tree_children_length(reply)
		local t = {}
		for i=1,n do
			t[i] = winp[i-1]
		end
		local t = {
			root = reply.root,
			parent = reply.parent ~= 0 and reply.parent or nil,
			children = t,
		}
		free(reply)
		return t
	end

	--selections --------------------------------------------------------------

	function get_selection_owner(sel)
		local cookie = C.xcb_get_selection_owner(c, atom(sel))
		local reply = C.xcb_get_selection_owner_reply(c, cookie, nil)
		local owner = reply ~= nil and reply.owner or nil
		free(reply)
		return owner
	end

	--xsettings extension -----------------------------------------------------

	function get_xsettings_window(snum)
		snum = snum or screen_num
		return get_selection_owner('_XSETTINGS_S'..snum)
	end

	function xsettings_set_property_change_notify()
		local win = xsettings_window()
		if not win then return end
		local mask = bit.bor(
			C.XCB_EVENT_MASK_STRUCTURE_NOTIFY,
			C.XCB_EVENT_MASK_PROPERTY_CHANGE)
		change_attrs(win, {[C.XCB_CW_EVENT_MASK] = mask})
	end

	function get_xsettings()
		local win = get_xsettings_window()
		if not win then return end
		local s = get_long_prop(win, '_XSETTINGS_SETTINGS', '_XSETTINGS_SETTINGS', 8)
		return xsettings.decode(ffi.cast('const char*', s), #s)
	end

	--cursors -----------------------------------------------------------------

	local xcursor
	local ctx
	function load_cursor(name)
		if not ctx then
			xcursor = require'xcb_cursor'
			ctx = xcursor.context(c, screen)
			table.insert(cleanup, function() ctx:free() end)
		end
		return ctx:load(name)
	end

	function set_cursor(win, cursor)
		change_attrs(win, {[C.XCB_CW_CURSOR] = cursor})
	end

	local bcur
	function blank_cursor()
		if not bcur then
			bcur = gen_id()
			local pix = gen_id()
			C.xcb_create_pixmap(c, 1, pix, screen.root, 1, 1)
			C.xcb_create_cursor(c, bcur, pix, pix, 0, 0, 0, 0, 0, 0, 0, 0)
			C.xcb_free_pixmap(c, pix)
		end
		return bcur
	end

	--_NET_WM_PING protocol helpers -------------------------------------------

	--respond to a _NET_WM_PING event
	function pong(e)
		local reply = ffi.new('xcb_client_message_event_t', e[0])
		reply.response_type = C.XCB_CLIENT_MESSAGE
		reply.window = screen.root
		send_client_message_to_root(reply) --pong!
	end

	--set _NET_WM_PID and WM_CLIENT_MACHINE as needed by the protocol
	function set_netwm_ping_info(win)
		set_cardinal_prop(win, '_NET_WM_PID', ffi.C.getpid())
		local name
		local buf = ffi.new'char[256]'
		if ffi.C.gethostname(buf, 256) == 0 then
			name = ffi.string(buf)
		else
			local utsname = ffi.new'xcb_utsname'
			if ffi.C.uname(utsname) == 0 then
				name = ffi.string(utsname.nodename)
			end
		end
		if name then
			set_string_prop(win, 'WM_CLIENT_MACHINE', name)
		end
	end

	--shm extension -----------------------------------------------------------

	local xcbshm = false
	function shm()
		if xcbshm ~= false then return xcbshm end
		xcbshm = nil --assume not available
		local shm = require'shm'
		require'xcb_shm_h'
		--FACEPALM: On Ubuntu, X has the extension but xcb-shm must be installed.
		local ok, lib = pcall(ffi.load, 'xcb-shm.so.0')
		if not ok then return end
		local cookie = lib.xcb_shm_query_version(c)
		local reply = lib.xcb_shm_query_version_reply(c, cookie, nil)
		local ok = reply ~= nil and reply.shared_pixmaps ~= 0
		free(reply)
		if ok then xcbshm = lib end --make available
		return lib
	end

	--init --------------------------------------------------------------------

	init(displayname)
	init_screen()

	return api
end

return M
