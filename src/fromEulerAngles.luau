--!optimize 2

local setEulerAngles = require(script.Parent.setEulerAngles)
local types = require(script.Parent.types)

--[=[
	@function fromEulerAngles
	@within Quaternion
	@param x number -- The rotation around the x-axis in radians (pitch).
	@param y number -- The rotation around the y-axis in radians (yaw).
	@param z number -- The rotation around the z-axis in radians (roll).
	@return Quaternion -- The resulting quaternion.
	@tag Constructor
	Creates a quaternion from Euler angles XYZ in radians.
]=]
return function(x: number, y: number, z: number): types.Quaternion
	local q = buffer.create(16) :: types.Quaternion
	return setEulerAngles(q, x, y, z)
end
