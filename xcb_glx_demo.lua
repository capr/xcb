local xcb = require'xcb'
local xlib = require'xlib'
local glx = require'glx'
local ffi = require'ffi'
local pp = require'pp'
local time = require'time'
require'gl11'

--connect via Xlib

local xlib = xlib.connect()
local conn = xlib.xcb_connection()
local xcb = xcb.connect(conn)
local glx = glx.connect(xlib)
local C = xcb.C
local gl = glx.C
--xlib.xcb_owns_queue()

local visual = xcb.screen.root_visual
local fbconfig = glx.get_fbconfig_of_visual(visual); assert(fbconfig ~= nil)
local context = glx.create_context(fbconfig); assert(context ~= nil)

local colormap = xcb.gen_id()
xcb.create_colormap(C.XCB_COLORMAP_ALLOC_NONE, colormap, xcb.screen.root, visual)

local win = xcb.gen_id()
local mask, values = xcb.mask_and_values({
	[C.XCB_CW_BACK_PIXMAP] = 0,
	[C.XCB_CW_BORDER_PIXEL] = 0,
	[C.XCB_CW_COLORMAP] = colormap,
	[C.XCB_CW_EVENT_MASK] = bit.bor(
		C.XCB_EVENT_MASK_EXPOSURE,
		C.XCB_EVENT_MASK_ENTER_WINDOW,
		--C.XCB_EVENT_MASK_LEAVE_WINDOW,
		0
	),
})
xcb.create_window(C.XCB_COPY_FROM_PARENT, win, xcb.screen.root,
	100, 100, 500, 300,
	0, C.XCB_WINDOW_CLASS_INPUT_OUTPUT, visual, mask, values)

-- NOTE: window must be mapped before glXMakeContextCurrent
xcb.map(win)
xcb.flush()

-- Create GLX Window
--local glxwindow = glx.glXCreateWindow(display, fbconfig, win, nil)
--assert(glxwindow ~= nil)
--print(win, glxwindow)
local glxwin = win

-- make OpenGL context current
glx.make_current(glxwin, context)

function draw()
	gl.glDrawBuffer(gl.GL_BACK)
	gl.glClearColor(0.2, 0.4, 0.9, 0.5)
	gl.glClear(bit.bor(gl.GL_COLOR_BUFFER_BIT, gl.GL_DEPTH_BUFFER_BIT))
end

while true do
	local e, etype = xlib.poll(true)
	if not e then return end
	if etype == C.XCB_EXPOSE then
		draw()
		glx.swap_buffers(glxwin)
	elseif etype == C.XCB_ENTER_NOTIFY then
		break
	end
end

--glx.glXDestroyWindow(display, glxwin)

glx.destroy_context(context)
xcb.destroy_window(win)
xlib.disconnect()
print'Done.'
