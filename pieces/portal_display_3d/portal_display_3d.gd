@tool
extends ArtDisplay3D
class_name PortalDisplay3D

# Properties

@export var TransparentBackground : bool = false :
	set(value):
		TransparentBackground = value;
		
		if(is_node_ready()):
			DisplayWindow.transparent_bg = value;


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
	
	var modifiedPos = PlayerInfo.playerPos * rotation_quat;
	camera.global_position = global_position - modifiedPos;


# Functions

func create_piece(scene : PackedScene) -> void:
	super(scene);
	
	if(displayedPiece != null):
		
		if(displayedPiece is Node3D):
			displayedPiece.global_basis = global_basis;
		
		var possibleCamera = displayedPiece.get_node("Camera3D");
		if(possibleCamera != null):
			camera = possibleCamera;
			
