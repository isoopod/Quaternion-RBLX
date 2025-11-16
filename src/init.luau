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

--[=[
    @function identity
    @within quaternion
    @return Quaternion -- The identity quaternion (0, 0, 0, 1).
	@tag Constructor
    Creates and returns the identity quaternion.
]=]
local function identity(): Quaternion
	local q = buffer.create(16) :: Quaternion
	buffer.writef32(q, 12, 1)
	return q
end
quaternion.identity = identity

--[=[
    @function set
    @within quaternion
    @param q Quaternion -- The quaternion.
    @param x number -- The x component (i).
    @param y number -- The y component (j).
    @param z number -- The z component (k).
    @param w number -- The w component (real part).
    @tag Method
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
    @function new
    @within quaternion
    @param x number -- The x component (i).
    @param y number -- The y component (j).
    @param z number -- The z component (k).
    @param w number -- The w component (real part).
    @return Quaternion -- The quaternion data structure.
	@tag Constructor
    Creates a new Quaternion.
]=]
local function new(x: number, y: number, z: number, w: number): Quaternion
	local q = buffer.create(16) :: Quaternion
	set(q, x, y, z, w)
	return q
end
quaternion.new = new

--------------------
--== PROPERTIES ==--
--------------------

--[=[
    @function w
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return number -- The w component (real part).
	@tag Property
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
	@tag Property
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
	@tag Property
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
	@tag Property
    Gets the z component of the quaternion.
]=]
function quaternion.z(q: Quaternion): number
	return buffer.readf32(q, 8)
end

--[=[
	@function getComponents
	@within quaternion
	@param q Quaternion -- The quaternion.
	@return number, number, number, number -- The components (x, y, z, w).
	@tag Decomposition
	Gets all components of the quaternion.
]=]
local function getComponents(q: Quaternion): (number, number, number, number)
	return buffer.readf32(q, 0), buffer.readf32(q, 4), buffer.readf32(q, 8), buffer.readf32(q, 12)
end
quaternion.getComponents = getComponents

--[=[
    @function toEulerAngles
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return number, number, number -- The Euler angles (pitch, yaw, roll) in radians.
	@tag Decomposition
    Converts the quaternion to Euler angles (XYZ order) in radians.
]=]
function quaternion.toEulerAngles(q: Quaternion): (number, number, number)
	local x, y, z, w = getComponents(q)

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
	@tag Property
    Converts the quaternion to a CFrame representing its rotation.
]=]
function quaternion.rotation(q: Quaternion): CFrame
	local x, y, z, w = getComponents(q)

	return CFrame.new(0, 0, 0, x, y, z, w)
end

--[=[
    @function this
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return {number} -- A table containing the components {x, y, z, w}.
	@tag Property
    Gets all components of the quaternion as a table.  
    Mutating this table will not affect the original quaternion.
]=]
function quaternion.this(q: Quaternion): { number }
	return { getComponents(q) }
end

--[=[
	@function magnitudeSquared
	@within quaternion
	@param q Quaternion -- The quaternion.
	@return number -- The squared magnitude of the quaternion.
	@tag Property
	Gets the squared magnitude of the quaternion.
]=]
local function magnitudeSquared(q: Quaternion): number
	local x, y, z, w = getComponents(q)
	return x * x + y * y + z * z + w * w
end
quaternion.magnitudeSquared = magnitudeSquared

--[=[
	@function magnitude
	@within quaternion
	@param q Quaternion -- The quaternion.
	@return number -- The magnitude of the quaternion.
	@tag Property
	Gets the magnitude (length) of the quaternion.
]=]
local function magnitude(q: Quaternion): number
	return math.sqrt(magnitudeSquared(q))
end
quaternion.magnitude = magnitude

local function xvectorq(q: Quaternion): Vector3 & vector
	local x, y, z, w = getComponents(q)

	return vector.create(1 - 2 * (y * y + z * z), 2 * (x * y + w * z), 2 * (x * z - w * y)) :: any
end

local function yvectorq(q: Quaternion): Vector3 & vector
	local x, y, z, w = getComponents(q)

	return vector.create(2 * (x * y - w * z), 1 - 2 * (x * x + z * z), 2 * (y * z + w * x)) :: any
end

local function zvectorq(q: Quaternion): Vector3 & vector
	local x, y, z, w = getComponents(q)

	return vector.create(2 * (x * z + w * y), 2 * (y * z - w * x), 1 - 2 * (x * x + y * y)) :: any
end

--[=[
    @function xVector
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3 -- The right direction vector of the quaternion.
	@tag Property
    Gets the right direction vector of the quaternion.
]=]
quaternion.xVector = xvectorq
--[=[
    @function yVector
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3 -- The up direction vector of the quaternion.
	@tag Property
    Gets the up direction vector of the quaternion.
]=]
quaternion.yVector = yvectorq
--[=[
    @function zVector
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3 -- The forward direction vector of the quaternion.
	@tag Property
    Gets the forward direction vector of the quaternion (opposite of lookVector).
]=]
quaternion.zVector = zvectorq

--[=[
    @function rightVector
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3 -- The right direction vector of the quaternion.
	@tag Property
    Gets the right direction vector of the quaternion.
]=]
quaternion.rightVector = xvectorq
--[=[
    @function upVector
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3 -- The up direction vector of the quaternion.
	@tag Property
    Gets the up direction vector of the quaternion.
]=]
quaternion.upVector = yvectorq
--[=[
    @function lookVector
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3 -- The look direction vector of the quaternion.
	@tag Property
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
	@tag Method
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
	@tag Method
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
	@tag Method
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
    @function inverse
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Quaternion -- The inverse of the quaternion.
	@tag Method
    @tag Pure
    Returns the inverse of the quaternion.
]=]
local function inverse(q: Quaternion): Quaternion
	local x, y, z, w = getComponents(q)

	-- Use inline magnitudeSq calculation to avoid extra reads
	local magSq = x * x + y * y + z * z + w * w
	if magSq > 0 then
		local invMagSq = 1 / magSq
		return new(-x * invMagSq, -y * invMagSq, -z * invMagSq, w * invMagSq)
	else
		-- Return identity quaternion if magnitude is zero to avoid division by zero
		return identity()
	end
end
quaternion.inverse = inverse

--[=[
	@function inverseUnit
	@within quaternion
	@param q Quaternion -- The unit quaternion.
	@return Quaternion -- The inverse of the unit quaternion.
	@tag Method
	@tag Pure
	Returns the inverse of a unit quaternion.  
	This is more efficient than `quaternion.inverse` since it assumes the quaternion is normalized.
	For a unit quaternion, the inverse is simply the conjugate.
	For non-unit quaternions, this will return the conjugate, not the inverse.
]=]
local function inverseUnit(q: Quaternion): Quaternion
	local x, y, z, w = getComponents(q)
	return new(-x, -y, -z, w)
end
quaternion.inverseUnit = inverseUnit

--[=[
    @function inverseInPlace
    @within quaternion
    @param q Quaternion -- The quaternion to invert.
	@tag Method
    @tag Mutating
    Inverts the quaternion in place.
]=]
local function inverseInPlace(q: Quaternion): ()
	local x, y, z, w = getComponents(q)

	local magSq = x * x + y * y + z * z + w * w
	if magSq > 0 then
		local invMagSq = 1 / magSq
		set(q, -x * invMagSq, -y * invMagSq, -z * invMagSq, w * invMagSq)
	else
		-- Set to identity quaternion if magnitude is zero to avoid division by zero
		set(q, 0, 0, 0, 1)
	end
end
quaternion.inverseInPlace = inverseInPlace

--[=[
	@function inverseUnitInPlace
	@within quaternion
	@param q Quaternion -- The unit quaternion to invert.
	@tag Method
	@tag Mutating
	Inverts a unit quaternion in place.  
	This is more efficient than `quaternion.inverseInPlace` since it assumes the quaternion is normalized.
	For a unit quaternion, the inverse is simply the conjugate.
	For non-unit quaternions, this will return the conjugate, not the inverse.
]=]
local function inverseUnitInPlace(q: Quaternion): ()
	local x, y, z, w = getComponents(q)
	set(q, -x, -y, -z, w)
end
quaternion.inverseUnitInPlace = inverseUnitInPlace

--[=[
    @function multiply
    @within quaternion
    @param lhs Quaternion -- The left-hand side quaternion.
    @param rhs Quaternion -- The right-hand side quaternion.
    @return Quaternion -- The resulting quaternion from the multiplication.
	@tag Method
    @tag Pure
    Multiplies two quaternions.

    :::note
    Quaternion multiplication is not commutative; the order of multiplication matters.  
    Think of it as rotating the lhs quaternion by the rhs quaternion.
    :::
]=]
function quaternion.multiply(lhs: Quaternion, rhs: Quaternion): Quaternion
	local x1, y1, z1, w1 = getComponents(lhs)
	local x2, y2, z2, w2 = getComponents(rhs)

	-- Hamilton product formula
	local x = w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2
	local y = w1 * y2 - x1 * z2 + y1 * w2 + z1 * x2
	local z = w1 * z2 + x1 * y2 - y1 * x2 + z1 * w2
	local w = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2

	return new(x, y, z, w)
end

--[=[
    @function multiplyInPlace
    @within quaternion
    @param lhs Quaternion -- The left-hand side quaternion, and the quaternion that will be mutated.
    @param rhs Quaternion -- The right-hand side quaternion.
	@tag Method
    @tag Mutating
    Multiplies the lhs quaternion by the rhs quaternion, mutating the lhs.

    :::note
    Quaternion multiplication is not commutative; the order of multiplication matters.  
    Think of it as rotating the lhs quaternion by the rhs quaternion.
    :::
]=]
function quaternion.multiplyInPlace(lhs: Quaternion, rhs: Quaternion): ()
	local x1, y1, z1, w1 = getComponents(lhs)
	local x2, y2, z2, w2 = getComponents(rhs)

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
	@tag Method
    @tag Pure
    Returns a normalized version of the quaternion.
]=]
function quaternion.normalize(q: Quaternion): Quaternion
	local x, y, z, w = getComponents(q)

	-- Use inline magnitude calculation to avoid extra reads
	local mag = math.sqrt(x * x + y * y + z * z + w * w)
	if mag > 0 then
		local invMag = 1 / mag
		return new(x * invMag, y * invMag, z * invMag, w * invMag)
	else
		return identity()
	end
end

--[=[
    @function normalizeInPlace
    @within quaternion
    @param q Quaternion -- The quaternion to normalize.
	@tag Method
    @tag Mutating
    Normalizes the quaternion in place.
]=]
function quaternion.normalizeInPlace(q: Quaternion): ()
	local x, y, z, w = getComponents(q)

	-- Use inline magnitude calculation to avoid extra reads
	local mag = math.sqrt(x * x + y * y + z * z + w * w)
	if mag > 0 then
		local invMag = 1 / mag
		set(q, x * invMag, y * invMag, z * invMag, w * invMag)
	else
		set(q, 0, 0, 0, 1)
	end
end

--[=[
    @function nlerpInPlace
    @within quaternion
    @param out Quaternion -- The quaternion to store the result.
    @param from Quaternion -- The starting quaternion.
    @param to Quaternion -- The target quaternion.
    @param t number -- The interpolation factor (0 to 1).
    @tag Method
    @tag Mutating
    Linearly interpolates between two quaternions and normalizes the result, storing it in `out`.
]=]
local function nlerpInPlace(out: Quaternion, from: Quaternion, to: Quaternion, t: number)
	local x = (1 - t) * buffer.readf32(from, 0) + t * buffer.readf32(to, 0)
	local y = (1 - t) * buffer.readf32(from, 4) + t * buffer.readf32(to, 4)
	local z = (1 - t) * buffer.readf32(from, 8) + t * buffer.readf32(to, 8)
	local w = (1 - t) * buffer.readf32(from, 12) + t * buffer.readf32(to, 12)
	set(out, x, y, z, w)
	quaternion.normalizeInPlace(out)
end
quaternion.nlerpInPlace = nlerpInPlace

--[=[
    @function nlerp
    @within quaternion
    @param from Quaternion -- The starting quaternion.
    @param to Quaternion -- The target quaternion.
    @param t number -- The interpolation factor (0 to 1).
    @return Quaternion -- The interpolated quaternion.
    @tag Method
	@tag Pure
    Linearly interpolates between two quaternions and normalizes the result.
]=]
local function nlerp(from: Quaternion, to: Quaternion, t: number): Quaternion
	local q = buffer.create(16) :: Quaternion
	nlerpInPlace(q, from, to, t)
	return q
end
quaternion.nlerp = nlerp

--[=[
    @function slerpInPlace
    @within quaternion
    @param out Quaternion -- The quaternion to store the result.
    @param from Quaternion -- The starting quaternion.
    @param to Quaternion -- The target quaternion.
    @param t number -- The interpolation factor (0 to 1).
    @tag Method
    @tag Mutating
    Spherically interpolates between two quaternions and stores the result in `out`.
]=]
local function slerpInPlace(out: Quaternion, from: Quaternion, to: Quaternion, t: number)
	local dot = dotq(from, to)

	if dot < 0 then
		inverseUnitInPlace(to)
		dot = -dot
	end
	local theta = math.acos(math.clamp(dot, -1, 1))
	local sinTheta = math.sin(theta)

	if sinTheta < 1e-6 then
		nlerpInPlace(out, from, to, t)
	else
		local ratioA = math.sin((1 - t) * theta) / sinTheta
		local ratioB = math.sin(t * theta) / sinTheta

		local x = ratioA * buffer.readf32(from, 0) + ratioB * buffer.readf32(to, 0)
		local y = ratioA * buffer.readf32(from, 4) + ratioB * buffer.readf32(to, 4)
		local z = ratioA * buffer.readf32(from, 8) + ratioB * buffer.readf32(to, 8)
		local w = ratioA * buffer.readf32(from, 12) + ratioB * buffer.readf32(to, 12)

		set(out, x, y, z, w)
	end
end
quaternion.slerpInPlace = slerpInPlace

--[=[
    @function slerp
    @within quaternion
    @param from Quaternion -- The starting quaternion.
    @param to Quaternion -- The target quaternion.
    @param t number -- The interpolation factor (0 to 1).
    @return Quaternion -- The spherically interpolated quaternion.
    @tag Method
	@tag Pure
    Spherically interpolates between two quaternions.
]=]
local function slerp(from: Quaternion, to: Quaternion, t: number): Quaternion
	local q = buffer.create(16) :: Quaternion
	slerpInPlace(q, from, to, t)
	return q
end
quaternion.slerp = slerp

--[=[
    @function slerpFromIdentityInPlace
    @within quaternion
    @param out Quaternion -- The quaternion to store the result.
    @param to Quaternion -- The target quaternion.
    @param t number -- The interpolation factor (0 to 1).
    @tag Method
    @tag Mutating
    Optimized SLERP from identity quaternion to `to`. Stores the result in `out`.
]=]
local function slerpFromIdentityInPlace(out: Quaternion, to: Quaternion, t: number)
	local tx, ty, tz, tw = getComponents(to)
	if tw < 0 then
		tx, ty, tz, tw = -tx, -ty, -tz, -tw
	end

	local cosTheta = tw -- Dot(identity, to) = w
	local theta = math.acos(math.clamp(cosTheta, -1, 1))

	if theta < 1e-6 then
		-- Very small angle, fallback to NLERP
		nlerpInPlace(out, identity(), to, t)
	else
		local sinTheta = math.sin(theta)
		local ratioA = math.sin((1 - t) * theta) / sinTheta -- This is always sin((1-t)*theta)/sin(theta)
		local ratioB = math.sin(t * theta) / sinTheta -- sin(t*theta)/sin(theta)

		local x = tx * ratioB
		local y = ty * ratioB
		local z = tz * ratioB
		local w = ratioA + tw * ratioB -- identity w = 1

		set(out, x, y, z, w)
	end
end
quaternion.slerpFromIdentityInPlace = slerpFromIdentityInPlace

--[=[
    @function slerpFromIdentity
    @within quaternion
    @param to Quaternion -- The target quaternion.
    @param t number -- The interpolation factor (0 to 1).
    @return Quaternion -- The spherically interpolated quaternion from identity.
    @tag Method
    @tag Pure
	Optimized SLERP from identity quaternion to `to`.
]=]
local function slerpFromIdentity(to: Quaternion, t: number): Quaternion
	local q = buffer.create(16) :: Quaternion
	slerpFromIdentityInPlace(q, to, t)
	return q
end
quaternion.slerpFromIdentity = slerpFromIdentity

--[=[
    @function rotateTowardsInPlace
    @within quaternion
    @param out Quaternion -- The quaternion to store the result.
    @param from Quaternion -- The starting quaternion.
    @param to Quaternion -- The target quaternion.
    @param maxRadiansDelta number -- The maximum angle in radians to rotate.
    @tag Method
    @tag Mutating
    Rotates one quaternion towards another by a maximum angle in radians, storing the result in `out`.
]=]
local function rotateTowardsInPlace(out: Quaternion, from: Quaternion, to: Quaternion, maxRadiansDelta: number)
	if maxRadiansDelta < 0 then
		to = inverseUnit(to)
		maxRadiansDelta = -maxRadiansDelta
	end

	local angle = angleq(from, to)
	if angle == 0 then
		set(out, getComponents(from))
		return
	end

	local t = math.min(1, maxRadiansDelta / angle)
	slerpInPlace(out, from, to, t)
end

--[=[
    @function rotateTowards
    @within quaternion
    @param from Quaternion -- The starting quaternion.
    @param to Quaternion -- The target quaternion.
    @param maxRadiansDelta number -- The maximum angle in radians to rotate.
    @return Quaternion -- The resulting quaternion after rotation.
    @tag Method
	@tag Pure
    Rotates one quaternion towards another by a maximum angle in radians.
]=]
function quaternion.rotateTowards(from: Quaternion, to: Quaternion, maxRadiansDelta: number): Quaternion
	local q = buffer.create(16) :: Quaternion
	rotateTowardsInPlace(q, from, to, maxRadiansDelta)
	return q
end
quaternion.rotateTowardsInPlace = rotateTowardsInPlace

--[=[
    @function setFromToRotation
    @within quaternion
    @param q Quaternion -- The quaternion to set.
    @param from Vector3 -- The starting direction vector.
    @param to Vector3 -- The target direction vector.
	@tag Method
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
	@tag Method
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
	@function setAxisAngle
	@within quaternion
	@param q Quaternion -- The quaternion to set.
	@param axis Vector3 -- The axis of rotation.
	@param angle number -- The angle of rotation in radians.
	@tag Method
	@tag Mutating
	Sets an existing quaternion from an axis-angle representation.
]=]
local function setAxisAngle(q: Quaternion, axis: vector, angle: number)
	local halfAngle = angle * 0.5
	local s = math.sin(halfAngle)
	local x = axis.x * s
	local y = axis.y * s
	local z = axis.z * s
	local w = math.cos(halfAngle)
	set(q, x, y, z, w)
end
quaternion.setAxisAngle = setAxisAngle :: (q: Quaternion, axis: Vector, angle: number) -> ()

--[=[
    @function setLookRotation
    @within quaternion
    @param q Quaternion -- The quaternion to set.
    @param forward Vector3 -- The forward direction vector.
    @param up Vector3 -- The up direction vector.
	@tag Method
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
	@function rotateVector
	@within quaternion
	@param q Quaternion -- The quaternion.
	@param v Vector3 -- The vector to rotate.
	@return Vector3 -- The rotated vector.
	@tag Method
	Rotates a vector by the quaternion.
]=]
local function rotateVector(q: Quaternion, v: vector): vector
	local qx, qy, qz, s = getComponents(q)
	local u = vector.create(qx, qy, qz)
	-- u is the imaginary vector part of the quaternion
	-- s is the real scalar part of the quaternion

	-- Quaternion-vector multiplication (q * v * q^-1)
	local uv = vector.cross(u, v)
	local uDotv = vector.dot(u, v)
	local uLenSq = vector.dot(u, u)

	return (u * (2 * uDotv)) + (v * (s * s - uLenSq)) + (uv * (2 * s))
end
quaternion.rotateVector = rotateVector :: (q: Quaternion, v: Vector) -> Vector3 & vector

--[=[
    @function toAxisAngle
    @within quaternion
    @param q Quaternion -- The quaternion.
    @return Vector3, number -- The axis of rotation as a Vector3 and the angle in radians.
	@tag Decomposition
    Converts the quaternion to an axis-angle representation.
]=]
function quaternion.toAxisAngle(q: Quaternion): (Vector3 & vector, number)
	local x, y, z, w = getComponents(q)

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
	@tag Decomposition
    Converts the quaternion and position to a CFrame.  
    You can use `quaternion.rotation` if position is not needed.
]=]
function quaternion.toCFrame(x: number, y: number, z: number, q: Quaternion): CFrame
	local qx, qy, qz, qw = getComponents(q)

	return CFrame.new(x, y, z, qx, qy, qz, qw)
end

--[=[
    @function toCFrameFromPosition
    @within quaternion
    @param position Vector3 -- The position vector.
    @param q Quaternion -- The quaternion.
    @return CFrame -- The resulting CFrame.
	@tag Decomposition
    Converts the quaternion and position vector to a CFrame.  
    You can use `quaternion.rotation` if position is not needed.
]=]
function quaternion.toCFrameFromPosition(position: Vector, q: Quaternion): CFrame
	local x, y, z = (position :: any).x, (position :: any).y, (position :: any).z
	local qx, qy, qz, qw = getComponents(q)

	return CFrame.new(x, y, z, qx, qy, qz, qw)
end

--[=[
    @function tostring
    @within quaternion
    @param q Quaternion -- The quaternion.
    @param format string? -- Optional format string for each component.
    @return string -- The string representation of the quaternion.
	@tag Decomposition
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
	@function fromEulerAngles
	@within quaternion
	@param x number -- The rotation around the x-axis in radians (pitch).
	@param y number -- The rotation around the y-axis in radians (yaw).
	@param z number -- The rotation around the z-axis in radians (roll).
	@return Quaternion -- The resulting quaternion.
	@tag Constructor
	Creates a quaternion from Euler angles XYZ in radians.
]=]
function quaternion.fromEulerAngles(x: number, y: number, z: number): Quaternion
	local q = buffer.create(16) :: Quaternion
	setEulerAngles(q, x, y, z)
	return q
end

--[=[
	@function fromAxisAngle
	@within quaternion
	@param axis Vector3 -- The axis of rotation.
	@param angle number -- The angle in radians.
	@return Quaternion -- The resulting quaternion.
	@tag Constructor
	Creates a quaternion from an axis-angle representation.
]=]
function quaternion.fromAxisAngle(axis: Vector, angle: number): Quaternion
	local q = buffer.create(16) :: Quaternion
	setAxisAngle(q, axis :: any, angle)
	return q
end

--[=[
    @function fromCFrame
    @within quaternion
    @param cf CFrame -- The CFrame to convert.
    @return Quaternion -- The resulting quaternion.
	@tag Constructor
    Creates a quaternion from a CFrame's rotation.
]=]
function quaternion.fromCFrame(cf: CFrame): Quaternion
	local q = buffer.create(16) :: Quaternion
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
	@tag Constructor
    Creates a quaternion that represents the rotation from one direction vector to another.
]=]
function quaternion.fromToRotation(from: Vector, to: Vector): Quaternion
	local q = buffer.create(16) :: Quaternion
	setFromToRotation(q, from :: any, to :: any)
	return q
end

--[=[
    @function lookRotation
    @within quaternion
    @param forward Vector3 -- The forward direction vector.
    @param up Vector3 -- The up direction vector.
    @return Quaternion -- The resulting quaternion representing the rotation.
	@tag Constructor
    Creates a quaternion that represents a rotation looking in a specified forward direction with a given up direction.
]=]
function quaternion.lookRotation(forward: Vector, up: Vector): Quaternion
	local q = buffer.create(16) :: Quaternion
	setLookRotation(q, forward :: any, up :: any)
	return q
end

--[=[
	@function lookAt
	@within quaternion
	@param from Vector3 -- The starting position.
	@param to Vector3 -- The target position to look at.
	@param up Vector3? -- Optional up direction vector. Defaults to (0, 1, 0) if not provided.
	@return Quaternion -- The resulting quaternion representing the rotation to look at the target.
	@tag Constructor
	Creates a quaternion that represents a rotation looking from one position to another, with an optional up direction.
]=]
function quaternion.lookAt(from: Vector, to: Vector, up: Vector?): Quaternion
	local forward = vector.normalize((to :: any) - (from :: any))
	local q = buffer.create(16) :: Quaternion
	setLookRotation(q, forward, up :: any or vector.create(0, 1, 0))
	return q
end

return quaternion
