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
	
	// Create rotation matrix
	float rotDeg = TIME * amplifier;
	mat4 rotationY = mat4(
		vec4(cos(rotDeg), 0, sin(rotDeg), MODELVIEW_MATRIX[0][3]),
		vec4(0, 1.0f, 0, MODELVIEW_MATRIX[1][3]),
		vec4(-sin(rotDeg), 0, cos(rotDeg), MODELVIEW_MATRIX[2][3]),
		vec4(0, 0, 0, 1)
	);
	mat4 rotationZ = mat4(
		vec4(cos(rotDeg), -sin(rotDeg), 0, 0),
		vec4(sin(rotDeg), cos(rotDeg), 0, 0),
		vec4(0, 0, 1.0f, 0),
		vec4(0, 0, 0, 1)
	);
	mat4 rotation = rotationY * rotationZ;
	
	
	// Move vertex
	vec4 bonusVertex = vec4(VERTEX.x, VERTEX.y, VERTEX.z, 1) * rotation;
	VERTEX = bonusVertex.xyz;
}


void fragment() {
	// Called for every pixel the material is visible on.
	
	ALBEDO = vec3(calc_value(VERTEX.x + VERTEX.y), calc_value(UV.x + UV.y), calc_value(COLOR.x + 
		COLOR.y + COLOR.z));
	ALPHA = calc_value(NORMAL.x + NORMAL.y + NORMAL.z);
}