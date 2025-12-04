# Quaternion-RBLX

[Documentation](isoopod.github.io/Quaternion-RBLX)

<!--moonwave-hide-before-this-line-->

Quaternion-RBLX is a fast, lightweight quaternion library for Roblox. It focuses on performance, predictable behaviour, and being easy to use in real gameplay or simulation code. Rotations are stored in `buffer` objects instead of tables, which means cheaper allocations, less GC pressure, and better performance in tight loops.

The library includes a full set of quaternion operations, conversion helpers, and utilities for working with Roblox types.

---

## What this project is

This library is designed to solve a simple problem:
Roblox gives you `CFrame` for rotations, but many systems work better if the rotation maths is done **with quaternions instead of affine matrices**.

Quaternion-RBLX provides:

* A quaternion type stored inside a Roblox buffer
* Very fast maths operations
* A large, complete API for manipulating rotations
* Helpers for converting to and from `CFrame` and `Vector3`
* In-place and allocation-free variants of many operations
* Behaviour that matches how quaternions work in most other engines

The goal is to let you treat quaternions as a first-class rotation type on Roblox.

---

## Why use quaternions on Roblox?

Although `CFrame` is the official way to represent transforms, it's still a 4×4 affine matrix. While that works fine, other engines typically *don’t* manipulate their rotation matrices directly. Instead, they use quaternions internally for stability and performance, then convert to a matrix at the end.

Quaternions help with:

* Smoothly blending rotations (e.g., animation, aiming, cameras)
* Avoiding problems like gimbal lock
* Efficiently composing rotations every frame
* Working with angular velocities or small incremental rotations
* More stable numeric behaviour over long periods
* Reducing the cost of repeated rotation updates

You can still use CFrames for the final transform — but doing the intermediate maths with quaternions tends to be cleaner and more reliable.

---

## What the library includes

* Construction helpers (`fromAxisAngle`, `fromEuler`, `lookAt`, etc.)
* Conversion helpers (`toCFrame`, `toEuler`, `rotateVector`, etc.)
* Basic operations (`multiply`, `add`, `scale`, `dot`, `normalise`)
* Advanced operations (`slerp`, `nlerp`, `exp`, `log`, inversion, conjugation)
* In-place versions for performance

Everything is designed to be easy to understand and predictable.
