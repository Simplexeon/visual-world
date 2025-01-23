@tool
extends Node


var playerPos : Vector3 = Vector3.ZERO;
var playerCameraRot : Quaternion = Quaternion.from_euler(Vector3.ZERO);


func _physics_process(delta: float) -> void:
	if(Engine.is_editor_hint()):
		var camera : Camera3D = EditorInterface.get_editor_viewport_3d(0).get_camera_3d();
		playerPos = camera.global_position;
		playerCameraRot = camera.global_basis.get_rotation_quaternion();
