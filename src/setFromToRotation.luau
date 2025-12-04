--!optimize 2
--!native

local set = require(script.Parent.set)
local types = require(script.Parent.types)

local X_AXIS, Y_AXIS = vector.create(1, 0, 0), vector.create(0, 1, 0)

--[=[
	@function setFromToRotation
	@within Quaternion
	@param q Quaternion -- The quaternion to set.
	@param from Vector3 -- The starting direction vector.
	@param to Vector3 -- The target direction vector.
	@return Quaternion -- `q`
	@tag Method
	@tag Mutating
	Sets an existing quaternion so that it represents the rotation from one direction vector to another.
]=]
local function setFromToRotation(q: types.Quaternion, from: vector, to: vector): types.Quaternion
	local fromNorm = vector.normalize(from)
	local toNorm = vector.normalize(to)

	local dot = vector.dot(fromNorm, toNorm)
	if dot >= 1.0 or dot ~= dot then
		-- If vectors are identical or NaN, return identity quaternion
		return set(q, 0, 0, 0, 1)
	elseif dot <= -1.0 then
		-- If vectors are opposite, find an orthogonal axis for rotation and rotate 180 degrees
		local axis = vector.cross(fromNorm, X_AXIS)
		if vector.dot(axis, axis) < 1e-12 then axis = vector.cross(fromNorm, Y_AXIS) end
		return set(q, axis.x * math.sin(math.pi / 2), axis.y * math.sin(math.pi / 2), axis.z * math.sin(math.pi / 2), math.cos(math.pi / 2))
	else
		-- General case
		local s = math.sqrt((1 + dot) * 2)
		local invs = 1 / s
		local c = vector.cross(fromNorm, toNorm)
		return set(q, c.x * invs, c.y * invs, c.z * invs, s * 0.5)
	end
end

return setFromToRotation :: (q: types.Quaternion, from: types.Vector, to: types.Vector) -> types.Quaternion
