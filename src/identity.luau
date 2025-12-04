--!optimize 2

local types = require(script.Parent.types)

--[=[
    @function identity
    @within Quaternion
    @return Quaternion -- The identity quaternion (0, 0, 0, 1).
	@tag Constructor
    Creates and returns the identity quaternion.
]=]
return function(): types.Quaternion
	local q = buffer.create(16) :: types.Quaternion
	buffer.writef32(q, 12, 1)
	return q
end
