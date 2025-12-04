--!optimize 2
--!native

local getComponents = require(script.Parent.getComponents)
local identity = require(script.Parent.identity)
local new = require(script.Parent.new)
local types = require(script.Parent.types)

--[=[
	@function normalize
	@within Quaternion
	@param q Quaternion -- The quaternion.
	@return Quaternion -- The normalized quaternion.
	@tag Method
	@tag Pure
	Returns a normalized version of the quaternion.
]=]
return function(q: types.Quaternion): types.Quaternion
	local x, y, z, w = getComponents(q)

	-- Use inline magnitude calculation to avoid extra reads
	local mag = math.sqrt(x * x + y * y + z * z + w * w)
	if mag > 0 then
		local invMag = 1 / mag
		return new(x * invMag, y * invMag, z * invMag, w * invMag)
	else
		return identity()
	end
end
