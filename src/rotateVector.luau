--!optimize 2
--!native

local getComponents = require(script.Parent.getComponents)
local types = require(script.Parent.types)

--[=[
	@function rotateVector
	@within Quaternion
	@param q Quaternion -- The quaternion.
	@param v Vector3 -- The vector to rotate.
	@return Vector3 -- The rotated vector.
	@tag Method
	Rotates a vector by the quaternion.
]=]
local function rotateVector(q: types.Quaternion, v: vector): vector
	local qx, qy, qz, s = getComponents(q)
	local u = vector.create(qx, qy, qz)
	-- u is the imaginary vector part of the quaternion
	-- s is the real scalar part of the quaternion

	-- Quaternion-vector multiplication (q * v * q^-1)
	local uv = vector.cross(u, v)
	local uDotv = vector.dot(u, v)
	local uLenSq = vector.dot(u, u)

	return (u * (2 * uDotv)) + (v * (s * s - uLenSq)) + (uv * (2 * s))
end

return rotateVector :: (q: types.Quaternion, v: types.Vector) -> Vector3 & vector
