--!optimize 2
--!native
local set = require(script.Parent.set)
local types = require(script.Parent.types)

--[=[
	@function setAxisAngle
	@within Quaternion
	@param q Quaternion -- The quaternion to set.
	@param axis Vector3 -- The axis of rotation.
	@param angle number -- The angle of rotation in radians.
	@tag Method
	@tag Mutating
	Sets an existing quaternion from an axis-angle representation.
]=]
return function(q: types.Quaternion, axis: vector, angle: number): types.Quaternion
	local halfAngle = angle * 0.5
	local s = math.sin(halfAngle)
	local x = axis.x * s
	local y = axis.y * s
	local z = axis.z * s
	local w = math.cos(halfAngle)
	return set(q, x, y, z, w)
end
