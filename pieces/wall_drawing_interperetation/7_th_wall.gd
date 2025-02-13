@tool
extends Node2D

# Properties

@export var ReDraw : bool :
	set(value):
		if(is_node_ready()):
			queue_redraw();
@export var GridSize : Vector2;
@export var Area : Vector2;


# Processes

func _draw() -> void:
	
	var pos_delta_x : float = Area.x / GridSize.x;
	
	var i : int = 0;
	while(i < GridSize.x + 1):
		
		# Draw vertical lines
		var from : Vector2 = global_position - Area * 0.5;
		from += Vector2(i * pos_delta_x, 0);
		var to : Vector2 = from + Vector2(0, Area.y);
		
		draw_line(from, to, Color.BLACK, 5.0, true);
		
		i += 1;
	
	var pos_delta_y : float = Area.y / GridSize.y;
	
	i = 0;
	while(i < GridSize.y + 1):
		
		# Draw vertical lines
		var from : Vector2 = global_position - Area * 0.5;
		from += Vector2(0, i * pos_delta_y);
		var to : Vector2 = from + Vector2(Area.x, 0);
		
		draw_line(from, to, Color.BLACK, 5.0, true);
		
		i += 1;
	
	# Red Lines
	
	var from : Vector2 = global_position - Area * 0.5;
	from += Vector2(Area.x * 0.5, 0);
	draw_line(from, global_position + ((Vector2(randi_range(0, GridSize.x), randi_range(0, GridSize.y)) * pos_delta_x) - Area * 0.5), Color.RED, 6.0);
	from += Vector2(Area.x * 0.5, Area.y * 0.5);
	draw_line(from, global_position + ((Vector2(randi_range(0, GridSize.x), randi_range(0, GridSize.y)) * pos_delta_x) - Area * 0.5), Color.RED, 6.0);
	from += Vector2(Area.x * -0.5, Area.y * 0.5);
	draw_line(from, global_position + ((Vector2(randi_range(0, GridSize.x), randi_range(0, GridSize.y)) * pos_delta_x) - Area * 0.5), Color.RED, 6.0);
	from += Vector2(Area.x * -0.5, Area.y * -0.5);
	draw_line(from, global_position + ((Vector2(randi_range(0, GridSize.x), randi_range(0, GridSize.y)) * pos_delta_x) - Area * 0.5), Color.RED, 6.0);
	
	from += Vector2(0, Area.y * -0.5);
	draw_line(from, global_position + ((Vector2(randi_range(0, GridSize.x), randi_range(0, GridSize.y)) * pos_delta_x) - Area * 0.5), Color.BLUE, 4.75);
	from += Vector2(Area.x, 0);
	draw_line(from, global_position + ((Vector2(randi_range(0, GridSize.x), randi_range(0, GridSize.y)) * pos_delta_x) - Area * 0.5), Color.BLUE, 4.75);
	from += Vector2(0, Area.y);
	draw_line(from, global_position + ((Vector2(randi_range(0, GridSize.x), randi_range(0, GridSize.y)) * pos_delta_x) - Area * 0.5), Color.BLUE, 4.75);
	from += Vector2(-Area.x, 0);
	draw_line(from, global_position + ((Vector2(randi_range(0, GridSize.x), randi_range(0, GridSize.y)) * pos_delta_x) - Area * 0.5), Color.BLUE, 4.75);
	
	from += Vector2(Area.x * 0.5, Area.y * -0.5);
	draw_line(from, global_position + ((Vector2(randi_range(0, GridSize.x), randi_range(0, GridSize.y)) * pos_delta_x) - Area * 0.5), Color.YELLOW, 2.5);
	
	pass;
