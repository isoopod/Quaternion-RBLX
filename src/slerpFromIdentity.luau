--!optimize 2

local slerpFromIdentityInPlace = require(script.Parent.slerpFromIdentityInPlace)
local types = require(script.Parent.types)

--[=[
    @function slerpFromIdentity
    @within Quaternion
    @param to Quaternion -- The target quaternion.
    @param t number -- The interpolation factor (0 to 1).
    @return Quaternion -- The spherically interpolated quaternion from identity.
    @tag Method
    @tag Pure
	Optimized SLERP from identity quaternion to `to`.
]=]
return function(to: types.Quaternion, t: number): types.Quaternion
	local q = buffer.create(16) :: types.Quaternion
	return slerpFromIdentityInPlace(q, to, t)
end
