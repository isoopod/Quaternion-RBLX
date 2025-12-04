--!optimize 2
--!native

local getComponents = require(script.Parent.getComponents)
local set = require(script.Parent.set)
local types = require(script.Parent.types)

--[=[
    @function multiply
    @within Quaternion
    @param lhs Quaternion -- The left-hand side quaternion.
    @param rhs Quaternion -- The right-hand side quaternion.
    @return Quaternion -- `lhs`
	@tag Method
    @tag Pure
    Multiplies the left-hand side quaternion by the right-hand side quaternion in place, modifying the left-hand side quaternion.

    :::note
    Quaternion multiplication is not commutative; the order of multiplication matters.  
    Think of it as rotating the lhs quaternion by the rhs quaternion.
    :::
]=]
return function(lhs: types.Quaternion, rhs: types.Quaternion): types.Quaternion
	local x1, y1, z1, w1 = getComponents(lhs)
	local x2, y2, z2, w2 = getComponents(rhs)

	-- Hamilton product formula
	local x = w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2
	local y = w1 * y2 - x1 * z2 + y1 * w2 + z1 * x2
	local z = w1 * z2 + x1 * y2 - y1 * x2 + z1 * w2
	local w = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2

	return set(lhs, x, y, z, w)
end
