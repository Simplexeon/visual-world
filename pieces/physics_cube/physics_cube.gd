extends Node3D
class_name PhysicsCube3D


# Parameters

@export var rotation_speed : float;

@export_subgroup("Nodes")
@export var Cube : Node3D;
@export var Balls : Node3D;
@export var SpawnPositions : Node3D;

@export_subgroup("Files")
@export var BallFile : PackedScene;


# Processes

func _ready() -> void:
	
	
	reset();


func _physics_process(delta: float) -> void:
	
	if !Cube:
		return;
	
	if Input.is_action_just_pressed(&"reset"):
		reset();
	
	
	var input_dir : Vector2 = Input.get_vector(&"left", &"right", &"forward", &"backward");
	Cube.rotate_y(input_dir.x * rotation_speed * delta);
	Cube.rotate_x(input_dir.y * rotation_speed * delta);
	


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"reset"):
		reset();


# Functions

func reset() -> void:
	
	
	# Vibrate the connected controller to ensure it's there
	var connected_joypads : Array[int] = Input.get_connected_joypads();
	
	for joypad_id : int in connected_joypads:
		Input.start_joy_vibration(joypad_id, 0.9, 0.9, 0.4);
		
	
	# Remove old balls
	var balls : Array[Node] = Balls.get_children();
	for child in balls:
		child.queue_free();
	
	
	# Spawn new balls
	var spawn_positions : Array[Node3D] = [];
	spawn_positions.assign(SpawnPositions.get_children());
	
	for point : Node3D in spawn_positions:
		
		var ball : Node3D = BallFile.instantiate();
		Balls.add_child(ball);
		ball.global_position = point.global_position;