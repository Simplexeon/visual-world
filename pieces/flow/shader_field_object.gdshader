shader_type spatial;

// Parameters
uniform float amplifier;

// Needed info
group_uniforms data;
uniform float weight;
uniform vec3 position;

float calc_value(float modifier) {
	return (sin(TIME + modifier) + cos(weight)) + (sin(position.x) * amplifier) - (sin(position.y + modifier) * amplifier)
		+ (cos(position.z) * amplifier);
}

void vertex() {
	// Called for every vertex the material is visible on.
	
}


void fragment() {
	// Called for every pixel the material is visible on.
	
	ALBEDO = vec3(calc_value(VERTEX.x + VERTEX.y), calc_value(UV.x + UV.y), calc_value(COLOR.x + 
		COLOR.y + COLOR.z));
	ALPHA = calc_value(NORMAL.x + NORMAL.y + NORMAL.z);
}