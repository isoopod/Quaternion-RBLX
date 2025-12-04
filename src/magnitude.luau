--!optimize 2

local magnitudeSquared = require(script.Parent.magnitudeSquared)
local types = require(script.Parent.types)

--[=[
	@function magnitude
	@within Quaternion
	@param q Quaternion -- The quaternion.
	@return number -- The magnitude of the quaternion.
	@tag Property
	Gets the magnitude (length) of the quaternion.
]=]
return function(q: types.Quaternion): number
	return math.sqrt(magnitudeSquared(q))
end
