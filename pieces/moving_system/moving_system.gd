extends Node2D

# Properties

@export var FrameTime : float = 0.1;
@export var LineColor : Color;
@export var LineWidth : float;
@export var LineLengthAmp : float;


# Data

var genCode : Dictionary = {
	"x": "o",
	"o": "jxol-",
	"l": "x",
	"j": "-",
}

var genString : String = "x";
var frameTimer : Timer;


# Processes

func _ready() -> void:
	
	frameTimer = Timer.new();
	frameTimer.wait_time = FrameTime;
	frameTimer.one_shot = true;
	add_child(frameTimer);
	
	frameTimer.timeout.connect(_new_frame);
	frameTimer.start();



func _new_frame() -> void:
	
	var newString : String = "";
	var i : int = 0;
	var length : int = genString.length();
	
	
	if(length > 20000):
		newString = "x";
	else:
		while(i < length):
			
			var char : String = genString[i];
			if(char == "-"):
				i += 3;
				continue;
			
			newString += genCode[char];
			
			i += 1;
	
	
	genString = newString;
	
	queue_redraw();
	frameTimer.start();


func _draw() -> void:
	
	var basePoint = Vector2.ZERO;
	var nextPoint = Vector2.ZERO;
	
	var i : int = 0;
	var length : int = genString.length();
	while(i < length):
		
		match(genString[i]):
			"x":
				nextPoint += Vector2.UP;
			"o":
				nextPoint = nextPoint.rotated(0.1);
			"l":
				nextPoint *= -1.0;
			"j":
				basePoint += (nextPoint - basePoint).normalized();
			"-":
				LineColor.h += 0.02;
		
		draw_line(basePoint * LineLengthAmp, nextPoint * LineLengthAmp, LineColor, LineWidth, true);
		
		basePoint = nextPoint;
		
		i += 1;
	
	
	pass;
