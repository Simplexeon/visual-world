shader_type spatial;

uniform float amplifier;
uniform sampler2D noise_offset;
uniform float movement_amplifier;

void vertex() {
	// Called for every vertex the material is visible on.
	
	//VERTEX = VERTEX + (NORMAL * sin(TIME + texture(noise_offset, UV).r) * amplifier);
	
	vec3 target = vec3(cos(TIME) * -sin(TIME + movement_amplifier), sin(TIME) * -cos(TIME + movement_amplifier), cos(TIME) * -tan(TIME + movement_amplifier));
	vec3 translation = target - NODE_POSITION_WORLD;
	
	if(dot(normalize(translation), NORMAL) > 0.0) {
		VERTEX += translation;
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
