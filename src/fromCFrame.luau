--!optimize 2

local setCFrame = require(script.Parent.setCFrame)
local types = require(script.Parent.types)

--[=[
    @function fromCFrame
    @within Quaternion
    @param cf CFrame -- The CFrame to convert.
    @return Quaternion -- The resulting quaternion.
	@tag Constructor
    Creates a quaternion from a CFrame's rotation.
]=]
return function(cf: CFrame): types.Quaternion
	local q = buffer.create(16) :: types.Quaternion
	return setCFrame(q, cf)
end
