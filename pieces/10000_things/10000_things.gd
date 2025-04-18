@tool
extends Node2D

# Parameters

@export var DuplicationThing : PackedScene;

@export_subgroup("Item Manipulation")
@export var Bounds : Vector2 = Vector2(500, 500);
@export var MaxSize : float = 2.5;

@export_subgroup("Creation Timing")
@export var Timed : bool = false;
@export var CreationLength : float = 20.0;
@export var WaitLength : float = 5.0;


# Data

var half_bounds : Vector2;
var count : int;


# Components

@onready var GenerationTimer : Timer = $GenerationTimer;
@onready var Things : Node2D = $GeneratedThings;


# Processes

func _ready() -> void:
	
	randomize();
	
	half_bounds = Bounds * .5;
	reset();
	
	if(!Timed):
		var i : int = 0;
		while(i < 10000):
			create_thing();
			i += 1;
	else:
		
		GenerationTimer.wait_time = CreationLength / 10000;
		GenerationTimer.start();
		
		pass;


# Functions

func reset() -> void:
	count = 0;
	
	var children : Array[Node] = Things.get_children();
	for item in children:
		item.queue_free();

func create_thing() -> void:
	
	if(count >= 10000):
		reset();
	
	var thing : Node = DuplicationThing.instantiate();
	
	if(thing is Node2D):
		thing.global_position = Vector2(randf_range(half_bounds.x * -1, half_bounds.x), randf_range(half_bounds.y * -1, half_bounds.y));
		
		thing.rotation_degrees = randf_range(0, 360);
		thing.scale = Vector2(randf_range(0.01, MaxSize), randf_range(0.01, MaxSize));
		thing.skew = randf_range(-90, 90);
		
		thing.modulate = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), randf_range(0.5, 1));
	
	Things.add_child(thing);
	
	count += 1;
