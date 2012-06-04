// Lambert formula: L dot N * C * Il,
//   where L is direction from surface to light, N is normal, C is color, Il is light intensity
// This shader holds alpha constant at 1.0 and is intended to be blended
// additively with a prior ambient pass.

void main(void) {
  // no output on ambient pass
  if (PASS != 0) {
    vec3 N = normalize(vEyeSpaceSurfaceNormal);
    vec3 L = -EyeSpaceLightDirection;
    vec3 C =  LightDiffuseColor.rgb * MaterialDiffuseColor.rgb *
              MaterialDiffuseColor.a * MaterialDiffuseIntensity;
    float Il = 1.0; // intensity is 1: no attenuation for directional lights

    float lambert = dot(N, L);
    gl_FragColor += vec4(lambert * C * Il, 1.0);
  }
}
