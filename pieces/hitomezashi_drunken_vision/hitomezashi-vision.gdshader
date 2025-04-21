shader_type canvas_item;

uniform float scaling;
uniform float time_scale;
uniform bool seedA[20];
uniform bool seedB[20];
uniform sampler2D noiseA;
uniform sampler2D noiseB;

uniform float threshold;


void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 sampleSeed(ivec2 pos, vec4 input, bool seed[20]) {
	vec4 output = input;

	if((pos.y + int(seed[pos.x])) % 2 == 0) {
		output.w = 1.0;
	}

	return output;
}

void fragment() {
	// Called for every pixel the material is visible on.

	vec4 output = vec4(0);
	vec2 coord = UV * scaling;
	coord += mod(coord * TIME * time_scale, coord);

	vec2 coord_uv;
	coord = modf(coord / 0.1, coord_uv);

	ivec2 icoord_uv = ivec2(coord_uv);

	output = sampleSeed(icoord_uv, output, seedA);
	output = sampleSeed(icoord_uv.yx, output, seedB);

	float time = mod(TIME, 1.0 * time_scale);

	if(output.w > 0.5) {
		output.w = texture(noiseA, mod(UV * scaling + (TIME * time_scale), vec2(1.0))).r;
	}
	else {
		output.w = texture(noiseB, UV).r;
	}

	float angle = output.w * (2.0 * PI);

	coord = UV * scaling;
	coord += mod(coord * TIME * time_scale, coord);
	coord += vec2(sin(angle), cos(angle)) * .0;

	coord = modf(coord / 0.1, coord_uv);

	icoord_uv = ivec2(coord_uv);

	output = sampleSeed(icoord_uv, output, seedA);
	output = sampleSeed(icoord_uv.yx, output, seedB);

	if(output.w > 0.5) {
		output.w = texture(noiseA, mod(UV * scaling + (TIME * time_scale), vec2(1.0))).r;
	}
	else {
		output.w = texture(noiseB, UV).r;
	}

	output.r = sin(angle) * 0.5;
	output.g = cos(angle) * 0.5;
	output.b = tan(angle) * 0.5;

	COLOR = output;
}



//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
