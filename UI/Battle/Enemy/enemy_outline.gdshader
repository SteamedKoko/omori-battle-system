shader_type canvas_item;

// --- Exported properties ---
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0, 0.5) = 2.0;
uniform float glow_radius : hint_range(0.0, 20.0, 0.5) = 6.0;
uniform float glow_intensity : hint_range(0.0, 5.0, 0.1) = 1.5;
uniform float glow_falloff : hint_range(0.5, 8.0, 0.1) = 2.5;

void fragment() {
	vec2 uv = UV;
	vec2 texel = TEXTURE_PIXEL_SIZE;

	// --- Sample the original texture ---
	vec4 original = texture(TEXTURE, uv);

	// --- Outline pass ---
	// Sample alpha in a circle around the current pixel
	float outline_alpha = 0.0;
	int steps = 12;
	for (int i = 0; i < steps; i++) {
		float angle = (float(i) / float(steps)) * 6.28318530718; // 2 * PI
		vec2 offset = vec2(cos(angle), sin(angle)) * outline_width * texel;
		outline_alpha = max(outline_alpha, texture(TEXTURE, uv + offset).a);
	}

	// Only show outline where the original pixel is transparent
	float outline_mask = outline_alpha * (1.0 - original.a);

	// --- Glow pass ---
	// Accumulate nearby alpha values weighted by distance
	float glow_sum = 0.0;
	float weight_sum = 0.0;
	int glow_steps = 16;
	for (int i = 0; i < glow_steps; i++) {
		float angle = (float(i) / float(glow_steps)) * 6.28318530718;
		for (float r = 1.0; r <= glow_radius; r += 1.0) {
			vec2 offset = vec2(cos(angle), sin(angle)) * r * texel;
			float sampled_alpha = texture(TEXTURE, uv + offset).a;
			// Gaussian-like falloff based on distance
			float dist = r / glow_radius;
			float weight = exp(-dist * dist * glow_falloff);
			glow_sum += sampled_alpha * weight;
			weight_sum += weight;
		}
	}
	float glow_alpha = 0.0;
	if (weight_sum > 0.0) {
		glow_alpha = clamp((glow_sum / weight_sum) * glow_intensity, 0.0, 1.0);
	}

	// Don't draw glow where the original sprite or outline already is
	glow_alpha *= (1.0 - original.a) * (1.0 - outline_mask);

	// --- Composite layers: glow → outline → original ---
	vec4 glow_layer   = vec4(outline_color.rgb, glow_alpha * outline_color.a);
	vec4 outline_layer = vec4(outline_color.rgb, outline_mask * outline_color.a);

	// Blend glow first (bottom), then outline, then original on top
	vec4 result = glow_layer;
	result = mix(result, outline_layer, outline_layer.a);
	result = mix(result, original, original.a);

	COLOR = result;
}
