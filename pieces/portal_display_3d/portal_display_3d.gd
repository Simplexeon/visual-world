@tool
extends ArtDisplay3D
class_name PortalDisplay3D

# Properties

@export var TransparentBackground : bool = false :
	set(value):
		TransparentBackground = value;
		
		if(is_node_ready()):
			DisplayWindow.transparent_bg = value;

@export var MovementScaling : float = 1.0;

# Data

var camera : Camera3D;
var rotation_quat : Quaternion;


# Processes

func _ready() -> void:
	super();
	
	DisplayWindow.transparent_bg = TransparentBackground;
	rotation_quat = global_basis.get_rotation_quaternion();
	

func _physics_process(delta: float) -> void:
	if(camera == null):
		return;
	
	var moveAmount : Vector3 = (PlayerInfo.playerPos - global_position) * MovementScaling;
	camera.position = (moveAmount).project(Vector3.RIGHT);
	
	var camera_target_aim : Vector3 = (global_position - PlayerInfo.playerPos).normalized();
	camera_target_aim.y = camera.global_position.y;
	camera_target_aim.x *= -1;
	
	camera.quaternion = Basis.looking_at(camera_target_aim, Vector3.UP, true).get_rotation_quaternion();


# Functions

func create_piece(scene : PackedScene) -> void:
	super(scene);
	
	if(displayedPiece != null):
		
		if(displayedPiece is Node3D):
			displayedPiece.global_basis = global_basis.rotated(Vector3.UP, PI);
		
		var possibleCamera = displayedPiece.get_node("Camera3D");
		if(possibleCamera != null):
			camera = possibleCamera;
			
