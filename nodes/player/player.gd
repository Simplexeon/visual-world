extends CharacterBody3D
class_name Player3D

# Parameters

@export var Speed : float = 5.0;

@export var MouseSens : float = 0.3;


# Components

@onready var Camera : Camera3D = $Camera3D;


# Processes

func _input(event: InputEvent) -> void:
	
	if(event is InputEventMouseButton):
		if(event.button_index == 1 and event.pressed):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	
	if(event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		var motion : Vector2 = event.screen_relative;
		rotate_y(deg_to_rad(motion.x * MouseSens * -1));
		Camera.rotate_x(deg_to_rad(motion.y * MouseSens * -1));
		
	
	if(event.is_action_pressed("ui_cancel")):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	


func _physics_process(delta: float) -> void:
	# INPUT FROM DEFAULT CHARACTER SCRIPT
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta;
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir : Vector2 = Input.get_vector("left", "right", "forward", "backward");
	var direction : Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();
	
	if direction:
		velocity.x = direction.x * Speed;
		velocity.z = direction.z * Speed;
	else:
		velocity.x = move_toward(velocity.x, 0, Speed);
		velocity.z = move_toward(velocity.z, 0, Speed);
	
	move_and_slide();
	
	PlayerInfo.playerPos = Camera.global_position;
