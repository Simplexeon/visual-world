extends Camera3D

# Properties

@export var MoveDir : Vector3;
@export var Speed : float;


# Processes

func _ready() -> void:
	randomize();

func _physics_process(delta: float) -> void:
	position += MoveDir * Speed * delta;