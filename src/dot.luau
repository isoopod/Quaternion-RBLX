--!optimize 2
--!native

local types = require(script.Parent.types)

--[=[
    @function dot
    @within Quaternion
    @param q1 Quaternion -- The first quaternion.
    @param q2 Quaternion -- The second quaternion.
    @return number -- The dot product of the two quaternions.
	@tag Method
    Calculates the dot product of two quaternions.
]=]
return function(q1: types.Quaternion, q2: types.Quaternion): number
	return buffer.readf32(q1, 0) * buffer.readf32(q2, 0)
		+ buffer.readf32(q1, 4) * buffer.readf32(q2, 4)
		+ buffer.readf32(q1, 8) * buffer.readf32(q2, 8)
		+ buffer.readf32(q1, 12) * buffer.readf32(q2, 12)
end
