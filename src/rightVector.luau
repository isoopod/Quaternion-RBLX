--!optimize 2

local types = require(script.Parent.types)
local xVector = require(script.Parent.xVector)

--[=[
	@function rightVector
	@within Quaternion
	@param q Quaternion -- The quaternion.
	@return Vector3 -- The right direction vector of the quaternion.
	@tag Property
	Gets the right direction vector of the quaternion (equivalent to Quaternion.xVector).
]=]
return function(q: types.Quaternion): Vector3 & vector
	return xVector(q)
end
