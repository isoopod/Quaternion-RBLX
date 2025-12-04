--!optimize 2

local getComponents = require(script.Parent.getComponents)
local set = require(script.Parent.set)
local types = require(script.Parent.types)

--[=[
	@function inverseUnitInPlace
	@within Quaternion
	@param q Quaternion -- The unit quaternion to invert.
	@return Quaternion -- `q`
	@tag Method
	@tag Mutating
	Inverts a unit quaternion in place.  
	This is more efficient than `quaternion.inverseInPlace` since it assumes the quaternion is normalized.
	For a unit quaternion, the inverse is simply the conjugate.
	For non-unit quaternions, this will return the conjugate, not the inverse.
]=]
return function(q: types.Quaternion): types.Quaternion
	local x, y, z, w = getComponents(q)
	return set(q, -x, -y, -z, w)
end
