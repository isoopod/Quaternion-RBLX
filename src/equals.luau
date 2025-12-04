--!optimize 2
--!native

local types = require(script.Parent.types)

--[=[
    @function equals
    @within Quaternion
    @param q1 Quaternion -- The first quaternion.
    @param q2 Quaternion -- The second quaternion.
    @return boolean -- Whether the two quaternions are equal.
	@tag Method
    Compares two quaternions for equality.
]=]
return function(q1: types.Quaternion, q2: types.Quaternion): boolean
	-- PROFILED: 8 `readf32` calls and 4 float comparisons beats 2 `tostring` or `readstring` calls and 1 string comparison
	return buffer.readf32(q1, 0) == buffer.readf32(q2, 0)
		and buffer.readf32(q1, 4) == buffer.readf32(q2, 4)
		and buffer.readf32(q1, 8) == buffer.readf32(q2, 8)
		and buffer.readf32(q1, 12) == buffer.readf32(q2, 12)
end
