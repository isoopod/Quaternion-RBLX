--!optimize 2

local dot = require(script.Parent.dot)
local types = require(script.Parent.types)

--[=[
	@function angle
	@within Quaternion
	@param q1 Quaternion -- The first quaternion.
	@param q2 Quaternion -- The second quaternion.
	@return number -- The angle in radians between the two quaternions.
	@tag Method
	Calculates the angle in radians between two quaternions.
]=]
return function(q1: types.Quaternion, q2: types.Quaternion): number
	local d = dot(q1, q2)
	return math.acos(math.clamp(d, -1, 1)) * 2
end
