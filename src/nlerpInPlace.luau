--!optimize 2
--!native

local normalizeInPlace = require(script.Parent.normalizeInPlace)
local set = require(script.Parent.set)
local types = require(script.Parent.types)

--[=[
    @function nlerpInPlace
    @within Quaternion
    @param out Quaternion -- The quaternion to store the result.
    @param from Quaternion -- The starting quaternion.
    @param to Quaternion -- The target quaternion.
    @param t number -- The interpolation factor (0 to 1).
    @return Quaternion -- `out`
    @tag Method
    @tag Mutating
    Linearly interpolates between two quaternions and normalizes the result, storing it in `out`.  
    `out` can be the same quaternion as `from` or `to`.
]=]
return function(out: types.Quaternion, from: types.Quaternion, to: types.Quaternion, t: number): types.Quaternion
	local x = (1 - t) * buffer.readf32(from, 0) + t * buffer.readf32(to, 0)
	local y = (1 - t) * buffer.readf32(from, 4) + t * buffer.readf32(to, 4)
	local z = (1 - t) * buffer.readf32(from, 8) + t * buffer.readf32(to, 8)
	local w = (1 - t) * buffer.readf32(from, 12) + t * buffer.readf32(to, 12)
	set(out, x, y, z, w)
	return normalizeInPlace(out)
end
