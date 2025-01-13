varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_light_pos; // Light position
uniform sampler2D u_texture;

void main() {
  vec4 base_color = texture2D(u_texture, v_vTexcoord);

  // Calculate light direction
  vec2 planet_center = vec2(0.0, 0.0); // Assuming centered UV
  vec2 light_dir = normalize(u_light_pos - planet_center);

  // Calculate shading
  vec2 pixel_dir = normalize(v_vTexcoord - planet_center);
  float intensity = max(0.0, dot(pixel_dir, light_dir));

  // Add light and shadow
  vec4 shaded_color = base_color * (0.3 + 0.7 * intensity);
	
  gl_FragColor = shaded_color;
}