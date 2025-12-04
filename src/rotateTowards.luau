--!optimize 2

local rotateTowardsInPlace = require(script.Parent.rotateTowardsInPlace)
local types = require(script.Parent.types)

--[=[
	@function rotateTowards
	@within Quaternion
	@param from Quaternion -- The starting quaternion.
	@param to Quaternion -- The target quaternion.
	@param maxRadiansDelta number -- The maximum angle in radians to rotate.
	@return Quaternion -- The resulting quaternion after rotation.
	@tag Method
	@tag Pure
	Rotates one quaternion towards another by a maximum angle in radians.
]=]
return function(from: types.Quaternion, to: types.Quaternion, maxRadiansDelta: number): types.Quaternion
	local q = buffer.create(16) :: types.Quaternion
	return rotateTowardsInPlace(q, from, to, maxRadiansDelta)
end
