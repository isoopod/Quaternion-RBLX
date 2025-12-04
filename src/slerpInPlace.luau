--!optimize 2
--!native

local dot = require(script.Parent.dot)
local inverseUnitInPlace = require(script.Parent.inverseUnitInPlace)
local nlerpInPlace = require(script.Parent.nlerpInPlace)
local set = require(script.Parent.set)
local types = require(script.Parent.types)

--[=[
    @function slerpInPlace
    @within Quaternion
    @param out Quaternion -- The quaternion to store the result.
    @param from Quaternion -- The starting quaternion.
    @param to Quaternion -- The target quaternion.
    @param t number -- The interpolation factor (0 to 1).
    @return Quaternion -- `out`
    @tag Method
    @tag Mutating
    Spherically interpolates between two quaternions and stores the result in `out`.  
    `out` can be the same quaternion as `from` or `to`.
]=]
return function(out: types.Quaternion, from: types.Quaternion, to: types.Quaternion, t: number): types.Quaternion
	local d = dot(from, to)

	if d < 0 then
		inverseUnitInPlace(to)
		d = -d
	end
	local theta = math.acos(math.clamp(d, -1, 1))
	local sinTheta = math.sin(theta)

	if sinTheta < 1e-6 then
		return nlerpInPlace(out, from, to, t)
	else
		local ratioA = math.sin((1 - t) * theta) / sinTheta
		local ratioB = math.sin(t * theta) / sinTheta

		local x = ratioA * buffer.readf32(from, 0) + ratioB * buffer.readf32(to, 0)
		local y = ratioA * buffer.readf32(from, 4) + ratioB * buffer.readf32(to, 4)
		local z = ratioA * buffer.readf32(from, 8) + ratioB * buffer.readf32(to, 8)
		local w = ratioA * buffer.readf32(from, 12) + ratioB * buffer.readf32(to, 12)

		return set(out, x, y, z, w)
	end
end
