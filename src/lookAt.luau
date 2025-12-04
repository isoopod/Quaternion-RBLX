--!optimize 2

local lookAlong = require(script.Parent.lookAlong)
local types = require(script.Parent.types)

local UP_AXIS = vector.create(0, 1, 0)

--[=[
	@function lookAt
	@within Quaternion
	@param from Vector3 -- The starting position.
	@param to Vector3 -- The target position to look at.
	@param up Vector3? -- Optional up direction vector. Defaults to (0, 1, 0) if not provided.
	@return Quaternion -- The resulting quaternion representing the rotation to look at the target.
	@tag Constructor
	Creates a quaternion that represents a rotation looking from one position to another, with an optional up direction.
]=]
return function(from: types.Vector, to: types.Vector, up: types.Vector?): types.Quaternion
	local forward = vector.normalize((to :: any) - (from :: any))
	return lookAlong(forward, up or UP_AXIS)
end
