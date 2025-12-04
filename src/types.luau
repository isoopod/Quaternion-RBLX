--[=[
    @class Quaternion

    This library orders the quaternion components as `[x, y, z, w]`, where `x, y, z` are the imaginary vector part and `w` is the real scalar part.  
    Mathmatical notation often represents quaternions as `[w, x, y, z]`, so be cautious when interfacing with other libraries or mathematical texts.

    For performance reasons, operators (`==` and `*`) cannot not supported. Use the provided methods for quaternion operations.
]=]

--- @type Quaternion buffer
--- @within Quaternion
--- A branded buffer type representing a quaternion, 16 bytes.
type Brand<T, Tag> = T & { __brand: Tag }
export type Quaternion = Brand<buffer, "quaternion">

export type Vector = vector | Vector3

return nil
