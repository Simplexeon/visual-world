extends Node2D

# Parameters

@export var Enabled : bool = true;
@export var FrameRate : float = 60.0;
@export var PointCount : int = 5;
@export var PointColor : Color = Color.WHITE;
@export var PointRadius : float = 4.0;
@export var PointSpeed : float = 10.0;
@export var SpreadRadius : float = 150.0;
@export var NeighborRange : float = 25.0;
@export var LineWidth : float = 2.0;
@export var LineColor : Color = Color.CYAN;
@export var RandomMovementStrength : float = 8.0;


# Data

class Point:
	
	var pos : Vector2;
	var neighbors : Array[Point];


var point_list : Array[Point];


var frame_timer : Timer;
var frame_length : float;


# Processes

func _ready() -> void:
	
	point_list = scatter_points(PointCount, SpreadRadius);
	
	
	frame_timer = Timer.new();
	frame_length = 1.0 / FrameRate
	frame_timer.wait_time = frame_length;
	frame_timer.autostart = false;
	frame_timer.timeout.connect(_process_frame);
	add_child(frame_timer);
	frame_timer.start();


func _process_frame() -> void:
	
	for point in point_list:
		var move_dir : Vector2 = Vector2.ZERO;
		
		var avg_point : Vector2 = Vector2.ZERO;
		for neighbor in point.neighbors:
			move_dir += neighbor.pos - point.pos;
			avg_point += neighbor.pos;
		
		avg_point /= float(point.neighbors.size());
		
		move_dir -= avg_point - point.pos;
		
		var random_dir : Vector2 = Vector2.UP.rotated(randf_range(0.0, 2.0 * PI)) * RandomMovementStrength;
		move_dir += ((move_dir * -1.0) + random_dir) - move_dir;
		
		move_dir = move_dir.normalized();
		
		point.pos += move_dir * frame_length * PointSpeed;
	
	queue_redraw();


func _draw() -> void:
	
	for point in point_list:
		for neighbor in point.neighbors:
			draw_line(point.pos, neighbor.pos, LineColor, LineWidth, true);
		
		draw_circle(point.pos, PointRadius, PointColor);


# Functions


func scatter_points(point_count : int, spread_radius : float) -> Array[Point]:
	var result : Array[Point] = [];
	result.resize(point_count);
	
	var i : int = 0;
	while(i < point_count):
		
		var point : Point = Point.new();
		point.pos = (Vector2(1.0, 0.0) * randf_range(0.0, 
			spread_radius)).rotated(randf_range(0.0, 2.0 * PI));
		
		result[i] = point;
		
		i += 1;
	
	
	# Assign neighbors
	var squared_range : float = NeighborRange ** 2.0;
	for point in result:
		for other_point in result:
			if(!point.neighbors.has(other_point)):
				if(point.pos.distance_squared_to(other_point.pos) < squared_range):
					point.neighbors.append(other_point);
					other_point.neighbors.append(point);
	
	return result;
