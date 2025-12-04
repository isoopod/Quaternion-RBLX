--!optimize 2
--!native

local set = require(script.Parent.set)
local types = require(script.Parent.types)

--[=[
	@function setCFrame
	@within Quaternion
	@param q Quaternion -- The quaternion to set to the CFrame's rotation.
	@param cf CFrame -- The CFrame to convert.
	@return Quaternion -- `q`
	@tag Method
	@tag Mutating
	Creates a quaternion from a CFrame's rotation.
]=]
return function(q: types.Quaternion, cf: CFrame): types.Quaternion
	local _, _, _, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:GetComponents()

	local trace = m00 + m11 + m22
	if trace > 0 then
		local s = math.sqrt(trace + 1) * 2
		local sinv = 1 / s
		return set(q, (m21 - m12) * sinv, (m02 - m20) * sinv, (m10 - m01) * sinv, s * 0.25)
	else
		if m00 > m11 and m00 > m22 then
			local s = math.sqrt(1 + m00 - m11 - m22) * 2
			local sinv = 1 / s
			return set(q, s * 0.25, (m01 + m10) * sinv, (m02 + m20) * sinv, (m21 - m12) * sinv)
		elseif m11 > m22 then
			local s = math.sqrt(1 + m11 - m00 - m22) * 2
			local sinv = 1 / s
			return set(q, (m01 + m10) * sinv, s * 0.25, (m12 + m21) * sinv, (m02 - m20) * sinv)
		else
			local s = math.sqrt(1 + m22 - m00 - m11) * 2
			local sinv = 1 / s
			return set(q, (m02 + m20) * sinv, (m12 + m21) * sinv, s * 0.25, (m10 - m01) * sinv)
		end
	end
end
