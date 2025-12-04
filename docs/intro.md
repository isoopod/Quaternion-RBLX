---
sidebar_position: 1
---

# Intro

Quaternion RBLX is a Roblox library which provides a robust library for using quaternions for rotations.

## What is a Quaternion?

A quaternion is a mathematical object that can represent a rotation in 3D space using four numbers `(x, y, z, w)`. Unlike Euler angles or `CFrame.Angles`, quaternions do not suffer from glimbal lock and can be smoothly interpolated.

Key points:

- They represent rotation *independently* of position.
- They can be *combined efficiently* through multiplication.
- They allow for *smooth interpolation* between rotations (slerp).

---

### How Quaternions Differ to CFrames?

A CFrame is a *4x4 Affine Transformation Matrix*. We however only think about CFrames as a 4x3 matrix, or a 3x3 rotation matrix and Vector3 position. This is because Roblox abstracted away the last row of the 4x4 matrix, which is always [0, 0, 0, 1]. Affine Transformation Matrices are industry standard for 3D engines, but most engines have you work with rotations using quaternions instead of on the matrix directly. The reason:

- *Stability:* Repeated matrix multiplications can introduce numerical errors.
- *Interpolation:* Smooth rotation blending is easier with quaternions.
- *Efficiency:* Quaternions are easier to multiply than rotation matrices, and smaller in memory. Most game engines will store rotations as quaternions internally because of this, only converting to an affine transformation matrix for rendering or other areas where it performs better.

In Roblox, `CFrame` exposes this matrix directly, but working with quaternions allows you to benefit from these advantages while still converting to/from CFrames when needed.

---

## Why Use Quaternions?

Even though Roblox provides many methods in `CFrame` for rotations, quaternions offer several important benefits:

### 1. Avoid Gimbal Lock

Euler angles (`Vector3`) or incremental `CFrame.Angles` can suffer from **gimbal lock**, a situation where two rotation axes align and you lose a degree of freedom. Quaternions represent rotations in 4D space, eliminating gimbal lock entirely.

### 2. Smooth Interpolation

Rotations between two orientations can be smoothly interpolated using **slerp** (spherical linear interpolation), which is trivial with quaternions:

```lua
local q1 = Quaternion.fromCFrame(CFrame.Angles(0, 0, 0))
local q2 = Quaternion.fromCFrame(CFrame.Angles(0, math.rad(90), 0))
local qInterpolated = Quaternion.slerp(q1, q2, 0.5)
```

This produces a natural, consistent rotation, which is much harder to achieve with CFrames directly.

### 3. Compact and Efficient

Quaternions store rotations using only four numbers `(x, y, z, w)`, instead of a full 3x3 matrix. They are easy to combine using multiplication, and more memory-efficient than repeatedly constructing `CFrame` matrices.

### 4. Stable Composition

Combining multiple rotations is cleaner with quaternions:

```lua
local q1 = Quaternion.fromEulerAngles(0, math.rad(45), 0)
local q2 = Quaternion.fromEulerAngles(math.rad(30), 0, 0)
local qCombined = Quaternion.multiply(q1, q2)
local cframe = Quaternion.rotation(qCombined)
```

With CFrames, repeated multiplication can introduce numerical drift, whereas quaternions remain stable and normalised.

---

Quaternions give you a *robust, stable, and mathematically sound* way to handle rotations in Roblox, making your animations, physics, and camera systems far more predictable and smooth than using `CFrame` angles alone.
