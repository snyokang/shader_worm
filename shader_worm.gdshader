shader_type canvas_item;

uniform vec4 worm_color: source_color = vec4(1.0);
uniform float worm_width: hint_range(0.0, 1.0) = 0.1;
uniform float worm_length: hint_range(0.0, 2.0) = 1.0;

instance uniform float wiggle_speed = 0.0;
instance uniform float flexibility = 0.0;
instance uniform float phase = 0.0;
instance uniform float width = 0.35;

float sdArc(vec2 p, vec2 cs, float ra, float rb) {
	p.y = abs(p.y);
	return ((cs.x * p.y - cs.y * p.x > 0.0)?
			length(p - cs * ra):
			abs(length(p) - ra)) - rb;
}

void fragment() {
	vec2 uv = 2.0 * UV - 1.0;
	float aspect = TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y;
	uv.y *= aspect;
	
	float t = TIME * wiggle_speed + phase;
	float theta = max(abs(cos(t)) * flexibility, 0.01);
	
	vec2 cs = vec2(cos(theta), sin(theta));
	float ra = worm_length / theta;
	vec2 offset = vec2(ra, 0);
	uv *= step(0.0, cos(t)) * 2.0 - 1.0;
	
	float d = sdArc(uv + offset, cs, ra, width);
	float alpha = smoothstep(0.0, 0.1, -d);
	
	COLOR = vec4(worm_color.rgb, alpha);
}

