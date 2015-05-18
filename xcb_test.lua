local xcb = require'xcb'
local glue = require'glue'
local ffi = require'ffi'

setfenv(1, glue.inherit(glue.update({}, _G), xcb))

local function printf(...)
	io.stdout:write(string.format(...))
end

local c = xcb_connect(nil, nil)

local function test_window()
	local screen = xcb_setup_roots_iterator(xcb_get_setup(c)).data
	local win = xcb_generate_id(c)
	local mask = bit.bor(XCB_CW_EVENT_MASK, XCB_CW_BACK_PIXMAP)
   local val = ffi.new('uint32_t[2]', XCB_NONE, bit.bor(
   	XCB_EVENT_MASK_EXPOSURE,
   	XCB_EVENT_MASK_BUTTON_PRESS))
	xcb_create_window(
		c,                             -- Connection
		XCB_COPY_FROM_PARENT,          -- depth (same as root)
		win,                           -- window Id
		screen.root,                   -- parent window
		0, 0,                          -- x, y
		150, 150,                      -- width, height
		10,                            -- border_width
		XCB_WINDOW_CLASS_INPUT_OUTPUT, -- class
		screen.root_visual,            -- visual
		mask, val)                     -- event mask and value
	xcb_map_window(c, win)
	xcb_flush(c)
end

local function test_event_loop()
	local e
	while true do
		e = xcb_wait_for_event(c)
		if e == nil then break end
		local v = bit.band(e.response_type, bit.bnot(0x80))
		print(v)
		--[[
		if v == XCB_EXPOSE then
			xcb_expose_event_t *expose = (xcb_expose_event_t *)event
		elseif XCB_BUTTON_PRESS then
			xcb_button_press_event_t *press = (xcb_button_press_event_t *)event;
		end
		]]
		glue.free(e)
	end
end

local roots = iterator(xcb_setup_roots_iterator, xcb_screen_next)

local function test_screen()

	local n = ffi.new'int[1]' --screen number
	local c = xcb_connect(nil, n)
	n = n[0] + 1
	local screen
	for i,screen1 in roots(xcb_get_setup(c)) do
		if n == i then
	 		screen = screen1
	   	break
	   end
	end

	printf("\n")
	printf("Screen %d:\n", screen.root)
	printf("  width.........: %d\n", screen.width_in_pixels)
	printf("  height........: %d\n", screen.height_in_pixels)
	printf("\n")

end

test_window()
test_screen()
test_event_loop()
