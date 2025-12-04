--!optimize 2
--!native

local types = require(script.Parent.types)

--[=[
	@function getComponents
	@within Quaternion
	@param q Quaternion -- The quaternion.
	@return number, number, number, number -- The components (x, y, z, w).
	@tag Decomposition
	Gets all components of the quaternion.
]=]
return function(q: types.Quaternion): (number, number, number, number)
	return buffer.readf32(q, 0), buffer.readf32(q, 4), buffer.readf32(q, 8), buffer.readf32(q, 12)
end
