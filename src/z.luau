local types = require(script.Parent.types)

--[=[
	@function z
	@within Quaternion
	@param q Quaternion -- The quaternion.
	@return number -- The z component (k).
	@tag Property
	Gets the z component of the quaternion.
]=]
return function(q: types.Quaternion): number
	return buffer.readf32(q, 8)
end
