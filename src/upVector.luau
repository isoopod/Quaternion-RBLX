--!optimize 2

local types = require(script.Parent.types)
local yVector = require(script.Parent.yVector)

--[=[
	@function upVector
	@within Quaternion
	@param q Quaternion -- The quaternion.
	@return Vector3 -- The up direction vector of the quaternion.
	@tag Property
	Gets the up direction vector of the quaternion (equivalent to Quaternion.yVector).
]=]
return function(q: types.Quaternion): Vector3 & vector
	return yVector(q)
end
