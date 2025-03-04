extends Node2D

# Properties

@export var StartNumber : int = 0;
@export var TileSize : float;
@export var GridSize : Vector2i;
@export var CycleTime : float = 0.5;
@export var Colors : Array[Color];


# Data

var grid : Array[Array];
var timer : Timer;
var gridStartPos : Vector2 = Vector2.ZERO;
var gridDimensions : Vector2 = Vector2.ZERO;
var tileDimensions : Vector2 = Vector2.ZERO;
var colorCount : int = 0;


# Processes

func _ready() -> void:
	
	# Start the cycle timer
	timer = Timer.new();
	timer.wait_time = CycleTime;
	timer.timeout.connect(_cycle);
	add_child(timer);
	
	
	# Setup the grid.
	grid = [];
	grid.resize(GridSize.x);
	var i : int = 0;
	while(i < GridSize.x):
		
		grid[i] = [];
		grid[i].resize(GridSize.y);
		grid[i].fill(StartNumber);
		
		i += 1;
	
	# Save drawing info
	gridDimensions = Vector2(GridSize) * TileSize;
	gridStartPos = gridDimensions * -0.5;
	tileDimensions = Vector2(TileSize, TileSize);
	colorCount = Colors.size();
	
	timer.start();
	

func _cycle() -> void:
	
	queue_redraw();

func _draw() -> void:
	
	var pos : Vector2 = gridStartPos;
	var i : int = 0;
	while(i < GridSize.y):
		
		var j : int = 0;
		while(j < GridSize.x):
			
			var valueCapped : int = clampi(grid[j][i], 0, colorCount - 1);
			
			draw_rect(Rect2(pos, tileDimensions), Colors[valueCapped]);
			
			pos.x += TileSize;
			j += 1;
		
		pos.x -= gridDimensions.x;
		pos.y += TileSize;
		i += 1;
	