--!optimize 2

local setAxisAngle = require(script.Parent.setAxisAngle)
local types = require(script.Parent.types)

--[=[
	@function fromAxisAngle
	@within Quaternion
	@param axis Vector3 -- The axis of rotation.
	@param angle number -- The angle in radians.
	@return Quaternion -- The resulting quaternion.
	@tag Constructor
	Creates a quaternion from an axis-angle representation.
]=]
return function(axis: types.Vector, angle: number): types.Quaternion
	local q = buffer.create(16) :: types.Quaternion
	return setAxisAngle(q, axis :: any, angle)
end
