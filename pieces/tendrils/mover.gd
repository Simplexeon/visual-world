extends Node3D

# Properties

@export var Dimensions : Vector3;
@export var Speed : float;


# Data

var target_pos : Vector3;


# Processes

func _ready() -> void:
	target_pos = get_random_pos();
	

func _physics_process(delta: float) -> void:
	
	var move_normal : Vector3 = (target_pos - position).normalized();
	var move_vector : Vector3 = move_normal * Speed * delta;
	
	if(move_normal.dot((target_pos - (position + move_vector)).normalized()) < 0.9):
		target_pos = get_random_pos();
	
	position += move_vector;



# Functions

func get_random_pos() -> Vector3:
	return Vector3(randf_range(-Dimensions.x, Dimensions.x), randf_range(-Dimensions.y, Dimensions.y), 
		randf_range(-Dimensions.z, Dimensions.z),);