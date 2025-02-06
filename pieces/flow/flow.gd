@tool
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
var rangeSquared : float;


class Point:
	
	var vector : Vector3;
	var weight : float;
	
	var visibility : float = 1.0 :
		set(value):
			visibility = value;
			if(node != null):
				node.SetTransparency(visibility);
	
	var node : FieldObject;
	


# Components

@onready var Generation : Node3D = $Generation;


# Processes

func _ready() -> void:
	
	#PlayerRadius.sample_baked(0.0);
	rangeSquared = pow(MaxPlayerRange, 2.0);
	
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


#func _physics_process(delta: float) -> void:
#	
#	if(!setup):
#		return;
#	
#	for x in grid:
#		for y in x:
#			for point in y:
#				UpdatePoint(delta, point);
#				
#
#func UpdatePoint(_delta : float, point : Point) -> void:
#	
#	var playerVect : Vector3 = point.node.global_position - PlayerInfo.playerPos;
#	var playerRange : float = min(remap(playerVect.length_squared(), 0, rangeSquared, 0, 1), 1.0);
#	
#	point.visibility = PlayerRadius.sample_baked(playerRange);


# Functions

func CreateGridPoint(_position : Vector3) -> Point:
	
	var result : Point = Point.new();
	
	var rot : float = Utils.SampleNoise3D(Vector3(remap(_position.x, 0, GridCount, 0, 1), 
		remap(_position.y, 0, GridCount, 0, 1),
		remap(_position.z, 0, GridCount, 0, 1)), RotationNoise).v;
	
	result.weight = rot;
	
	var lookVector : Vector3 = Vector3.UP;
	rot = remap(rot, 0, 1, 0, 2 * PI);
	lookVector = lookVector.rotated(Vector3.RIGHT, rot);
	lookVector = lookVector.rotated(Vector3.FORWARD, rot);
	
	var noiseQuat : Quaternion = Quaternion(Vector3.UP, lookVector);
	result.vector = Vector3.UP * noiseQuat;
	
	return result;
	


func SetupField() -> void:
	
	var genChildren : Array[Node] = Generation.get_children();
	for child in genChildren:
		child.queue_free();
	
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
				inst.UpdateData(point.weight, Vector3(i, j, k));
				
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
	
