--!optimize 2
--!native
local set = require(script.Parent.set)
local types = require(script.Parent.types)

--[=[
	@function setEulerAngles
	@within Quaternion
	@param q Quaternion -- The quaternion to set.
	@param x number -- The rotation around the x-axis in radians (pitch).
	@param y number -- The rotation around the y-axis in radians (yaw).
	@param z number -- The rotation around the z-axis in radians (roll).
	@return Quaternion -- `q`
	@tag Method
	@tag Mutating
	Sets an existing quaternion from Euler angles XYZ in radians.
]=]
return function(q: types.Quaternion, pitch: number, yaw: number, roll: number): types.Quaternion
	local cy = math.cos(yaw * 0.5)
	local sy = math.sin(yaw * 0.5)
	local cp = math.cos(pitch * 0.5)
	local sp = math.sin(pitch * 0.5)
	local cr = math.cos(roll * 0.5)
	local sr = math.sin(roll * 0.5)

	local w = cr * cp * cy + sr * sp * sy
	local x = sr * cp * cy - cr * sp * sy
	local y = cr * sp * cy + sr * cp * sy
	local z = cr * cp * sy - sr * sp * cy

	return set(q, x, y, z, w)
end
