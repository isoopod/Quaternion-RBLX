---
sidebar_position: 3
---


# Quickstart

This page gives a quick‑start overview of how to use Quaternion‑RBLX in your Roblox projects — when it's useful and how to integrate it with CFrames.

---

## Basic Usage

```lua
local Quaternion = require(path.to.Quaternion)

-- Create a quaternion rotation from a CFrame
local cframeRotation = Quaternion.fromCFrame(workspace.CurrentCamera.CFrame)

-- Create a quaternion rotation from Euler Angles
local eulerRotation = Quaternion.fromEulerAngles(0, math.rad(45), 0)

-- Combine the rotations
local combinedRotation = Quaternion.multiply(eulerRotation, cframeRotation)

-- Set the camera to the new rotation
Quaternion.applyRotation(workspace.CurrentCamera, combinedRotation)
```

This short example shows you can use Quaternions to rotate the camera by 45 degrees on the yaw axis.

It should be noted here that quaternion multiplication is not commutative; the order of multiplication matters.

When you multiply two quaternions, you are applying one rotation after another.  
The right-hand side quaternion (`rhs`) is applied first, and the left-hand side quaternion (`lhs`) is applied **after that**.  
In other words, `lhs * rhs` is taking `rhs` and rotating it by `lhs`.

This is the same as `CFrameA` * `CFrameB`; B is applied first and then transformed by A.

---

## Common Quaternion Functions

| Operation                        | Method / Use                                                                   |
| -------------------------------- | ------------------------------------------------------------------------------ |
| From Euler angles                | `Quaternion.fromEulerAngles(x, y, z)`                                          |
| From axis + angle                | `Quaternion.fromAxisAngle(axisVec, angleRadians)`                              |
| From a CFrame                    | `Quaternion.fromCFrame(someCFrame)`                                            |
| Multiply / combine rotations     | `Quaternion.multiply(q1, q2)`                                                  |
| Interpolate between orientations | `Quaternion.slerp(q1, q2, t)` - useful for smooth transitions                  |
| Convert quaternion → CFrame      | `Quaternion.toCFrame(x, y, z, q)` or `Quaternion.toCFrameAtPosition(posVec, q)`|
| Apply a rotation to a part       | `Quaternion.applyRotation(partOrModel, q)`                                     |
| Invert quaternion                | `Quaternion.inverse(q)`                                                        |
| Get the identity quaternion      | `Quaternion.identity()`                                                        |
| Get the angle between quaternions| `Quaternion.angle(q1, q2)`                                                     |
| Look at / look along vectors     | `Quaternion.lookAt(pos1, pos2)` or `Quaternion.lookAlong(forward, up)`         |
| Quaternion between two directions| `Quaternion.fromToRotation(dir1, dir2)`                                        |

---

## When to use

### Smooth Interpolation & Animation Transitions

If you want to interpolate between two orientations (e.g. camera turning, character aiming, UI rotations), using quaternions + slerp gives smooth, stable transitions. Doing the same via repeated CFrame.Angles or direct matrix‑blending often looks janky or results in interpolation artifacts.

### Clean Composition of Multiple Rotations

For complex rotations — like rotating an object around multiple axes over time, or applying sequential rotations relative to different frames — quaternions let you compose rotations reliably by quaternion multiplication. This avoids issues that arise when chaining CFrame multiplications and manual angle bookkeeping.

### Avoiding Numerical Instability & Gimbal‑Lock Issues

When using Euler angles (or incremental angle updates), you risk gimbal lock or edge‑case singularities depending on axis‑order. Quaternions sidestep this entirely. Also, quaternion mathematics tends to remain more numerically stable when combining many rotations.

### Efficiency & Clean Code for Rotation‑Heavy Systems

For any system where rotation is a first‑class concern (camera rigs, physics‑based movement, orientation tweening, spaceship attitude control, procedural motion, etc.), using a quaternion library simplifies code and reduces complexity: rotations become composable, invertible, and easy to manipulate.

### Interoperability with Roblox’s CFrame System

Because Quaternion‑RBLX lets you create a quaternion from a CFrame and convert back with :ToCFrame(), you can use it as a drop‑in enhancement in existing codebases — mixing quaternion logic where needed, and falling back to CFrame where convenient.

---

Use plain CFrame when you only need simple transforms: positioning, or static orientation, or when you compose transforms in a trivial way and don’t need interpolation or complex rotations.

---

## Example Use Cases

```lua
-- Example: Smoothly rotating a part toward a target orientation
local startQ = Quaternion.fromCFrame(part.CFrame)
local targetQ = Quaternion.fromEulerAngles(0, math.rad(180), 0)  -- face backwards
local t = 0

game:GetService("RunService").Heartbeat:Connect(function(dt)
    t = math.min(t + dt, 1)
    local qInterp = Quaternion.slerp(startQ, targetQ, t)
    Quaternion.applyRotation(part, qInterp)
end)
```

```lua
-- Example: Combining rotations - e.g. yaw then pitch
local yaw   = Quaternion.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(45))
local pitch = Quaternion.fromAxisAngle(Vector3.new(1, 0, 0), math.rad(30))
local final = Quaternion.multiply(yaw, pitch)

Quaternion.applyRotation(part, final)
```

```lua
-- Example: Look‑direction orientation (e.g. camera / turret / head)
Quaternion.applyRotation(part, Quaternion.lookAt(part.Position, targetPosition))
```

---

## Summary

Quaternion‑RBLX gives you a robust, expressive, and stable way to handle rotations. It plays nicely with Roblox’s native CFrame system, yet unlocks more advanced rotation‑centric logic: smooth interpolation, complex composition, orientation blending, look‑at logic, and more.

If your game or simulation involves anything more than “set this part to a fixed rotation” — especially dynamic or continuous rotations — quaternions are absolutely worth using.
