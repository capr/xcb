local xcb = require'xcb'
local ffi = require'ffi'
require'xcb_mwmutil_h'
require'xcb_icccm_h'

xcb = xcb.connect()
local C = xcb.C

local win = xcb.gen_id()
xcb.create_window(C.XCB_COPY_FROM_PARENT, win, xcb.screen.root,
	100, 100, 300, 200,
	0, C.XCB_WINDOW_CLASS_INPUT_OUTPUT, xcb.screen.root_visual, 0, nil)

local hints = ffi.new'xcb_icccm_wm_hints_t'
hints.initial_state = C.XCB_ICCCM_WM_STATE_ICONIC
hints.flags = C.XCB_ICCCM_WM_HINT_STATE
xcb.set_wm_hints(win, hints)

xcb.map(win)

xcb.flush()

while xcb.poll(true) do end