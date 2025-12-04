--!optimize 2
--!native

local getComponents = require(script.Parent.getComponents)
local types = require(script.Parent.types)

--[=[
    @function toAxisAngle
    @within Quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3, number -- The axis of rotation as a Vector3 and the angle in radians.
	@tag Decomposition
    Converts the quaternion to an axis-angle representation.
]=]
return function(q: types.Quaternion): (Vector3 & vector, number)
	local x, y, z, w = getComponents(q)

	local angle = math.acos(w) * 2
	local s = math.sqrt(1 - w * w)

	if s < 1e-6 then
		return vector.create(1, 0, 0) :: any, angle
	else
		local sinv = 1 / s
		return vector.create(x * sinv, y * sinv, z * sinv) :: any, angle
	end
end
