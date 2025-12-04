--!optimize 2

local getComponents = require(script.Parent.getComponents)
local types = require(script.Parent.types)

--[=[
    @function toCFrame
    @within Quaternion
    @param x number -- The x position.
    @param y number -- The y position.
    @param z number -- The z position.
    @param q Quaternion -- The quaternion.
    @return CFrame -- The resulting CFrame.
	@tag Decomposition
    Converts the quaternion and position to a CFrame.  
    You can use `Quaternion.rotation` if position is not needed.
]=]
return function(x: number, y: number, z: number, q: types.Quaternion): CFrame
	local qx, qy, qz, qw = getComponents(q)

	return CFrame.new(x, y, z, qx, qy, qz, qw)
end
