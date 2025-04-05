shader_type spatial;


// PARAMETERS

uniform vec3 main_color : source_color;
uniform vec3 edge_color : source_color;

const float time_mod = 0.5;
const float cell_shaper = .9;
const float scaling = 6.0;
const float cell_culling = 0.16;
const float edge_threshhold = 0.25;
const float point_threshhold = 0.62;


// FUNCTIONS --------------


// vec2 to vec2 hash
// BORROWED FROM Shane - https://www.shadertoy.com/view/Mly3WV
vec2 hash22(vec2 p, float w) { 

    // The Voronoi pattern needs to be repeatable. Hence the "mod" line below.
    p = mod(p, w);
    // Tweaked vector hash for efficiency
    float n = sin(dot(p, vec2(41, 289)));
    
	// STATIC
	//return fract(vec2(262144, 32768)*n)*.9 + .1; 
    
    // Animated.
    p = fract(vec2(262144, 32768)*n); 
    // Cellular split
	// 6.---- is double pi
	// With p this makes a random angle modified over time
    return sin( p*6.2831853 + (TIME * time_mod))*cell_shaper + .5; 
}

varying float vx;
// 2D 2nd-order Voronoi, found through Shane,
// modification of IQ algorithm.
float Voronoi(in vec2 p, float w, out vec2 center){
    
    
	vec2 g = floor(p), o;
	p -= g;
	
	vec3 d = vec3(1.4142); // 1.4, etc. "d.z" holds the distance comparison value.
    vec2 pos;
	
	for(int y=-1; y<=1; y++){
		for(int x=-1; x<=1; x++){
            
			o = vec2(float(x), float(y));
            o += hash22(g + o, w) - p;
            
			d.z = length(o);//(dot(o, o)); 
            
            // More distance metrics.
            //o = abs(o);
            //d.z = mix(max(abs(o.x)*.866025 + o.y*.5, -o.y), dot(o, o), .2);//
            d.z = max(abs(o.x)*.866025 - o.y*.5, o.y);
            //d.z = max(abs(o.x) + o.y*.5, -(o.y)*.8660254);
            //d.z = max(o.x, o.y);
            //d.z = (o.x*.7 + o.y*.7);
            
            d.y = max(d.x, min(d.y, d.z));
            d.x = min(d.x, d.z); 
            
		}
	}
 					 
	d/=1.4142;
    
    //vx = d.x;
    
    d = smoothstep(0., 1., d);
	center = d.zx;
    
    return max(d.y/1.333 - d.x, 0.) * 1.333;
    
   
    //return d.y - d.x;
    
}


// PROCESSES -----------

// v for voronoi
varying float v;
// c for center
//varying vec2 c;

void vertex() {
	// Called for every vertex the material is visible on.
	vec2 uv = VERTEX.xz + vec2(TIME * time_mod);
	
	vec2 c;
	
	v = Voronoi(uv * scaling, scaling, c);
	VERTEX += NORMAL * sin(c.x * c.y + TIME) * -.2;
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	vec2 uv = VERTEX.xz + vec2(TIME * time_mod);
	
	vec2 c;
	
	float new_v = Voronoi(uv * scaling, scaling, c);
	
	// Done this way for efficiency, no if statement
	float enabled = float(new_v > cell_culling);
	ALBEDO = main_color * enabled;
	EMISSION = main_color * enabled;
	FOG.a = new_v * 0.4;
	ALPHA = new_v;
	
	if(new_v < edge_threshhold && bool(enabled)) {
		ALBEDO = edge_color;
		EMISSION = edge_color;
		ALPHA = 1.;
	}
}
