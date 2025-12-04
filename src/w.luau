local types = require(script.Parent.types)

--[=[
    @function w
    @within Quaternion
    @param q Quaternion -- The quaternion.
    @return number -- The w component (real part).
	@tag Property
    Gets the w component of the quaternion.
]=]
return function(q: types.Quaternion): number
	return buffer.readf32(q, 12)
end
