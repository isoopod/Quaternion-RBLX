--!optimize 2

local dot = require(script.Parent.dot)
local types = require(script.Parent.types)

--[=[
	@function fuzzyEquals
	@within Quaternion
	@param q1 Quaternion
	@param q2 Quaternion
	@param epsilon number -- Allowed rotational error.
	@return boolean
	@tag Method
	Checks approximate rotational equality within epsilon using the quaternion dot product.
]=]
return function(q1: types.Quaternion, q2: types.Quaternion, epsilon: number): boolean
	local d = dot(q1, q2)
	if d < 0 then d = -d end

	return d >= 1 - epsilon
end
