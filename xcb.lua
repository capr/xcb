
--XCB binding.

local ffi = require'ffi'
assert(ffi.os == 'Linux', 'platform not Linux')
require'xcb_h'
local C = ffi.load'xcb'
local M = setmetatable({C = C}, {__index = C})

--create an atom cache and API for getting atoms
function M.atom_map(c)
	local atom_map = {}
	--register one or more atoms and return them as a hash {name = atom}
	local function atoms(...)
		local t = {}
		local argc = select('#', ...)
		for i = 1, argc do
			local s = select(i, ...)
			if not atom_map[s] then
				t[s] = C.xcb_intern_atom(c, 1, #s, s)
			end
		end
		for s, cookie in pairs(t) do
			local reply = C.xcb_intern_atom_reply(c, cookie, nil)
			atom_map[s] = reply.atom
		end
		return atom_map
	end
	--register a single atom and return it
	local function atom(s)
		return atoms(s)[s]
	end
	return atoms, atom
end

function M.iterator(iter_func, next_func)
	return function(...)
		local iter = iter_func(...)
		local i = 1
		return function()
			if i == 1 then
				if iter.rem == 0 then return end
				return i, iter.data
			else
				next_func(iter)
				if iter.rem == 0 then return end
				i = i + 1
				return i, iter.data
			end
		end
	end
end

return M
