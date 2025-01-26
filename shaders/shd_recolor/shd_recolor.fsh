//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec3 u_color;

void main() {
  vec4 original_color = texture2D(gm_BaseTexture, v_vTexcoord);
  float grayscale = dot(original_color.rgb, vec3(0.299, 0.587, 0.114));
  vec3 recolored = grayscale * u_color;
  gl_FragColor = vec4(recolored, original_color.a);
}