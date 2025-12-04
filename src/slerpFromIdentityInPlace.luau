--!optimize 2
--!native

local getComponents = require(script.Parent.getComponents)
local identity = require(script.Parent.identity)
local nlerpInPlace = require(script.Parent.nlerpInPlace)
local set = require(script.Parent.set)
local types = require(script.Parent.types)

--[=[
    @function slerpFromIdentityInPlace
    @within Quaternion
    @param out Quaternion -- The quaternion to store the result.
    @param to Quaternion -- The target quaternion.
    @param t number -- The interpolation factor (0 to 1).
    @return Quaternion -- `out`
    @tag Method
    @tag Mutating
    Optimized SLERP from identity quaternion to `to`. Stores the result in `out`.  
    `out` can be the same quaternion as `from` or `to`.
]=]
return function(out: types.Quaternion, to: types.Quaternion, t: number): types.Quaternion
	local tx, ty, tz, tw = getComponents(to)
	if tw < 0 then
		tx, ty, tz, tw = -tx, -ty, -tz, -tw
	end

	local cosTheta = tw -- Dot(identity, to) = w
	local theta = math.acos(math.clamp(cosTheta, -1, 1))

	if theta < 1e-6 then
		-- Very small angle, fallback to NLERP
		return nlerpInPlace(out, identity(), to, t)
	else
		local sinTheta = math.sin(theta)
		local ratioA = math.sin((1 - t) * theta) / sinTheta -- This is always sin((1-t)*theta)/sin(theta)
		local ratioB = math.sin(t * theta) / sinTheta -- sin(t*theta)/sin(theta)

		local x = tx * ratioB
		local y = ty * ratioB
		local z = tz * ratioB
		local w = ratioA + tw * ratioB -- identity w = 1

		return set(out, x, y, z, w)
	end
end
