extends Node3D



# Properties

@export var FieldBounds : Vector3 = Vector3(20.0, 20.0, 20.0);
@export var GridCount : int = 50;
@export var DrawObject : PackedScene;
@export var RotationNoise : NoiseTexture3D;
@export var PlayerRadius : Curve;
@export var MaxPlayerRange : float;


# Data

var grid : Array[Array] = [];
var setup : bool = false;


class Point:
	
	var vector : Vector3;
	
	var node : FieldObject;


# Components

@onready var Generation : Node3D = $Generation;


# Processes

func _ready() -> void:
	
	await RotationNoise.changed;
	
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
	setup = true;


func _physics_process(delta: float) -> void:
	
	if(!setup):
		return;
	
	#var i : int = 0;
	#while(i < GridCount):
	#	var j : int = 0;
	#	while(j < GridCount):
	#		var k : int = 0;
	#		while(k < GridCount):
	#			
	#			UpdatePoint(delta, grid[i][j][k]);
	#			
	#			k += 1;
	#		
	#		j += 1;
	#	
	#	i += 1;

func UpdatePoint(_delta : float, point : Point) -> void:
	
	var playerVect : Vector3 = point.node.global_position - PlayerInfo.playerPos;
	var playerQuat : Quaternion = Quaternion(Vector3.UP, playerVect.normalized());
	var playerRange : float = min(Utils.MapFloat(Vector2(0, MaxPlayerRange), Vector2.DOWN, 
		playerVect.length()), 1.0);
	
	var rotQuat : Quaternion = Quaternion(Vector3.UP, point.vector).slerp(playerQuat, playerRange);
	
	point.node.look_at(point.node.global_position + (rotQuat * point.vector));
	
	pass;


# Functions

func CreateGridPoint(_position : Vector3) -> Point:
	
	var result : Point = Point.new();
	
	var noiseBounds : Vector2 = Vector2(0, GridCount);
	
	var rot : float = Utils.SampleNoise3D(Vector3(Utils.MapFloat(noiseBounds, Vector2.DOWN, _position.x), 
		Utils.MapFloat(noiseBounds, Vector2.DOWN, _position.y),
		Utils.MapFloat(noiseBounds, Vector2.DOWN, _position.z)), RotationNoise).v;
	
	var lookVector : Vector3 = Vector3.UP;
	rot = Utils.MapFloat(Vector2.DOWN, Vector2(0, 2 * PI), rot);
	lookVector = lookVector.rotated(Vector3.RIGHT, rot);
	lookVector = lookVector.rotated(Vector3.FORWARD, rot);
	
	var noiseQuat : Quaternion = Quaternion(Vector3.UP, lookVector);
	result.vector = Vector3.UP * noiseQuat;
	
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
				
				if(point.vector != Vector3.UP):
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
	
