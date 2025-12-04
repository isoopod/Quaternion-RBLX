--!optimize 2

local nlerpInPlace = require(script.Parent.nlerpInPlace)
local types = require(script.Parent.types)

--[=[
    @function nlerp
    @within Quaternion
    @param from Quaternion -- The starting quaternion.
    @param to Quaternion -- The target quaternion.
    @param t number -- The interpolation factor (0 to 1).
    @return Quaternion -- The interpolated quaternion.
    @tag Method
	@tag Pure
    Linearly interpolates between two quaternions and normalizes the result.
]=]
return function(from: types.Quaternion, to: types.Quaternion, t: number): types.Quaternion
	local q = buffer.create(16) :: types.Quaternion
	return nlerpInPlace(q, from, to, t)
end
