local pp = require'pp'
local time = require'time'
local xcb = require'xcb'
local ffi = require'ffi'
local xlib_xcb = require'xlib_xcb'
require'glx_h'
local xlib = ffi.abi'64bit' and ffi.load'/usr/lib/x86_64-linux-gnu/libX11.so.6' or ffi.load'X11'
local glx = ffi.abi'64bit' and ffi.load'/usr/lib/x86_64-linux-gnu/mesa/libGL.so.1' or ffi.load'/usr/lib/mesa/libGL.so.1'

local function get_fbconfigs(display, screen)
	-- Query framebuffer configurations
	local num_fb_configs = ffi.new'int[1]'
	local fb_configs = glx.glXGetFBConfigs(display, screen, num_fb_configs)
	assert(fb_configs ~= nil)
	assert(num_fb_configs[0] > 0)
	return fb_configs, num_fb_configs[0]
end

local function get_visual_configs(display, screen)
	local nbuf = ffi.new'int[1]'
	local configs = glx.glXGetVisualConfigs(display, screen, nbuf)
	assert(configs ~= nil)
	assert(nbuf[0] > 0)
	return configs, nbuf[0]
end

local function get_visual_of_fbconfig(display, fbconfig)
	-- query visualID of a framebuffer config
	local visual = ffi.new'int[1]'
	glx.glXGetFBConfigAttrib(display, fbconfig, glx.GLX_VISUAL_ID, visual)
	return visual[0]
end

local function get_visual_of_fbconfig(display, fbconfig)
	local visual = glx.glXGetVisualFromFBConfig(display, fbconfig)
	return glx.XVisualIDFromVisual(visual.visual)
end

--connect via Xlib

local display = xlib.XOpenDisplay(nil)
assert(display ~= nil)
local default_screen = xlib.XDefaultScreen(display)

--bind Xlib connection to XCB

local conn = xlib_xcb.XGetXCBConnection(display)
assert(conn ~= nil)
assert(ffi.istype('xcb_connection_t*', conn))
local xcb = xcb.connect(conn)
local C = xcb.C
local screen = xcb.screen
xlib_xcb.XSetEventQueueOwner(display, C.XCBOwnsEventQueue)

--get fb configs

local fbconfigs, fbconfigs_num = get_fbconfigs(display, default_screen)

local valbuf = ffi.new'int[1]'
local function getattr(config, attr)
	assert(glx.glXGetFBConfigAttrib(display, config, attr, valbuf) == 0)
	return valbuf[0]
end
for i=0,fbconfigs_num-1 do
	--print(i, 'GLX_FBCONFIG_ID', getattr(fbconfigs[i], glx.GLX_FBCONFIG_ID))
end

for i=0,fbconfigs_num-1 do
	local config = fbconfigs[i]
	local vi = glx.glXGetVisualFromFBConfig(display, config)
	if vi ~= nil then
		print(i, vi.visualid, vi.depth, vi.red_mask, vi.green_mask, vi.blue_mask, vi.colormap_size, vi.bits_per_rgb)
	end
end
os.exit()

local fbconfig = fbconfigs[58] --the only 32bit visual
local visual = get_visual_of_fbconfig(display, fbconfig)

-- Create OpenGL context
local context = glx.glXCreateNewContext(display, fbconfig, glx.GLX_RGBA_TYPE, nil, 1)
assert(context ~= nil)

--make a colormap + window

local colormap = xcb.gen_id()
xcb.create_colormap(C.XCB_COLORMAP_ALLOC_NONE, colormap, screen.root, visual)

local win = xcb.gen_id()

local mask, values = xcb.mask_and_values({
	[C.XCB_CW_COLORMAP] = colormap,
	[C.XCB_CW_EVENT_MASK] = bit.bor(
		C.XCB_EVENT_MASK_EXPOSURE,
		C.XCB_EVENT_MASK_ENTER_WINDOW,
		--C.XCB_EVENT_MASK_LEAVE_WINDOW,
		0
	),
})

xcb.create_window(C.XCB_COPY_FROM_PARENT, win, screen.root,
	100, 100, 500, 300,
	0, C.XCB_WINDOW_CLASS_INPUT_OUTPUT, visual, mask, values)

-- NOTE: window must be mapped before glXMakeContextCurrent
xcb.map(win)

-- Create GLX Window
local glxwindow = glx.glXCreateWindow(display, fbconfig, win, nil)
assert(glxwindow ~= nil)
print(win, glxwindow)

-- make OpenGL context current
assert(glx.glXMakeCurrent(display, glxwindow, context) == 1)

function draw()
	gl.glClearColor(0.2, 0.4, 0.9, 1.0)
	gl.glClear(gl.GL_COLOR_BUFFER_BIT)
end

while true do
	local e, etype = xcb.poll(true)
	if not e then return end
	if etype == C.XCB_EXPOSE then
		--draw()
		--glx.glXSwapBuffers(display, glxwindow)
	end
end

glx.glXDestroyWindow(display, glxwindow)

xcb.destroy_window(win)

glx.glXDestroyContext(display, context)

xlib.XCloseDisplay(display)
