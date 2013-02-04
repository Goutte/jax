//= require "gl-matrix"

/* Sets the quaternion in `out` based on the given vec3 `angle` and `axis`. */
quat.fromAngleAxis = function(out, angle, axis) {
  // The quaternion representing the rotation is
  // q = cos(A/2)+sin(A/2)*(x*i+y*j+z*k)
  var half = angle * 0.5;
  var s = Math.sin(half);
  out[3] = Math.cos(half);
  out[0] = s * axis[0];
  out[1] = s * axis[1];
  out[2] = s * axis[2];
  return out;
};

/* Copies the upper-left 3x3 from `a` into `out`. Returns `out`. */
mat3.fromMat4 = function(out, a) {
  out[0] = a[0];
  out[1] = a[1];
  out[2] = a[2];
  out[3] = a[4];
  out[4] = a[5];
  out[5] = a[6];
  out[6] = a[8];
  out[7] = a[9];
  out[8] = a[10];
  return out;
};

/* Transforms vec3 `a` according to mat3 `b` and stores result in `out`. */
vec3.transformMat3 = function(out, a, b) {
  var x = a[0], y = a[1], z = a[2];
  out[0] = x * b[0] + y * b[3] + z * b[6];
  out[1] = x * b[1] + y * b[4] + z * b[7];
  out[2] = x * b[2] + y * b[5] + z * b[8];
  return out;
};

(function() {
  var xUnitVec3 = vec3.fromValues(1,0,0);
  var yUnitVec3 = vec3.fromValues(0,1,0);
  var zUnitVec3 = vec3.fromValues(0,0,1);

  var tmpvec3 = vec3.create();
  /* Generates a quaternion of rotation between two given normalized vectors */
  vec3.rotationTo = function (out, a, b) {
    var d = vec3.dot(a, b);
    var axis = tmpvec3;
    if (d >= 1.0) {
      quat.copy(out, quat.IDENTITY);
    } else if (d < (0.000001 - 1.0)) {
      vec3.cross(axis, xUnitVec3, a);
      if (vec3.length(axis) < 0.000001)
          vec3.cross(axis, yUnitVec3, a);
      if (vec3.length(axis) < 0.000001)
          vec3.cross(axis, zUnitVec3, a);
      vec3.normalize(axis, axis);
      quat.fromAngleAxis(out, Math.PI, axis);
    } else {
      var s = Math.sqrt((1.0 + d) * 2.0);
      var sInv = 1.0 / s;
      vec3.cross(axis, a, b);
      out[0] = axis[0] * sInv;
      out[1] = axis[1] * sInv;
      out[2] = axis[2] * sInv;
      out[3] = s * 0.5;
      quat.normalize(out, out);
    }
    if (out[3] > 1.0) out[3] = 1.0;
    else if (out[3] < -1.0) out[3] = -1.0;
    return out;
  };
})();

(function() {
    var mat = mat3.create();
    
    /**
    * Creates a quaternion from the 3 given vectors. They must be perpendicular
    * to one another and represent the X, Y and Z axes.
    *
    * If dest is omitted, a new quat4 will be created.
    *
    * Example: The default OpenGL orientation has a view vector [0, 0, -1],
    * right vector [1, 0, 0], and up vector [0, 1, 0]. A quaternion representing
    * this orientation could be constructed with:
    *
    * quat = quat4.fromAxes([0, 0, -1], [1, 0, 0], [0, 1, 0], quat4.create());
    *
    * @param {vec3} view the view vector, or direction the object is pointing in
    * @param {vec3} right the right vector, or direction to the "right" of the object
    * @param {vec3} up the up vector, or direction towards the object's "up"
    * @param {quat4} [dest] an optional receiving quat4
    *
    * @returns {quat4} dest
    **/
    quat.setAxes = function(out, view, right, up) {
      mat[0] = right[0];
      mat[3] = right[1];
      mat[6] = right[2];

      mat[1] = up[0];
      mat[4] = up[1];
      mat[7] = up[2];

      mat[2] = view[0];
      mat[5] = view[1];
      mat[8] = view[2];

      return quat.fromMat3(out, mat);
    };
})();

/**
 * mat4.IDENTITY -> mat4
 *
 * Represents a 4x4 Identity matrix.
 *
 * (Note: this is a Jax-specific extension. It does not appear by default
 * in the glMatrix library.)
 **/
mat4.IDENTITY = mat4.identity(mat4.create());

/**
 * quat.IDENTITY -> quat
 *
 * Represents the Identity quaternion.
 *
 * (Note: this is a Jax-specific extension. It does not appear by default
 * in the glMatrix library.)
 **/
quat.IDENTITY = quat.fromValues(0, 0, 0, 1);

/**
 * vec3.UNIT_X -> vec3
 *
 * Represents a unit vector along the positive X axis
 *
 * (Note: this is a Jax-specific extension. It does not appear by default
 * in the glMatrix library.)
 **/
vec3.UNIT_X = vec3.fromValues(1, 0, 0);

/**
 * vec3.UNIT_Y -> vec3
 *
 * Represents a unit vector along the positive Y axis
 *
 * (Note: this is a Jax-specific extension. It does not appear by default
 * in the glMatrix library.)
 **/
vec3.UNIT_Y = vec3.fromValues(0, 1, 0);

/**
 * vec3.UNIT_Z -> vec3
 *
 * Represents a unit vector along the positive Z axis
 *
 * (Note: this is a Jax-specific extension. It does not appear by default
 * in the glMatrix library.)
 **/
vec3.UNIT_Z = vec3.fromValues(0, 0, 1);
