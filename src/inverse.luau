--!optimize 2
--!native

local getComponents = require(script.Parent.getComponents)
local identity = require(script.Parent.identity)
local new = require(script.Parent.new)
local types = require(script.Parent.types)

--[=[
	@function inverse
	@within Quaternion
	@param q Quaternion -- The quaternion.
	@return Quaternion -- The inverse of the quaternion.
	@tag Method
	@tag Pure
	Returns the inverse of the quaternion.
]=]
return function(q: types.Quaternion): types.Quaternion
	local x, y, z, w = getComponents(q)

	-- Use inline magnitudeSq calculation to avoid extra reads
	local magSq = x * x + y * y + z * z + w * w
	if magSq > 0 then
		local invMagSq = 1 / magSq
		return new(-x * invMagSq, -y * invMagSq, -z * invMagSq, w * invMagSq)
	else
		-- Return identity quaternion if magnitude is zero to avoid division by zero
		return identity()
	end
end
