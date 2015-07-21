local pp = require'pp'
local time = require'time'
local xcb = require'xcb'
local ffi = require'ffi'
require'xcb_mwmutil_h'
require'xcb_icccm_h'

local xlib_xcb = require'xlib_xcb'
require'glx_h'

xcb = xcb.connect()
local C = xcb.C
local screen = xcb.screen

local visual = xcb.find_bgra8_visual(screen)
assert(visual)
visual = screen.root_visual

local win = xcb.gen_id()
local mask, values = xcb.mask_and_values({
	[C.XCB_CW_BACK_PIXMAP] = C.XCB_BACK_PIXMAP_PARENT_RELATIVE,
	[C.XCB_CW_EVENT_MASK]  = bit.bor(
		C.XCB_EVENT_MASK_EXPOSURE,
		C.XCB_EVENT_MASK_ENTER_WINDOW,
		--C.XCB_EVENT_MASK_LEAVE_WINDOW,
		0
	),
})
xcb.create_window(C.XCB_COPY_FROM_PARENT, win, screen.root,
	100, 100, 500, 300,
	0, C.XCB_WINDOW_CLASS_INPUT_OUTPUT, visual, mask, values)

local win2 = xcb.gen_id()
xcb.create_window(C.XCB_COPY_FROM_PARENT, win2, screen.root,
	100, 100, 300, 200,
	0, C.XCB_WINDOW_CLASS_INPUT_OUTPUT, visual, 0, nil)

xcb.set_transient_for(win2, win)

xcb.map(win)
xcb.map(win2)
xcb.flush()

local glxwin = win

local i = 1
while true do
	local e, etype = xcb.poll(true)
	if not e then return end
	if etype == C.XCB_EXPOSE then
		draw()
		glx.glXSwapBuffers(display, glxwin)
	end
end
