--!optimize 2

local types = require(script.Parent.types)

--[=[
    @function tostring
    @within Quaternion
    @param q Quaternion -- The quaternion.
    @param format string? -- Optional format string for each component.
    @return string -- The string representation of the quaternion.
	@tag Decomposition
    Converts the quaternion to a string representation.  
    Quaternion does not have a metatable to support the `__tostring` metamethod, so this function must be used explicitly.
]=]
return function(q: types.Quaternion, format: string?): string
	return string.format(format or "Quaternion(%.6f, %.6f, %.6f, %.6f)", buffer.readf32(q, 0), buffer.readf32(q, 4), buffer.readf32(q, 8), buffer.readf32(q, 12))
end
