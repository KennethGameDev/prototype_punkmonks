shader_type canvas_item;

uniform vec4 overlay_color_test = vec4(0, 0, 0, 1);

void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 overlay(vec4 base, vec4 blend){
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 sprite_color_data = texture(TEXTURE, UV).rgba;
	COLOR = overlay(sprite_color_data, overlay_color_test);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
