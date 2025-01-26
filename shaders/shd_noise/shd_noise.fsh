//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;

float random(vec2 uv) {
    return fract(sin(dot(uv + u_time, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
  vec2 uv = gl_FragCoord.xy;
  float n = random(uv * 0.87);
  
	vec4 noise = vec4(vec3(n), 1.00);
	vec4 color = (noise * 1.00) + 1.0;
	
	gl_FragColor = v_vColour * color * texture2D(gm_BaseTexture, v_vTexcoord);
}