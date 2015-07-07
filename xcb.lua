
--XCB binding.
--Written by Cosmin Apreutesei. Public Domain.

local ffi = require'ffi'
local glue = require'glue'
require'xcb_h'
local C = ffi.os == 'OSX' and ffi.load'/usr/X11/lib/libxcb.1.dylib' or ffi.load'xcb'
local M = {C = C}

ffi.cdef[[
typedef struct {
    uint32_t flags, functions, decorations;
    int32_t input_mode;
    uint32_t status;
} motif_wm_hints_t;

void free (void*);
]]

function M.connect(displayname)

	local type, select, assert, error, ffi, bit, glue =
	      type, select, assert, error, ffi, bit, glue
	local cast = ffi.cast
	local free = glue.free

	local conn = {}
	setfenv(1, conn)

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

	local function init(displayname)
		local screen_num = ffi.new'int[1]'
		c = C.xcb_connect(displayname, screen_num)
		assert(C.xcb_connection_has_error(c) == 0)
		conn.c = c
		return screen_num[0]
	end

	--check a request cookie for errors (sync if needed)
	function check(cookie)
		local err = C.xcb_request_check(c, cookie)
		if err == nil then return cookie end
		local code = err.error_code
		free(err)
		error('XCB error: '..code)
	end

	function flush()
		C.xcb_flush(c)
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
			local code = e.error_code
			free(e)
			error('XCB error: '..code)
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

	function find_screen(screen_num)
		local i = 0
		for screen in screens() do
			if i == screen_num then
				return screen
			end
			i = i + 1
		end
	end

	local function init_screen(screen_num)
		screen = find_screen(screen_num)
		conn.screen = screen
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

	--objects -----------------------------------------------------------------

	function gen_id()
		return C.xcb_generate_id(c)
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
			atom(prop), type, format, sz, val)
	end

	local function pass(reply, ...)
		free(reply)
		return ...
	end
	function get_prop(win, prop, type, decode, sz)
		local format = prop_formats[type] or 32
		local cookie = C.xcb_get_property(c, 0, win, atom(prop), type, 0, sz or 0)
		local reply = C.xcb_get_property_reply(c, cookie, nil)
		if not reply then return end
		if reply.format == format and reply.type == type then
			local val = C.xcb_get_property_value(reply)
			if val == nil then return end
			local len = C.xcb_get_property_value_length(reply)
			return pass(reply, decode(val, len))
		else
			free(reply)
		end
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
		return list_event(win, type, 'data32', glue.pass)
	end

	function atom_list_event(win, type, ...)
		return list_event(win, type, 'data32', atom)
	end

	function send_client_message(win, e, propagate, mask)
		C.xcb_send_event(c, propagate or false, win, mask or 0, cast('const char*', e))
	end

	function send_client_message_to_root(e)
		local mask = bit.bor(
			C.XCB_EVENT_MASK_SUBSTRUCTURE_NOTIFY,
			C.XCB_EVENT_MASK_SUBSTRUCTURE_REDIRECT)
		send_client_message(screen.root, e, false, mask)
	end

	--window management -------------------------------------------------------

	net_supported_map = glue.memoize(function()
		return get_atom_map_prop(screen.root, '_NET_SUPPORTED')
	end)

	function net_supported(s)
		return net_supported_map()[atom(s)]
	end

	function set_netwm_state(win, set, atom1, atom2)
		local e = atom_list_event(win, '_NET_WM_STATE', set and 1 or 0, atom1, atom2)
		send_client_message_to_root(e)
	end

	function get_netwm_states(win)
		return get_atom_map_prop(win, '_NET_WM_STATE')
	end

	function set_wm_hints(win, hints)
		set_prop(win, C.XCB_ATOM_WM_HINTS, C.XCB_ATOM_WM_HINTS, hints,
			C.XCB_ICCCM_NUM_WM_HINTS_ELEMENTS)
	end

	local function decode_wm_hints(val, len)
		return ffi.new('xcb_icccm_wm_hints_t', cast('xcb_icccm_wm_hints_t*', val)[0])
	end
	function get_wm_hints(win)
		return get_prop(win, C.XCB_ATOM_WM_HINTS, C.XCB_ATOM_WM_HINTS,
			decode_wm_hints, C.XCB_ICCCM_NUM_WM_HINTS_ELEMENTS)
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
		return get_prop(win, atom'_NET_FRAME_EXTENTS', C.XCB_ATOM_CARDINAL, decode_extents, 4)
	end

	function activate(win, focused_win)
		local e = int32_list_event(win, '_NET_ACTIVE_WINDOW',
			1, --message comes from an app
			0, --timestamp
			focused_win or C.XCB_NONE)
		send_client_message_to_root(e)
	end

	--TODO: what's the diff. viz. the above?
	function activate(win)
		C.xcb_set_input_focus_checked(c, C.XCB_INPUT_FOCUS_NONE,
		self.win, C.XCB_CURRENT_TIME)
		C.xcb_flush(c)
	end

	function minimize(win)
		local e = client_message_event(win, 'WM_CHANGE_STATE')
		e.data.data32[0] = C.XCB_ICCCM_WM_STATE_ICONIC
		send_client_message_to_root(e)
	end

	local function decode_wm_size_hints(val, len)
		return ffi.new('xcb_icccm_wm_size_hints_t', cast('xcb_icccm_wm_size_hints_t*', val)[0])
	end
	function get_wm_normal_hints(win)
		return get_prop(win, C.XCB_ATOM_WM_NORMAL_HINTS, C.XCB_ATOM_WM_SIZE_HINTS,
			decode_wm_size_hints, C.XCB_ICCCM_NUM_WM_SIZE_HINTS_ELEMENTS)
	end

	function set_wm_normal_hints(win, minw, minh, maxw, maxh)
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
		if hints.flags ~= 0 then
			set_prop(win, C.XCB_ATOM_WM_NORMAL_HINTS, C.XCB_ATOM_WM_SIZE_HINTS,
				hints, C.XCB_ICCCM_NUM_WM_SIZE_HINTS_ELEMENTS)
		end
	end

	function translate_coords(src_win, dst_win, x, y)
		local cookie = C.xcb_translate_coordinates(c, src_win, dst_win, x, y)
		local reply = C.xcb_translate_coordinates_reply(c, cookie, nil)
		assert(reply ~= nil)
		local x, y = reply.dst_x, reply.dst_y
		free(reply)
		return x, y
	end

	function change_pos(win, x, y)
		local xy = ffi.new('int32_t[2]', x, y)
		C.xcb_configure_window(c, win,
			bit.bor(C.XCB_CONFIG_WINDOW_X, C.XCB_CONFIG_WINDOW_Y), xy)
	end

	function change_size(win, cw, ch)
		local wh = ffi.new('int32_t[2]', cw, ch)
		C.xcb_configure_window(c, win,
			bit.bor(C.XCB_CONFIG_WINDOW_WIDTH, C.XCB_CONFIG_WINDOW_HEIGHT), wh)
	end

	local function decode_motif_wm_hints(val, len)
		return ffi.new('motif_wm_hints_t', cast('motif_wm_hints_t*', val)[0])
	end
	function get_motif_wm_hints(win)
		get_prop(win, atom'_MOTIF_WM_HINTS', atom'_MOTIF_WM_HINTS', decode_motif_wm_hints, 5)
	end

	function set_motif_wm_hints(win, hints)
		set_prop(win, atom'_MOTIF_WM_HINTS', atom'_MOTIF_WM_HINTS', hints, 5)
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

	local screen_num = init(displayname)
	init_screen(screen_num)

	return conn
end

return M
