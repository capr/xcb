
--XCB binding.
--Written by Cosmin Apreutesei. Public Domain.

local ffi = require'ffi'
assert(ffi.os == 'Linux', 'platform not Linux')
require'xcb_h'
local C = ffi.load'xcb'
local M = {C = C}

return M
