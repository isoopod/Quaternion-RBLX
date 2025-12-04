--!optimize 2

local getComponents = require(script.Parent.getComponents)
local new = require(script.Parent.new)
local types = require(script.Parent.types)

--[=[
	@function inverseUnit
	@within Quaternion
	@param q Quaternion -- The unit quaternion.
	@return Quaternion -- The inverse of the unit quaternion.
	@tag Method
	@tag Pure
	Returns the inverse of a unit quaternion.  
	This is more efficient than `quaternion.inverse` since it assumes the quaternion is normalized.
	For a unit quaternion, the inverse is simply the conjugate.
	For non-unit quaternions, this will return the conjugate, not the inverse.
]=]
return function(q: types.Quaternion): types.Quaternion
	local x, y, z, w = getComponents(q)
	return new(-x, -y, -z, w)
end
