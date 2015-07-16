local pp = require'pp'
local time = require'time'
local xcb = require'xcb'
local ffi = require'ffi'
require'xcb_mwmutil_h'
require'xcb_icccm_h'

xcb = xcb.connect()
local C = xcb.C

local win = xcb.gen_id()
local mask, values = xcb.mask_and_values({
	[C.XCB_CW_BACK_PIXMAP] = C.XCB_BACK_PIXMAP_PARENT_RELATIVE,
	[C.XCB_CW_EVENT_MASK]  = bit.bor(
		C.XCB_EVENT_MASK_ENTER_WINDOW,
		C.XCB_EVENT_MASK_LEAVE_WINDOW,
		0
	),
})
xcb.create_window(C.XCB_COPY_FROM_PARENT, win, xcb.screen.root,
	100, 100, 500, 300,
	0, C.XCB_WINDOW_CLASS_INPUT_OUTPUT, xcb.screen.root_visual, mask, values)

xcb.map(win)
xcb.flush()

--[[
local win2 = xcb.gen_id()
xcb.create_window(C.XCB_COPY_FROM_PARENT, win2, xcb.screen.root,
	100, 100, 300, 200,
	0, C.XCB_WINDOW_CLASS_INPUT_OUTPUT, xcb.screen.root_visual, 0, nil)

xcb.set_transient_for(win2, win)

local hints = ffi.new'xcb_motif_wm_hints_t'
hints.flags = bit.bor(
	C.MWM_HINTS_FUNCTIONS,
	C.MWM_HINTS_DECORATIONS)
hints.functions = bit.bor(
	C.MWM_FUNC_RESIZE,
	C.MWM_FUNC_MOVE,
	C.MWM_FUNC_MINIMIZE,
	C.MWM_FUNC_MAXIMIZE)
hints.decorations = bit.bor(
	C.MWM_DECOR_BORDER,
	C.MWM_DECOR_TITLE,
	C.MWM_DECOR_MENU,
	C.MWM_DECOR_RESIZEH)
xcb.set_motif_wm_hints(win2, hints)

xcb.map(win2)
]]

--[[
pp(xcb.get_xsettings())
local fid = xcb.gen_id()
xcb.open_font(fid, 'cursor')
xcb.flush()
local cid = 0
]]

while true do
	local e, etype = xcb.poll(true)
	if not e then return end
	print(etype)

	--time.sleep(1)
	pp('>>', xcb.get_wm_state(win))

	--[[
	local cid = xcb.gen_id()
	local sc, mc = cid, cid
	xcb.create_glyph_cursor(cid, fid, fid, sc, mc, 0, 0, 0, 0, 0, 0)
	xcb.set_cursor(win, cid)
	xcb.flush()
	cid = cid + 1
	]]
end
