//= require "shaders/lib/lights.glsl"

shared uniform int PASS;
shared uniform float MaterialDiffuseIntensity;
shared uniform vec4 MaterialDiffuseColor;
shared uniform mat3 NormalMatrix;
shared uniform mat4 ModelViewMatrix;

shared varying vec3 vEyeSpaceSurfaceNormal, vEyeSpaceSurfacePosition;
