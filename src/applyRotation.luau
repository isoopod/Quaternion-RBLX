--!optimize 2

local getComponents = require(script.Parent.getComponents)
local types = require(script.Parent.types)

--[=[
	@function applyRotation
	@within Quaternion
	@param target PVInstance -- A part or model to set the rotation of
	@param q Quaternion -- The quaternion.
	@tag Method
	Applies the quaternion's rotation to the target without touching its position.
]=]
return function(target: PVInstance, q: types.Quaternion)
	local position: vector = target:GetPivot().Position :: any
	local x, y, z = position.x, position.y, position.z
	local qx, qy, qz, qw = getComponents(q)

	target:PivotTo(CFrame.new(x, y, z, qx, qy, qz, qw))
end
