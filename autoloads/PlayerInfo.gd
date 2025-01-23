@tool
extends Node


var playerPos : Vector3 = Vector3.ZERO;


func _physics_process(delta: float) -> void:
	if(Engine.is_editor_hint()):
		playerPos = EditorInterface.get_editor_viewport_3d(0).get_camera_3d().global_position;
