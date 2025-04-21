shader_type spatial;
render_mode world_vertex_coords;

// Parameters
uniform float quad_rot_amp = 3.0;
uniform float cube_rot_amp = 1.0;
uniform float player_disruption;
uniform float max_disruption_range;

// Needed info
group_uniforms data;
uniform float weight;
uniform vec3 position;

// Efficient random function
float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

float calc_value(float modifier) {
	return (sin(TIME + modifier) + cos(weight)) + (sin(position.x) * quad_rot_amp) - (sin(position.y + modifier) * quad_rot_amp)
		+ (cos(position.z) * quad_rot_amp);
}

void vertex() {
	// Called for every vertex the material is visible on.

	// Rotate around the center
	float centerRot = TIME * cube_rot_amp;
	vec3 rotationPosOffset = vec3(sin(centerRot), 0, cos(centerRot)) * 2.0;

	// Calculate cube rotation matrices
	mat4 cRotationY = mat4(
		vec4(cos(centerRot), 0, sin(centerRot), 0),
		vec4(0, 1.0f, 0, 0),
		vec4(-sin(centerRot), 0, cos(centerRot), 0),
		vec4(0, 0, 0, 1)
	);
	mat4 cRotationZ = mat4(
		vec4(cos(centerRot), -sin(centerRot), 0, 0),
		vec4(sin(centerRot), cos(centerRot), 0, 0),
		vec4(0, 0, 1.0f, 0),
		vec4(0, 0, 0, 1)
	);


	// Create rotation matrix

	float rotDeg = TIME * quad_rot_amp;
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


	// Get distance to camera for shaking
	vec3 diff = VERTEX - CAMERA_POSITION_WORLD;
	float diffLength = length(diff);
	if(diffLength < max_disruption_range) {
		float disruption_amount = max_disruption_range - diffLength;
		float rand = random(rotationPosOffset.xz + UV);
		vec3 direction = vec3(rand) * disruption_amount * player_disruption;
		rotationPosOffset += direction;
	}


	// Apply cube rotation before position offset
	VERTEX = (vec4(VERTEX, 1.0) * rotation).xyz;
	VERTEX = (vec4(VERTEX, 1.0) * cRotationY * cRotationZ).xyz;
	VERTEX = VERTEX + rotationPosOffset;
}


void fragment() {
	// Called for every pixel the material is visible on.

	ALBEDO = vec3(calc_value(VERTEX.x + VERTEX.y), calc_value(UV.x + UV.y), calc_value(COLOR.x +
		COLOR.y + COLOR.z));
	ALPHA = calc_value(NORMAL.x + NORMAL.y + NORMAL.z);
}