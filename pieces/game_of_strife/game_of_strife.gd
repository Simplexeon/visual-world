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
		
		var j : int = 0;
		while(j < GridSize.y):
			
			grid[i][j] = randi_range(0, 1);
			j += 1;
		
		i += 1;
	
	# Save drawing info
	gridDimensions = Vector2(GridSize) * TileSize;
	gridStartPos = gridDimensions * -0.5;
	tileDimensions = Vector2(TileSize, TileSize);
	colorCount = Colors.size();
	
	timer.start();
	

func _cycle() -> void:
	
	# Setup the grid.
	var new_grid : Array[Array] = [];
	new_grid.resize(GridSize.x);
	var i : int = 0;
	while(i < GridSize.x):
		
		new_grid[i] = [];
		new_grid[i].resize(GridSize.y);
		new_grid[i].fill(StartNumber);
		
		i += 1;
	
	i = 0;
	while(i < GridSize.y):
		var j : int = 0;
		while(j < GridSize.x):
			
			var neighbors : int = 0;
			
			if(j + 1 < GridSize.x):
				#neighbors += int(grid[j + 1][i] >= 1);
				neighbors += grid[j + 1][i];
			
			if(j - 1 >= 0):
				#neighbors += int(grid[j - 1][i] >= 1);
				neighbors += grid[j - 1][i];
			
			if(i + 1 < GridSize.y):
				#neighbors += int(grid[j][i + 1] >= 1);
				neighbors += grid[j][i + 1];
			
			if(i - 1 >= 0):
				#neighbors += int(grid[j][i - 1] >= 1);
				neighbors += grid[j][i - 1];
			
			if(neighbors <= 0):
				new_grid[j][i] = 1;
				neighbors = 2;
			
			if(neighbors >= 3):
				new_grid[j][i] = grid[j][i] + 1;
			else:
				new_grid[j][i] = grid[j][i];
			
			
			if(grid[j][i] >= 1):
				if(neighbors < 2):
					new_grid[j][i] = 0;
				elif(neighbors > 5):
					new_grid[j][i] -= 3;
					
			if(new_grid[j][i] < 0):
				new_grid[j][i] = 0;
			
			if(new_grid[j][i] >= colorCount):
				new_grid[j][i] = 0;
			
			
			j += 1;
		i += 1;
	
	grid = new_grid;
	
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
	
