--!optimize 2

local getComponents = require(script.Parent.getComponents)
local types = require(script.Parent.types)

--[=[
    @function rotation
    @within Quaternion
    @param q Quaternion -- The quaternion.
    @return CFrame -- The CFrame representing the rotation of the quaternion.
	@tag Property
    Converts the quaternion to a CFrame representing its rotation.
]=]
return function(q: types.Quaternion): CFrame
	local x, y, z, w = getComponents(q)

	return CFrame.new(0, 0, 0, x, y, z, w)
end
