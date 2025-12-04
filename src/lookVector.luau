--!optimize 2

local types = require(script.Parent.types)
local zVector = require(script.Parent.zVector)

--[=[
    @function lookVector
    @within Quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3 -- The look direction vector of the quaternion.
	@tag Property
    Gets the look direction vector of the quaternion (opposite to zVector).
]=]
return function(q: types.Quaternion): Vector3 & vector
	return -zVector(q) :: any
end
