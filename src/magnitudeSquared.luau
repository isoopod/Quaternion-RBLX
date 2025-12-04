--!optimize 2
--!native

local getComponents = require(script.Parent.getComponents)
local types = require(script.Parent.types)

--[=[
	@function magnitudeSquared
	@within Quaternion
	@param q Quaternion -- The quaternion.
	@return number -- The squared magnitude of the quaternion.
	@tag Property
	Gets the squared magnitude of the quaternion.
]=]
return function(q: types.Quaternion): number
	local x, y, z, w = getComponents(q)
	return x * x + y * y + z * z + w * w
end
