extends Node

# Parameters

@export var freq_range : Vector2;
@export var oscillation_range : Vector2;

@export var audio_player : AudioStreamPlayer3D;
@export var particle_emitter : GPUParticles3D;
@export var camera : Camera3D;
@export var viewport : SubViewport;
@export var env : WorldEnvironment;


# Data

const sample_hz : float = 22000.0;

var frequency : float;
var phase_modifier : float = 1.0;
var phase : float = 0.0;

var hue_range : Vector2;

var playback : AudioStreamGeneratorPlayback;

var playing : bool = false;

var mode : Mode = Mode.Sine :
	set(value):
		mode = value;
		
		match mode:
			Mode.Sine:
				hue_range = Vector2(0.0, 0.25);
			
			Mode.Triangle:
				hue_range = Vector2(0.25, 0.45);
			
			Mode.Sawtooth:
				hue_range = Vector2(0.45, 0.75);
				
			Mode.Square:
				hue_range = Vector2(0.75, 1.0);

enum Mode {
	Sine,
	Triangle,
	Sawtooth,
	Square
}


# Processes

func _ready() -> void:
	
	frequency = freq_range.x;
	audio_player.stream.mix_rate = sample_hz;
	audio_player.play();
	playback = audio_player.get_stream_playback();
	

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				playing = true;
				particle_emitter.emitting = true;
			else:
				playing = false;
				particle_emitter.emitting = false;
	
	if event is InputEventMouseMotion:
		var screen_size : Vector2 = get_viewport().get_visible_rect().size;
		
		# Position in UV coords
		var relative_pos : Vector2 = Vector2(event.position.x / screen_size.x, event.position.y / screen_size.y);
		relative_pos.x = relative_pos.x * relative_pos.x;
		
		# Modify sound wave
		frequency = (freq_range.y * relative_pos.x) + freq_range.x;
		phase_modifier = (oscillation_range.y * relative_pos.y) + oscillation_range.x;
		
		# Set particle position
		particle_emitter.global_position = Plane(Vector3(0, 0, 1), 0.0).intersects_ray(
				camera.project_ray_origin(event.position),
				camera.project_ray_normal(event.position));
		
		
		var mat : Material = particle_emitter.draw_pass_1.material;
		mat.emission = Color.from_hsv(
				hue_range.y * 
				((sin(relative_pos.x + relative_pos.y + Time.get_ticks_msec() / 1000.0) + 1.0) / 2.0)
				+ hue_range.x,
				0.85, 0.7);
	
	if event.is_action_pressed(&"toggle_vision"):
		viewport.render_target_clear_mode = SubViewport.ClearMode.CLEAR_MODE_ONCE;
		env.environment.background_mode += 1;
		if env.environment.background_mode > 5:
			env.environment.background_mode = Environment.BG_KEEP;
		
		env.environment.background_color = Color.BLACK;
	
	if event.is_action_pressed(&"switch_mode"):
		mode += 1;
		if mode >= Mode.size():
			mode = 0;


func _process(_delta: float) -> void:
	
	if playing:
		_update_generator();


func _update_generator() -> void:
	
	if !playback:
		return;
	
	var delta : float = frequency / sample_hz;
	delta *= phase_modifier;
	
	var available_frames : int = playback.get_frames_available();
	while available_frames > 0:
		
		match mode:
			Mode.Sine:
				playback.push_frame(Vector2.ONE * sin(phase * TAU));
				phase = fmod(phase + delta, 1.0);
			
			Mode.Triangle:
				playback.push_frame(Vector2.ONE * absf(fmod(phase, 2.0) - 1.0));
				phase = fmod(phase + delta, 1.0);
			
			Mode.Sawtooth:
				playback.push_frame(Vector2.ONE * (fmod(phase, 2.0) - 1.0));
				phase = fmod(phase + delta, 1.0);
			
			Mode.Square:
				if fmod(phase, 1.0) < 0.5:
					playback.push_frame(Vector2.ONE);
				else:
					playback.push_frame(Vector2.ZERO);
				phase = fmod(phase + delta, 1.0);
			
		available_frames -= 1;
