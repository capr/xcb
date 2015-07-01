
--XCB binding.
--Written by Cosmin Apreutesei. Public Domain.

local ffi = require'ffi'
require'xcb_h'
local C = ffi.os == 'OSX' and ffi.load'/usr/X11/lib/libxcb.1.dylib' or ffi.load'xcb'
local M = {C = C}

return M
