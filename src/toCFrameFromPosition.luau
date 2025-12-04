--!optimize 2

local getComponents = require(script.Parent.getComponents)
local types = require(script.Parent.types)

--[=[
	@function toCFrameFromPosition
	@within Quaternion
	@param position Vector3 -- The position vector.
	@param q Quaternion -- The quaternion.
	@return CFrame -- The resulting CFrame.
	@tag Decomposition
	Converts the quaternion and position vector to a CFrame.  
	You can use `Quaternion.rotation` if position is not needed.
]=]
local function toCFrameFromPosition(position: vector, q: types.Quaternion): CFrame
	local x, y, z = position.x, position.y, position.z
	local qx, qy, qz, qw = getComponents(q)

	return CFrame.new(x, y, z, qx, qy, qz, qw)
end

return toCFrameFromPosition :: (position: types.Vector, q: types.Quaternion) -> CFrame
