--!optimize 2
--!native

local getComponents = require(script.Parent.getComponents)
local set = require(script.Parent.set)
local types = require(script.Parent.types)

--[=[
	@function inverseInPlace
	@within Quaternion
	@param q Quaternion -- The quaternion to invert.
	@return Quaternion -- `q`
	@tag Method
	@tag Mutating
	Inverts the quaternion in place.
]=]
return function(q: types.Quaternion): types.Quaternion
	local x, y, z, w = getComponents(q)

	local magSq = x * x + y * y + z * z + w * w
	if magSq > 0 then
		local invMagSq = 1 / magSq
		return set(q, -x * invMagSq, -y * invMagSq, -z * invMagSq, w * invMagSq)
	else
		-- Set to identity quaternion if magnitude is zero to avoid division by zero
		return set(q, 0, 0, 0, 1)
	end
end
