@tool
extends Sprite3D
class_name ArtDisplay3D

# Parameters

@export var ArtPiece : PackedScene :
	set(value):
		ArtPiece = value;
		
		if(!is_node_ready()):
			return;
		
		if(Engine.is_editor_hint()):
			create_piece(ArtPiece);
			

@export var Size : Vector2 = Vector2(512, 512) :
	set(value):
		Size = value;
		
		if(!is_node_ready()):
			return;
		
		DisplayWindow.size = Size;
		
		var half_size : Vector2 = Size * .5;
		
		var window_children : Array[Node] = DisplayWindow.get_children();
		for item in window_children:
			if(item is Node2D):
				item.global_position = half_size;
			

@export var ClearMode : SubViewport.ClearMode :
	set(value):
		ClearMode = value;
		if(is_node_ready()):
			DisplayWindow.render_target_clear_mode = value;

@export var UpdateMode : SubViewport.UpdateMode :
	set(value):
		UpdateMode = value;
		if(is_node_ready()):
			DisplayWindow.render_target_update_mode = value;


# Data

var displayedPiece : Node;



# Components

@onready var DisplayWindow : SubViewport = $DisplayWindow;


# Processes

func _ready() -> void:
	
	create_piece(ArtPiece);
	Size = Size;
	UpdateMode = UpdateMode;
	ClearMode = ClearMode;
	
	texture = DisplayWindow.get_texture();
	


# Functions

func create_piece(scene : PackedScene) -> void:
	var window_children : Array[Node] = DisplayWindow.get_children();
	for child in window_children:
		DisplayWindow.remove_child(child);
	
	if(ArtPiece != null):
		var node : Node = ArtPiece.instantiate();
		DisplayWindow.add_child(node);
		displayedPiece = node;
		
		if(node is Node2D):
			node.global_position = Size * .5;
		
