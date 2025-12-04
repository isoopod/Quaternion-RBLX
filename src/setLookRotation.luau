--!optimize 2
--!native

local set = require(script.Parent.set)
local types = require(script.Parent.types)

--[=[
	@function setLookRotation
	@within Quaternion
	@param q Quaternion -- The quaternion to set.
	@param forward Vector3 -- The forward direction vector.
	@param up Vector3 -- The up direction vector.
	@return Quaternion -- `q`
	@tag Method
	@tag Mutating
	Sets an existing quaternion so that it represents a rotation looking in a specified forward direction with a given up direction.
]=]
local function setLookRotation(q: types.Quaternion, forward: vector, up: vector): types.Quaternion
	local f = vector.normalize(forward)
	local r = vector.normalize(vector.cross(up, f))
	local u = vector.cross(f, r)

	local trace = r.x + u.y + f.z
	if trace > 0 then
		local s = math.sqrt(trace + 1) * 2
		local sinv = 1 / s
		return set(q, (u.z - f.y) * sinv, (f.x - r.z) * sinv, (r.y - u.x) * sinv, s * 0.25)
	else
		if r.x > u.y and r.x > f.z then
			local s = math.sqrt(1 + r.x - u.y - f.z) * 2
			local sinv = 1 / s
			return set(q, s * 0.25, (u.x + r.y) * sinv, (f.x + r.z) * sinv, (u.z - f.y) * sinv)
		elseif u.y > f.z then
			local s = math.sqrt(1 + u.y - r.x - f.z) * 2
			local sinv = 1 / s
			return set(q, (f.x + r.z) * sinv, s * 0.25, (u.y + r.x) * sinv, (f.y - r.z) * sinv)
		else
			local s = math.sqrt(1 + f.z - r.x - u.y) * 2
			local sinv = 1 / s
			return set(q, (u.z - f.y) * sinv, (f.y + r.z) * sinv, s * 0.25, (r.x - u.y) * sinv)
		end
	end
end

return setLookRotation :: (q: types.Quaternion, forward: types.Vector, up: types.Vector) -> types.Quaternion
