--!optimize 2
--!native

local angle = require(script.Parent.angle)
local getComponents = require(script.Parent.getComponents)
local inverseUnit = require(script.Parent.inverseUnit)
local set = require(script.Parent.set)
local slerpInPlace = require(script.Parent.slerpInPlace)
local types = require(script.Parent.types)

--[=[
	@function rotateTowardsInPlace
	@within Quaternion
	@param out Quaternion -- The quaternion to store the result.
	@param from Quaternion -- The starting quaternion.
	@param to Quaternion -- The target quaternion.
	@param maxRadiansDelta number -- The maximum angle in radians to rotate.
	@return Quaternion -- `out`
	@tag Method
	@tag Mutating
	Rotates one quaternion towards another by a maximum angle in radians, storing the result in `out`.  
	`out` can be the same quaternion as `from` or `to`.
]=]
return function(out: types.Quaternion, from: types.Quaternion, to: types.Quaternion, maxRadiansDelta: number): types.Quaternion
	if maxRadiansDelta < 0 then
		to = inverseUnit(to)
		maxRadiansDelta = -maxRadiansDelta
	end

	local a = angle(from, to)
	if a == 0 then return set(out, getComponents(from)) end

	local t = math.min(1, maxRadiansDelta / a)
	return slerpInPlace(out, from, to, t)
end
