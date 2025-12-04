--!optimize 2
--!native

local getComponents = require(script.Parent.getComponents)
local set = require(script.Parent.set)
local types = require(script.Parent.types)

--[=[
	@function multiplyInPlace
	@within Quaternion
	@param out Quaternion -- The quaternion to store the result.
	@param lhs Quaternion -- The left-hand side quaternion.
	@param rhs Quaternion -- The right-hand side quaternion.
	@return Quaternion -- `out`
	@tag Method
	@tag Mutating
	Multiplies the left-hand side quaternion by the right-hand side quaternion in place, storing the result in `out`. 
	`out` can be the same quaternion as `lhs` or `rhs`.

	:::note
	Quaternion multiplication is not commutative; the order of multiplication matters.

	When you multiply two quaternions, you are applying one rotation after another.  
	The right-hand side quaternion (`rhs`) is applied first, and the left-hand side quaternion (`lhs`) is applied **after that**.  
	In other words, `lhs * rhs` is taking `rhs` and rotating it by `lhs`.

	This is the same as `CFrameA` * `CFrameB`; B is applied first and then transformed by A.
	:::
]=]
return function(out: types.Quaternion, lhs: types.Quaternion, rhs: types.Quaternion): types.Quaternion
	local x1, y1, z1, w1 = getComponents(lhs)
	local x2, y2, z2, w2 = getComponents(rhs)

	-- Hamilton product formula
	local x = w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2
	local y = w1 * y2 - x1 * z2 + y1 * w2 + z1 * x2
	local z = w1 * z2 + x1 * y2 - y1 * x2 + z1 * w2
	local w = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2

	return set(out, x, y, z, w)
end
