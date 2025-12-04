--!optimize 2
--!native

local getComponents = require(script.Parent.getComponents)
local set = require(script.Parent.set)
local types = require(script.Parent.types)

--[=[
    @function normalizeInPlace
    @within Quaternion
    @param q Quaternion -- The quaternion to normalize.
	@return Quaternion -- `q`
	@tag Method
    @tag Mutating
    Normalizes the quaternion in place.
]=]
return function(q: types.Quaternion): types.Quaternion
	local x, y, z, w = getComponents(q)

	-- Use inline magnitude calculation to avoid extra reads
	local mag = math.sqrt(x * x + y * y + z * z + w * w)
	if mag > 0 then
		local invMag = 1 / mag
		return set(q, x * invMag, y * invMag, z * invMag, w * invMag)
	else
		return set(q, 0, 0, 0, 1)
	end
end
