--!optimize 2

local set = require(script.Parent.set)
local types = require(script.Parent.types)

--[=[
	@function new
	@within Quaternion
	@param x number -- The x component (i).
	@param y number -- The y component (j).
	@param z number -- The z component (k).
	@param w number -- The w component (real part).
	@return Quaternion -- The quaternion data structure.
	@tag Constructor
	Creates a new Quaternion.
]=]
return function(x: number, y: number, z: number, w: number): types.Quaternion
	local q = buffer.create(16) :: types.Quaternion
	set(q, x, y, z, w)
	return q
end
