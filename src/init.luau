--!strict
--!optimize 2
--!native

local X_AXIS, Y_AXIS = vector.create(1, 0, 0), vector.create(0, 1, 0)

--[=[
    @class quaternion

    This library orders the quaternion components as `[x, y, z, w]`, where `x, y, z` are the imaginary vector part and `w` is the real scalar part.  
    Mathmatical notation often represents quaternions as `[w, x, y, z]`, so be cautious when interfacing with other libraries or mathematical texts.

    For performance reasons, operators (`==` and `*`) cannot not supported. Use the provided methods for quaternion operations.
]=]

local quaternion = {}

--- @type Quaternion buffer
--- @within quaternion
--- A branded buffer type representing a quaternion, 16 bytes.
type Brand<T, Tag> = T & { __brand: Tag }
export type Quaternion = Brand<buffer, "quaternion">

type Vector = vector | Vector3

--------------------
--== PROPERTIES ==--
--------------------

--[=[
    @function w
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return number -- The w component (real part).
    Gets the w component of the quaternion.
]=]
function quaternion.w(q: Quaternion): number
	return buffer.readf32(q, 12)
end

--[=[
    @function x
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return number -- The x component (i).
    Gets the x component of the quaternion.
]=]
function quaternion.x(q: Quaternion): number
	return buffer.readf32(q, 0)
end
--[=[
    @function y
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return number -- The y component (j).
    Gets the y component of the quaternion.
]=]
function quaternion.y(q: Quaternion): number
	return buffer.readf32(q, 4)
end
--[=[
    @function z
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return number -- The z component (k).
    Gets the z component of the quaternion.
]=]
function quaternion.z(q: Quaternion): number
	return buffer.readf32(q, 8)
end

--[=[
    @function eulerAngles
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return number, number, number -- The Euler angles (pitch, yaw, roll) in radians.
    Converts the quaternion to Euler angles (XYZ order) in radians.
]=]
function quaternion.eulerAngles(q: Quaternion): (number, number, number)
	local x = buffer.readf32(q, 0)
	local y = buffer.readf32(q, 4)
	local z = buffer.readf32(q, 8)
	local w = buffer.readf32(q, 12)

	-- Roll (x-axis rotation)
	local sinr_cosp = 2 * (w * x + y * z)
	local cosr_cosp = 1 - 2 * (x * x + y * y)
	local roll = math.atan2(sinr_cosp, cosr_cosp)

	-- Pitch (y-axis rotation)
	local sinp = 2 * (w * y - z * x)
	local pitch
	if math.abs(sinp) >= 1 then
		pitch = math.pi / 2 * math.sign(sinp) -- use 90 degrees if out of range
	else
		pitch = math.asin(sinp)
	end

	-- Yaw (z-axis rotation)
	local siny_cosp = 2 * (w * z + x * y)
	local cosy_cosp = 1 - 2 * (y * y + z * z)
	local yaw = math.atan2(siny_cosp, cosy_cosp)

	return pitch, yaw, roll
end

--[=[
    @function rotation
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return CFrame -- The CFrame representing the rotation of the quaternion.
    Converts the quaternion to a CFrame representing its rotation.
]=]
function quaternion.rotation(q: Quaternion): CFrame
	local x = buffer.readf32(q, 0)
	local y = buffer.readf32(q, 4)
	local z = buffer.readf32(q, 8)
	local w = buffer.readf32(q, 12)

	return CFrame.new(0, 0, 0, x, y, z, w)
end

--[=[
    @function this
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return {number} -- A table containing the components {x, y, z, w}.
    Gets all components of the quaternion as a table.  
    Mutating this table will not affect the original quaternion.
]=]
function quaternion.this(q: Quaternion): { number }
	return {
		buffer.readf32(q, 0),
		buffer.readf32(q, 4),
		buffer.readf32(q, 8),
		buffer.readf32(q, 12),
	}
end

local function xvectorq(q: Quaternion): Vector3 & vector
	local x = buffer.readf32(q, 0)
	local y = buffer.readf32(q, 4)
	local z = buffer.readf32(q, 8)
	local w = buffer.readf32(q, 12)

	return vector.create(1 - 2 * (y * y + z * z), 2 * (x * y + w * z), 2 * (x * z - w * y)) :: any
end

local function yvectorq(q: Quaternion): Vector3 & vector
	local x = buffer.readf32(q, 0)
	local y = buffer.readf32(q, 4)
	local z = buffer.readf32(q, 8)
	local w = buffer.readf32(q, 12)

	return vector.create(2 * (x * y - w * z), 1 - 2 * (x * x + z * z), 2 * (y * z + w * x)) :: any
end

local function zvectorq(q: Quaternion): Vector3 & vector
	local x = buffer.readf32(q, 0)
	local y = buffer.readf32(q, 4)
	local z = buffer.readf32(q, 8)
	local w = buffer.readf32(q, 12)

	return vector.create(2 * (x * z + w * y), 2 * (y * z - w * x), 1 - 2 * (x * x + y * y)) :: any
end

--[=[
    @function xVector
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3 -- The right direction vector of the quaternion.
    Gets the right direction vector of the quaternion.
]=]
quaternion.xVector = xvectorq
--[=[
    @function yVector
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3 -- The up direction vector of the quaternion.
    Gets the up direction vector of the quaternion.
]=]
quaternion.yVector = yvectorq
--[=[
    @function zVector
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3 -- The forward direction vector of the quaternion.
    Gets the forward direction vector of the quaternion (opposite of lookVector).
]=]
quaternion.zVector = zvectorq

--[=[
    @function rightVector
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3 -- The right direction vector of the quaternion.
    Gets the right direction vector of the quaternion.
]=]
quaternion.rightVector = xvectorq
--[=[
    @function upVector
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3 -- The up direction vector of the quaternion.
    Gets the up direction vector of the quaternion.
]=]
quaternion.upVector = yvectorq
--[=[
    @function lookVector
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3 -- The look direction vector of the quaternion.
    Gets the look direction vector of the quaternion (opposite of zVector).
]=]
quaternion.lookVector = function(q: Quaternion): Vector3 & vector
	local zv: vector = zvectorq(q)
	return -zv :: any
end

----------------
--== METODS ==--
----------------

--[=[
    @function dot
    @within quaternion
    @param q1 Quaternion -- The first quaternion.
    @param q2 Quaternion -- The second quaternion.
    @return number -- The dot product of the two quaternions.
    Calculates the dot product of two quaternions.
]=]
local function dotq(q1: Quaternion, q2: Quaternion): number
	return buffer.readf32(q1, 0) * buffer.readf32(q2, 0)
		+ buffer.readf32(q1, 4) * buffer.readf32(q2, 4)
		+ buffer.readf32(q1, 8) * buffer.readf32(q2, 8)
		+ buffer.readf32(q1, 12) * buffer.readf32(q2, 12)
end
quaternion.dot = dotq

--[=[
    @function angle
    @within quaternion
    @param q1 Quaternion -- The first quaternion.
    @param q2 Quaternion -- The second quaternion.
    @return number -- The angle in radians between the two quaternions.
    Calculates the angle in radians between two quaternions.
]=]
local function angleq(q1: Quaternion, q2: Quaternion): number
	local dot = dotq(q1, q2)
	return math.acos(math.clamp(dot, -1, 1)) * 2
end
quaternion.angle = angleq

--[=[
    @function equals
    @within quaternion
    @param q1 Quaternion -- The first quaternion.
    @param q2 Quaternion -- The second quaternion.
    @return boolean -- Whether the two quaternions are equal.
    Compares two quaternions for equality.
]=]
function quaternion.equals(q1: Quaternion, q2: Quaternion): boolean
	-- PROFILED: 8 `readf32` calls and 4 float comparisons beats 2 `tostring` or `readstring` calls and 1 string comparison
	return buffer.readf32(q1, 0) == buffer.readf32(q2, 0)
		and buffer.readf32(q1, 4) == buffer.readf32(q2, 4)
		and buffer.readf32(q1, 8) == buffer.readf32(q2, 8)
		and buffer.readf32(q1, 12) == buffer.readf32(q2, 12)
end

--[=[
    @function set
    @within quaternion
    @param q Quaternion -- The quaternion.
    @param x number -- The x component (i).
    @param y number -- The y component (j).
    @param z number -- The z component (k).
    @param w number -- The w component (real part).
    @tag Mutating 
    Sets the components of the quaternion.
]=]
local function set(q: Quaternion, x: number, y: number, z: number, w: number): ()
	buffer.writef32(q, 0, x)
	buffer.writef32(q, 4, y)
	buffer.writef32(q, 8, z)
	buffer.writef32(q, 12, w)
end
quaternion.set = set

--[=[
    @function inverse
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Quaternion -- The inverse of the quaternion.
    @tag Pure
    Returns the inverse of the quaternion.
]=]
local function inverseq(q: Quaternion): Quaternion
	local x = buffer.readf32(q, 0)
	local y = buffer.readf32(q, 4)
	local z = buffer.readf32(q, 8)
	local w = buffer.readf32(q, 12)

	local magSq = x * x + y * y + z * z + w * w
	if magSq > 0 then
		local invMagSq = 1 / magSq
		return quaternion.new(-x * invMagSq, -y * invMagSq, -z * invMagSq, w * invMagSq)
	else
		-- Return identity quaternion if magnitude is zero to avoid division by zero
		return quaternion.identity()
	end
end
quaternion.inverse = inverseq

--[=[
    @function inverseInPlace
    @within quaternion
    @param q Quaternion -- The quaternion to invert.
    @tag Mutating
    Inverts the quaternion in place.
]=]
function quaternion.inverseInPlace(q: Quaternion): ()
	local x = buffer.readf32(q, 0)
	local y = buffer.readf32(q, 4)
	local z = buffer.readf32(q, 8)
	local w = buffer.readf32(q, 12)

	local magSq = x * x + y * y + z * z + w * w
	if magSq > 0 then
		local invMagSq = 1 / magSq
		set(q, -x * invMagSq, -y * invMagSq, -z * invMagSq, w * invMagSq)
	else
		-- Set to identity quaternion if magnitude is zero to avoid division by zero
		set(q, 0, 0, 0, 1)
	end
end

--[=[
    @function multiply
    @within quaternion
    @param lhs Quaternion -- The left-hand side quaternion.
    @param rhs Quaternion -- The right-hand side quaternion.
    @return Quaternion -- The resulting quaternion from the multiplication.
    @tag Pure
    Multiplies two quaternions.

    :::note
    Quaternion multiplication is not commutative; the order of multiplication matters.  
    Think of it as rotating the lhs quaternion by the rhs quaternion.
    :::
]=]
function quaternion.multiply(lhs: Quaternion, rhs: Quaternion): Quaternion
	local x1, y1, z1, w1 = buffer.readf32(lhs, 0), buffer.readf32(lhs, 4), buffer.readf32(lhs, 8), buffer.readf32(lhs, 12)
	local x2, y2, z2, w2 = buffer.readf32(rhs, 0), buffer.readf32(rhs, 4), buffer.readf32(rhs, 8), buffer.readf32(rhs, 12)

	-- Hamilton product formula
	local x = w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2
	local y = w1 * y2 - x1 * z2 + y1 * w2 + z1 * x2
	local z = w1 * z2 + x1 * y2 - y1 * x2 + z1 * w2
	local w = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2

	return quaternion.new(x, y, z, w)
end

--[=[
    @function multiplyInPlace
    @within quaternion
    @param lhs Quaternion -- The left-hand side quaternion, and the quaternion that will be mutated.
    @param rhs Quaternion -- The right-hand side quaternion.
    @tag Mutating
    Multiplies the lhs quaternion by the rhs quaternion, mutating the lhs.

    :::note
    Quaternion multiplication is not commutative; the order of multiplication matters.  
    Think of it as rotating the lhs quaternion by the rhs quaternion.
    :::
]=]
function quaternion.multiplyInPlace(lhs: Quaternion, rhs: Quaternion): ()
	local x1, y1, z1, w1 = buffer.readf32(lhs, 0), buffer.readf32(lhs, 4), buffer.readf32(lhs, 8), buffer.readf32(lhs, 12)
	local x2, y2, z2, w2 = buffer.readf32(rhs, 0), buffer.readf32(rhs, 4), buffer.readf32(rhs, 8), buffer.readf32(rhs, 12)

	-- Hamilton product formula
	local x = w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2
	local y = w1 * y2 - x1 * z2 + y1 * w2 + z1 * x2
	local z = w1 * z2 + x1 * y2 - y1 * x2 + z1 * w2
	local w = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2

	set(lhs, x, y, z, w)
end

--[=[
    @function normalize
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Quaternion -- The normalized quaternion.
    @tag Pure
    Returns a normalized version of the quaternion.
]=]
function quaternion.normalize(q: Quaternion): Quaternion
	local x = buffer.readf32(q, 0)
	local y = buffer.readf32(q, 4)
	local z = buffer.readf32(q, 8)
	local w = buffer.readf32(q, 12)

	-- Don't use dotq here because it would read twice
	local mag = math.sqrt(x * x + y * y + z * z + w * w)
	if mag > 0 then
		local invMag = 1 / mag
		return quaternion.new(x * invMag, y * invMag, z * invMag, w * invMag)
	else
		return quaternion.identity()
	end
end

--[=[
    @function normalizeInPlace
    @within quaternion
    @param q Quaternion -- The quaternion to normalize.
    @tag Mutating
    Normalizes the quaternion in place.
]=]
function quaternion.normalizeInPlace(q: Quaternion): ()
	local x = buffer.readf32(q, 0)
	local y = buffer.readf32(q, 4)
	local z = buffer.readf32(q, 8)
	local w = buffer.readf32(q, 12)

	-- Don't use dotq here because it would read twice
	local mag = math.sqrt(x * x + y * y + z * z + w * w)
	if mag > 0 then
		local invMag = 1 / mag
		set(q, x * invMag, y * invMag, z * invMag, w * invMag)
	else
		set(q, 0, 0, 0, 1)
	end
end

--[=[
    @function lerp
    @within quaternion
    @param from Quaternion -- The starting quaternion.
    @param to Quaternion -- The target quaternion.
    @param t number -- The interpolation factor (0 to 1).
    @return Quaternion -- The interpolated quaternion.
    @tag Pure
    Linearly interpolates between two quaternions and normalizes the result.
]=]
local function lerpq(from: Quaternion, to: Quaternion, t: number): Quaternion
	local x = (1 - t) * buffer.readf32(from, 0) + t * buffer.readf32(to, 0)
	local y = (1 - t) * buffer.readf32(from, 4) + t * buffer.readf32(to, 4)
	local z = (1 - t) * buffer.readf32(from, 8) + t * buffer.readf32(to, 8)
	local w = (1 - t) * buffer.readf32(from, 12) + t * buffer.readf32(to, 12)
	local result = quaternion.new(x, y, z, w)
	quaternion.normalizeInPlace(result)
	return result
end
quaternion.lerp = lerpq

--[=[
    @function slerp
    @within quaternion
    @param from Quaternion -- The starting quaternion.
    @param to Quaternion -- The target quaternion.
    @param t number -- The interpolation factor (0 to 1).
    @return Quaternion -- The spherically interpolated quaternion.
    @tag Pure
    Spherically interpolates between two quaternions.
]=]
local function slerpq(from: Quaternion, to: Quaternion, t: number): Quaternion
	local dot = dotq(from, to)
	local theta = math.acos(math.clamp(dot, -1, 1))
	local sinTheta = math.sin(theta)

	if sinTheta < 1e-6 then
		-- If the angle is very small, use linear interpolation
		return lerpq(from, to, t)
	else
		local ratioA = math.sin((1 - t) * theta) / sinTheta
		local ratioB = math.sin(t * theta) / sinTheta

		local x = ratioA * buffer.readf32(from, 0) + ratioB * buffer.readf32(to, 0)
		local y = ratioA * buffer.readf32(from, 4) + ratioB * buffer.readf32(to, 4)
		local z = ratioA * buffer.readf32(from, 8) + ratioB * buffer.readf32(to, 8)
		local w = ratioA * buffer.readf32(from, 12) + ratioB * buffer.readf32(to, 12)

		return quaternion.new(x, y, z, w)
	end
end
quaternion.slerp = slerpq

--[=[
    @function rotateTowards
    @within quaternion
    @param from Quaternion -- The starting quaternion.
    @param to Quaternion -- The target quaternion.
    @param maxRadiansDelta number -- The maximum angle in radians to rotate.
    @return Quaternion -- The resulting quaternion after rotation.
    @tag Pure
    Rotates one quaternion towards another by a maximum angle in radians.
]=]
function quaternion.rotateTowards(from: Quaternion, to: Quaternion, maxRadiansDelta: number): Quaternion
	-- Flip the target if maxRadiansDelta is negative
	if maxRadiansDelta < 0 then
		to = inverseq(to)
		maxRadiansDelta = -maxRadiansDelta
	end

	local angle = angleq(from, to)
	if angle == 0 then return from end

	local t = math.min(1, maxRadiansDelta / angle)

	return slerpq(from, to, t)
end

--[=[
    @function setFromToRotation
    @within quaternion
    @param q Quaternion -- The quaternion to set.
    @param from Vector3 -- The starting direction vector.
    @param to Vector3 -- The target direction vector.
    @tag Mutating
    Sets an existing quaternion so that it represents the rotation from one direction vector to another.
]=]
local function setFromToRotation(q: Quaternion, from: vector, to: vector)
	local fromNorm = vector.normalize(from)
	local toNorm = vector.normalize(to)

	local dot = vector.dot(fromNorm, toNorm)
	if dot >= 1.0 or dot ~= dot then
		-- If vectors are identical or NaN, return identity quaternion
		set(q, 0, 0, 0, 1)
	elseif dot <= -1.0 then
		-- If vectors are opposite, find an orthogonal axis for rotation and rotate 180 degrees
		local axis = vector.cross(fromNorm, X_AXIS)
		if vector.dot(axis, axis) < 1e-12 then axis = vector.cross(fromNorm, Y_AXIS) end
		set(q, axis.x * math.sin(math.pi / 2), axis.y * math.sin(math.pi / 2), axis.z * math.sin(math.pi / 2), math.cos(math.pi / 2))
	else
		-- General case
		local s = math.sqrt((1 + dot) * 2)
		local invs = 1 / s
		local c = vector.cross(fromNorm, toNorm)
		set(q, c.x * invs, c.y * invs, c.z * invs, s * 0.5)
	end
end
quaternion.setFromToRotation = setFromToRotation :: (q: Quaternion, from: Vector, to: Vector) -> ()

--[=[
    @function setEulerAngles
    @within quaternion
    @param q Quaternion -- The quaternion to set.
    @param x number -- The rotation around the x-axis in radians (pitch).
    @param y number -- The rotation around the y-axis in radians (yaw).
    @param z number -- The rotation around the z-axis in radians (roll).
    @tag Mutating
    Sets an existing quaternion from Euler angles XYZ in radians.
]=]
local function setEulerAngles(q: Quaternion, pitch: number, yaw: number, roll: number)
	local cy = math.cos(yaw * 0.5)
	local sy = math.sin(yaw * 0.5)
	local cp = math.cos(pitch * 0.5)
	local sp = math.sin(pitch * 0.5)
	local cr = math.cos(roll * 0.5)
	local sr = math.sin(roll * 0.5)

	local w = cr * cp * cy + sr * sp * sy
	local x = sr * cp * cy - cr * sp * sy
	local y = cr * sp * cy + sr * cp * sy
	local z = cr * cp * sy - sr * sp * cy

	set(q, x, y, z, w)
end
quaternion.setEulerAngles = setEulerAngles :: (q: Quaternion, x: number, y: number, z: number) -> ()

--[=[
    @function setLookRotation
    @within quaternion
    @param q Quaternion -- The quaternion to set.
    @param forward Vector3 -- The forward direction vector.
    @param up Vector3 -- The up direction vector.
    @tag Mutating
    Sets an existing quaternion so that it represents a rotation looking in a specified forward direction with a given up direction.
]=]
local function setLookRotation(q: Quaternion, forward: vector, up: vector)
	local f = vector.normalize(forward)
	local r = vector.normalize(vector.cross(up, f))
	local u = vector.cross(f, r)

	local trace = r.x + u.y + f.z
	if trace > 0 then
		local s = math.sqrt(trace + 1) * 2
		local sinv = 1 / s
		set(q, (u.z - f.y) * sinv, (f.x - r.z) * sinv, (r.y - u.x) * sinv, s * 0.25)
	else
		if r.x > u.y and r.x > f.z then
			local s = math.sqrt(1 + r.x - u.y - f.z) * 2
			local sinv = 1 / s
			set(q, s * 0.25, (u.x + r.y) * sinv, (f.x + r.z) * sinv, (u.z - f.y) * sinv)
		elseif u.y > f.z then
			local s = math.sqrt(1 + u.y - r.x - f.z) * 2
			local sinv = 1 / s
			set(q, (f.x + r.z) * sinv, s * 0.25, (u.y + r.x) * sinv, (f.y - r.z) * sinv)
		else
			local s = math.sqrt(1 + f.z - r.x - u.y) * 2
			local sinv = 1 / s
			set(q, (u.z - f.y) * sinv, (f.y + r.z) * sinv, s * 0.25, (r.x - u.y) * sinv)
		end
	end
end
quaternion.setLookRotation = setLookRotation :: (q: Quaternion, forward: Vector, up: Vector) -> ()

--[=[
    @function toAxisAngle
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3, number -- The axis of rotation as a Vector3 and the angle in radians.
    Converts the quaternion to an axis-angle representation.
]=]
function quaternion.toAxisAngle(q: Quaternion): (Vector3 & vector, number)
	local w = buffer.readf32(q, 12)
	local x = buffer.readf32(q, 0)
	local y = buffer.readf32(q, 4)
	local z = buffer.readf32(q, 8)

	local angle = math.acos(w) * 2
	local s = math.sqrt(1 - w * w)

	if s < 1e-6 then
		return vector.create(1, 0, 0) :: any, angle
	else
		local sinv = 1 / s
		return vector.create(x * sinv, y * sinv, z * sinv) :: any, angle
	end
end

--[=[
    @function toCFrame
    @within quaternion
    @param x number -- The x position.
    @param y number -- The y position.
    @param z number -- The z position.
    @param q Quaternion -- The quaternion.
    @return CFrame -- The resulting CFrame.
    Converts the quaternion and position to a CFrame.  
    You can use `quaternion.rotation` if position is not needed.
]=]
function quaternion.toCFrame(x: number, y: number, z: number, q: Quaternion): CFrame
	local qx = buffer.readf32(q, 0)
	local qy = buffer.readf32(q, 4)
	local qz = buffer.readf32(q, 8)
	local qw = buffer.readf32(q, 12)

	return CFrame.new(x, y, z, qx, qy, qz, qw)
end

--[=[
    @function toCFrameFromPosition
    @within quaternion
    @param position Vector3 -- The position vector.
    @param q Quaternion -- The quaternion.
    @return CFrame -- The resulting CFrame.
    Converts the quaternion and position vector to a CFrame.  
    You can use `quaternion.rotation` if position is not needed.
]=]
function quaternion.toCFrameFromPosition(position: Vector, q: Quaternion): CFrame
	local x, y, z = (position :: any).x, (position :: any).y, (position :: any).z

	local qx = buffer.readf32(q, 0)
	local qy = buffer.readf32(q, 4)
	local qz = buffer.readf32(q, 8)
	local qw = buffer.readf32(q, 12)

	return CFrame.new(x, y, z, qx, qy, qz, qw)
end

--[=[
    @function tostring
    @within quaternion
    @param q Quaternion -- The quaternion.
    @param format string? -- Optional format string for each component.
    @return string -- The string representation of the quaternion.
    Converts the quaternion to a string representation.  
    Quaternion does not have a metatable to support the `__tostring` metamethod, so this function must be used explicitly.
]=]
function quaternion.tostring(q: Quaternion, format: string?): string
	return string.format(format or "Quaternion(%.6f, %.6f, %.6f, %.6f)", buffer.readf32(q, 0), buffer.readf32(q, 4), buffer.readf32(q, 8), buffer.readf32(q, 12))
end

----------------------
--== CONSTRUCTORS ==--
----------------------

--[=[
    @function fromCFrame
    @within quaternion
    @param cf CFrame -- The CFrame to convert.
    @return Quaternion -- The resulting quaternion.
    Creates a quaternion from a CFrame's rotation.
]=]
function quaternion.fromCFrame(cf: CFrame): Quaternion
	local q: Quaternion = buffer.create(16) :: any
	local _, _, _, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:GetComponents()

	local trace = m00 + m11 + m22
	if trace > 0 then
		local s = math.sqrt(trace + 1) * 2
		local sinv = 1 / s
		set(q, (m21 - m12) * sinv, (m02 - m20) * sinv, (m10 - m01) * sinv, s * 0.25)
	else
		if m00 > m11 and m00 > m22 then
			local s = math.sqrt(1 + m00 - m11 - m22) * 2
			local sinv = 1 / s
			set(q, s * 0.25, (m01 + m10) * sinv, (m02 + m20) * sinv, (m21 - m12) * sinv)
		elseif m11 > m22 then
			local s = math.sqrt(1 + m11 - m00 - m22) * 2
			local sinv = 1 / s
			set(q, (m01 + m10) * sinv, s * 0.25, (m12 + m21) * sinv, (m02 - m20) * sinv)
		else
			local s = math.sqrt(1 + m22 - m00 - m11) * 2
			local sinv = 1 / s
			set(q, (m02 + m20) * sinv, (m12 + m21) * sinv, s * 0.25, (m10 - m01) * sinv)
		end
	end

	return q
end

--[=[
    @function fromToRotation
    @within quaternion
    @param from Vector3 -- The starting direction vector.
    @param to Vector3 -- The target direction vector.
    @return Quaternion -- The resulting quaternion representing the rotation from `from` to `to`.
    Creates a quaternion that represents the rotation from one direction vector to another.
]=]
function quaternion.fromToRotation(from: Vector, to: Vector): Quaternion
	local q: Quaternion = buffer.create(16) :: any
	setFromToRotation(q, from :: any, to :: any)
	return q
end

--[=[
    @function lookRotation
    @within quaternion
    @param forward Vector3 -- The forward direction vector.
    @param up Vector3 -- The up direction vector.
    @return Quaternion -- The resulting quaternion representing the rotation.
    Creates a quaternion that represents a rotation looking in a specified forward direction with a given up direction.
]=]
function quaternion.lookRotation(forward: Vector, up: Vector): Quaternion
	local q: Quaternion = buffer.create(16) :: any
	setLookRotation(q, forward :: any, up :: any)
	return q
end

--[=[
    @function identity
    @within quaternion
    @return Quaternion -- The identity quaternion (0, 0, 0, 1).
    Creates and returns the identity quaternion.
]=]
function quaternion.identity(): Quaternion
	return quaternion.new(0, 0, 0, 1)
end

--[=[
    @function new
    @within quaternion
    @param x number -- The x component (i).
    @param y number -- The y component (j).
    @param z number -- The z component (k).
    @param w number -- The w component (real part).
    @return Quaternion -- The quaternion data structure.
    Creates a new Quaternion.
]=]
function quaternion.new(x: number, y: number, z: number, w: number): Quaternion
	local q: Quaternion = buffer.create(16) :: any -- Cast to any to satisfy the Brand type
	set(q, x, y, z, w)
	return q
end

return quaternion
