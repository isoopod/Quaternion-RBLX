--!optimize 2
local setFromToRotation = require(script.Parent.setFromToRotation)
local types = require(script.Parent.types)

--[=[
	@function fromToRotation
	@within Quaternion
	@param from Vector3 -- The starting direction vector.
	@param to Vector3 -- The target direction vector.
	@return Quaternion -- The resulting quaternion representing the rotation from `from` to `to`.
	@tag Constructor
	Creates a quaternion that represents the rotation from one direction vector to another.
]=]
return function(from: types.Vector, to: types.Vector): types.Quaternion
	local q = buffer.create(16) :: types.Quaternion
	return setFromToRotation(q, from, to)
end
