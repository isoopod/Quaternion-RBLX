--!optimize 2

local setLookRotation = require(script.Parent.setLookRotation)
local types = require(script.Parent.types)

--[=[
	@function lookAlong
	@within Quaternion
	@param forward Vector3 -- The forward direction vector.
	@param up Vector3 -- The up direction vector.
	@return Quaternion -- The resulting quaternion representing the rotation.
	@tag Constructor
	Creates a quaternion that represents a rotation looking in a specified forward direction with a given up direction.
]=]
return function(forward: types.Vector, up: types.Vector): types.Quaternion
	local q = buffer.create(16) :: types.Quaternion
	return setLookRotation(q, forward, up)
end
