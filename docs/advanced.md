---
sidebar_position: 4
---

# Advanced

This guide covers more advanced use cases — and importantly, highlights performance-sensitive operations, how to use the “pure” vs “in-place / mutating” variants, and when that distinction matters.

## API Overview (key features)

Quaternion-RBLX provides a comprehensive set of quaternion operations, including:

- **Constructors:** `.new(x, y, z, w)`, `.fromEulerAngles(...)`, `.fromAxisAngle(axis, angle)`, `.fromCFrame(...)`, `.lookAt(...)`, `.lookAlong(...)`, `.fromToRotation(...)`, etc.  
- **Decomposition:** `.getComponents()`, `.toEulerAngles()`, `.toAxisAngle()`, `.toCFrame(position)`, etc.  
- **Quaternion math:** `.multiply(...)`, `.inverse()`, `.normalize()`, `.dot(...)`, `.angle(...)`  
- **Rotation of vectors:** `.rotateVector(...)`  
- **Interpolation:** `.slerp(...)`, `.nlerp(...)`, `.rotateTowards(...)`, and in-place variants (e.g. `.slerpInPlace(...)`, `.rotateTowardsInPlace(...)`)  
- **Utility:** `.magnitude()`, `.magnitudeSquared()`, `.equals()`, `.fuzzyEquals(...)`, `.tostring(...)`, property-style getters (`.x`, `.y`, `.z`, `.w`) etc.

---

## Performance Considerations & “Pure” vs “In-Place / Mutating” Variants

Because Quaternion-RBLX uses a fixed buffer type under the hood, it provides both pure (functional) and in-place (mutating) variants of many operations.

### When to use pure (functional) methods

- When you need immutability (keeping old orientations, branching rotations, preserving original quaternion state)
- When readability / clarity is more important than micro-optimisation — e.g. setup code, configuration, one-off rotations

Example:

```lua
local q1 = Quaternion.fromEulerAngles(0, math.rad(45), 0)
local q2 = Quaternion.fromAxisAngle(Vector3.new(1,0,0), math.rad(30))
local qCombined = Quaternion.multiply(q1, q2)
```

Here both q1 and q2 remain unchanged; qCombined is new.

### When to prefer in-place (mutating) methods

- In performance-critical loops (e.g. per-frame updates, animations, physics loops)
- When you want to minimise memory allocations / garbage / buffer churn
- When you are reusing quaternion objects (e.g. continuously rotating an object, or interpolating over time)

Example:

```lua
local currentQ = Quaternion.fromCFrame(part.CFrame)
-- reuse the same quaternion each frame
Quaternion.slerpInPlace(currentQ, currentQ, targetQ, t)
Quaternion.applyRotation(part, currentQ)
```

Or:

```lua
Quaternion.rotateTowardsInPlace(currentQ, currentQ, targetQ, math.rad(5) * dt)
Quaternion.applyRotation(part, currentQ)
```

Because the buffer is mutated instead of creating a new quaternion each time, this reduces memory churn and can lead to smoother performance, especially in contexts where many quaternion operations happen per frame (e.g. real-time physics, animations, camera rigs, procedural systems).

---

## Vector Rotations & Directional Transformations

If you need to rotate direction vectors (like forward/up/right) or compute transformed offsets (e.g. firing direction, velocity vectors, local-space offsets), quaternions let you rotate vectors cleanly:

```lua
local q = Quaternion.fromAxisAngle(Vector3.new(0,1,0), math.rad(90))
local original = Vector3.new(1, 0, 0)
local rotated = Quaternion.rotateVector(q, original)
-- rotated is now roughly Vector3.new(0, 0, -1)
```

This is much cleaner than constructing a full CFrame just to rotate a vector, and avoids unnecessary overhead when you only care about direction — ideal for projectiles, physics impulses, local offsets, procedural motion, etc.

---

## Rotation-Delta, Angular Velocity & Physics-Style Continuous Rotation

For continuous rotations — e.g. rotating an object at a constant angular velocity (wheels, spinning objects, rotating turrets), or applying incremental rotation deltas per frame — quaternions are excellent. You can convert an angular velocity (axis + angular speed) to a quaternion and multiply it with the current orientation each update:

```lua
local currentQ = Quaternion.fromCFrame(part.CFrame)
local angularAxis = Vector3.new(0, 1, 0)
local angularSpeed = math.rad(90)  -- 90 degrees per second

game:GetService("RunService").Heartbeat:Connect(function(dt)
    local deltaQ = Quaternion.fromAxisAngle(angularAxis, angularSpeed * dt)
    Quaternion.multiplyInPlace(currentQ, deltaQ, currentQ)
    Quaternion.applyRotation(part, currentQ)
end)
```

This maintains smooth, stable rotation over time without accumulating drift, and works cleanly even with changing frame rates.

---

## Advanced Example

```lua
local part = workspace.Turret
local currentQ = Quaternion.fromCFrame(part.CFrame)
local targetPos = workspace.Target.Position
local rotationSpeed = math.rad(30)  -- spin speed (radians per second)

game:GetService("RunService").Heartbeat:Connect(function(dt)
    -- 1. Compute look-at quaternion
    local lookQ = Quaternion.lookAt(part.Position, targetPos)

    -- 2. Rotate current orientation toward lookQ (limited angular speed)
    Quaternion.rotateTowardsInPlace(currentQ, currentQ, lookQ, rotationSpeed * dt)

    -- 3. Apply a slow continuous spin around Z (e.g. turret barrel)
    local spinQ = Quaternion.fromAxisAngle(Vector3.ZAxis, rotationSpeed * dt)
    Quaternion.multiplyInPlace(currentQ, spinQ, currentQ)

    Quaternion.applyRotation(part, currentQ)
end)
```

This snippet shows how you can mix interpolation, look-at orientation, and continuous rotation — all cleanly handled via quaternions, with minimal allocations if used with in-place / reused quaternion buffers.
