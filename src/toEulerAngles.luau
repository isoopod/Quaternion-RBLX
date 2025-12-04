--!optimize 2
--!native
local getComponents = require(script.Parent.getComponents)
local types = require(script.Parent.types)

--[=[
	@function toEulerAngles
	@within Quaternion
	@param q Quaternion -- The quaternion.
	@return number, number, number -- The Euler angles (pitch, yaw, roll) in radians.
	@tag Decomposition
	Converts the quaternion to Euler angles (XYZ order) in radians.
]=]
return function(q: types.Quaternion): (number, number, number)
	local x, y, z, w = getComponents(q)

	-- Roll (x-axis rotation)
	local sinr_cosp = 2 * (w * x + y * z)
	local cosr_cosp = 1 - 2 * (x * x + y * y)
	local roll = math.atan2(sinr_cosp, cosr_cosp)

	-- Pitch (y-axis rotation)
	local sinp = 2 * (w * y - z * x)
	local pitch
	if math.abs(sinp) >= 1 then
		pitch = math.pi / 2 * math.sign(sinp) -- use 90 degrees if out of range
	else
		pitch = math.asin(sinp)
	end

	-- Yaw (z-axis rotation)
	local siny_cosp = 2 * (w * z + x * y)
	local cosy_cosp = 1 - 2 * (y * y + z * z)
	local yaw = math.atan2(siny_cosp, cosy_cosp)

	return pitch, yaw, roll
end
