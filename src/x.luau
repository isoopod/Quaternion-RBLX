local types = require(script.Parent.types)

--[=[
    @function x
    @within Quaternion
    @param q Quaternion -- The quaternion.
    @return number -- The x component (i).
	@tag Property
    Gets the x component of the quaternion.
]=]
return function(q: types.Quaternion): number
	return buffer.readf32(q, 0)
end
