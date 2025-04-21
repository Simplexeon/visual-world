shader_type spatial;
render_mode depth_draw_opaque, unshaded;

uniform vec3 hatching_color;
uniform float view_dist;

uniform sampler2D depth_texture : hint_depth_texture, filter_linear_mipmap;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.

	float depth_tex = textureLod(depth_texture,SCREEN_UV,0.0).r;
	vec4 world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV*2.0-1.0,depth_tex*2.0-1.0,1.0);
	world_pos.xyz /= world_pos.w;

	float dist = distance(world_pos.xyz, CAMERA_POSITION_WORLD);

	float view_scaling = (VIEWPORT_SIZE.x + VIEWPORT_SIZE.y);
	float threshold = (1.0 - min(dist / view_dist, 1.0)) * 2.0 - 1.0;

	if(cos((SCREEN_UV.x + SCREEN_UV.y) * view_scaling) > threshold) {
		ALBEDO = hatching_color;
	}
	else {
		ALBEDO = vec3(sin(TIME + dist), cos(TIME + dist), tan(TIME + dist));
	}
}