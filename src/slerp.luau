--!optimize 2

local slerpInPlace = require(script.Parent.slerpInPlace)
local types = require(script.Parent.types)

--[=[
	@function slerp
	@within Quaternion
	@param from Quaternion -- The starting quaternion.
	@param to Quaternion -- The target quaternion.
	@param t number -- The interpolation factor (0 to 1).
	@return Quaternion -- The spherically interpolated quaternion.
	@tag Method
	@tag Pure
	Spherically interpolates between two quaternions.
]=]
return function(from: types.Quaternion, to: types.Quaternion, t: number): types.Quaternion
	local q = buffer.create(16) :: types.Quaternion
	return slerpInPlace(q, from, to, t)
end
