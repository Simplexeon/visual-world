@tool
extends GPUParticlesAttractorSphere3D

# Parameters

@export var MovementNoise : NoiseTexture3D;
@export var HalfBounds : Vector3;
@export var Strength : Vector2;
@export var MoveTime : float;


# Data

var targetPosition : Vector3 = Vector3.ZERO;
var movement : Vector3 = Vector3.ZERO;


# Components

@onready var LocationTimer : Timer = $NewLocationTimer;


# Processes

func _ready() -> void:
	targetPosition = getNewTarget();
	movement = getMovementToTarget(targetPosition);
	LocationTimer.wait_time = MoveTime;
	LocationTimer.timeout.connect(_on_LocationTimerTimeout);
	LocationTimer.start();
	

func _physics_process(delta: float) -> void:
	
	position += movement * delta;
	
	# Sample Noise
	var noise_value : Array[Image] = MovementNoise.get_data();
	if(noise_value != null and noise_value.size() >= MovementNoise.depth):
		var z_pos : int = int(floorf(lerpf(0, MovementNoise.depth, (position.z + HalfBounds.z) / (HalfBounds.z * 2))));
		var x_pos : int = int(floorf(lerpf(0, MovementNoise.depth, (position.x + HalfBounds.x) / (HalfBounds.x * 2))));
		var y_pos : int = int(floorf(lerpf(0, MovementNoise.depth, (position.y + HalfBounds.y) / (HalfBounds.y * 2))));
		z_pos = clampi(z_pos, 0, MovementNoise.depth - 1);
		x_pos = clampi(x_pos, 0, MovementNoise.depth - 1);
		y_pos = clampi(y_pos, 0, MovementNoise.depth - 1);
		var value : Color = noise_value[z_pos].get_pixel(x_pos, y_pos);
		strength = lerpf(Strength.x, Strength.y, value.v);

func _on_LocationTimerTimeout() -> void:
	targetPosition = getNewTarget();
	movement = getMovementToTarget(targetPosition);
	LocationTimer.start();



# Functions

func getMovementToTarget(target : Vector3) -> Vector3:
	var result : Vector3 = target - position;
	var speed = result.length() / MoveTime;
	
	return result.normalized() * speed;

func getNewTarget() -> Vector3:
	return Vector3(randf_range(HalfBounds.x * -1, HalfBounds.x), 
		randf_range(HalfBounds.y * -1, HalfBounds.y), randf_range(HalfBounds.z * -1, HalfBounds.z));
