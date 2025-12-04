--!optimize 2
--!native

local getComponents = require(script.Parent.getComponents)
local types = require(script.Parent.types)

--[=[
    @function zVector
    @within Quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3 -- The forward direction vector of the quaternion.
	@tag Property
    Gets the forward direction vector of the quaternion (opposite to lookVector).
]=]
return function(q: types.Quaternion): Vector3 & vector
	local x, y, z, w = getComponents(q)

	return vector.create(1 - 2 * (y * y + z * z), 2 * (x * y + w * z), 2 * (x * z - w * y)) :: any
end
