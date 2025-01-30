extends Node3D



# Properties

@export var FieldBounds : Vector3 = Vector3(20.0, 20.0, 20.0);
@export var GridCount : int = 50;
@export var DrawObject : PackedScene;
@export var RotationNoise : NoiseTexture3D;


# Data

var grid : Array[Array] = [];


class Point:
	
	var vector : Vector3;
	
	var node : FieldObject;


# Components

@onready var Generation : Node3D = $Generation;


# Processes

func _ready() -> void:
	
	var i : int = 0;
	while(i < GridCount):
		
		var verticalRow : Array[Array] = [];
		
		var j : int = 0;
		while(j < GridCount):
			
			var depthRow : Array[Point] = [];
			
			# Populate the field
			var k : int = 0;
			while(k < GridCount):
				depthRow.append(CreateGridPoint(Vector3(i, j, k)));
				k += 1;
			
			verticalRow.append(depthRow);
			
			j += 1;
		
		grid.append(verticalRow);
		
		i += 1;
	
	SetupField();





# Functions

func CreateGridPoint(_position : Vector3) -> Point:
	
	var result : Point = Point.new();
	
	var xBounds : Vector2 = Vector2(FieldBounds.x * -1, FieldBounds.x);
	var yBounds : Vector2 = Vector2(FieldBounds.y * -1, FieldBounds.y);
	var zBounds : Vector2 = Vector2(FieldBounds.z * -1, FieldBounds.z);
	
	var rot : float = Utils.SampleNoise3D(Vector3(Utils.MapFloat(xBounds, Vector2.UP, _position.x), 
		Utils.MapFloat(yBounds, Vector2.UP, _position.y),
		Utils.MapFloat(zBounds, Vector2.UP, _position.z)), RotationNoise).v;
	
	var lookVector : Vector3 = Vector3.UP;
	rot = Utils.MapFloat(Vector2.UP, Vector2(0, 2 * PI), rot);
	lookVector = lookVector.rotated(Vector3.RIGHT, rot);
	result.vector = lookVector.rotated(Vector3.FORWARD, rot);
	
	return result;
	


func SetupField() -> void:
	
	var genChildren : Array[Node] = Generation.get_children();
	for child in genChildren:
		Generation.remove_child(child);
	
	var halfBounds : Vector3 = FieldBounds * 0.5;
	var drawPos : Vector3 = global_position - halfBounds;
	var startPos : Vector3 = drawPos;
	var unitLengths : Vector3 = FieldBounds / float(GridCount);
	
	var i : int = 0;
	while(i < GridCount):
		var j : int = 0;
		while(j < GridCount):
			var k : int = 0;
			while(k < GridCount):
				
				var point : Point = grid[i][j][k];
				
				var inst : Node3D = DrawObject.instantiate();
				Generation.add_child(inst);
				inst.global_position = drawPos;
				
				inst.look_at_from_position(inst.global_position, inst.global_position + point.vector);
				
				point.node = inst;
				
				drawPos.z += unitLengths.z;
				
				k += 1;
			
			drawPos.z = startPos.z;
			drawPos.y += unitLengths.y;
			j += 1;
		
		drawPos.y = startPos.y;
		drawPos.x += unitLengths.x;
		i += 1;
	
