local types = require(script.Parent.types)

--[=[
    @function y
    @within Quaternion
    @param q Quaternion -- The quaternion.
    @return number -- The y component (j).
	@tag Property
    Gets the y component of the quaternion.
]=]
return function(q: types.Quaternion): number
	return buffer.readf32(q, 4)
end
