--!optimize 2

local types = require(script.Parent.types)

--[=[
	@function set
	@within Quaternion
	@param q Quaternion -- The quaternion.
	@param x number -- The x component (i).
	@param y number -- The y component (j).
	@param z number -- The z component (k).
	@param w number -- The w component (real part).
	@return Quaternion -- `q`
	@tag Method
	@tag Mutating
	Sets the components of the quaternion.
]=]
return function(q: types.Quaternion, x: number, y: number, z: number, w: number): types.Quaternion
	buffer.writef32(q, 0, x)
	buffer.writef32(q, 4, y)
	buffer.writef32(q, 8, z)
	buffer.writef32(q, 12, w)
	return q
end
