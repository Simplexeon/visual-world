extends FieldObject

# Components

@onready var CircleMesh : MeshInstance3D = $MeshInstance3D;
var TrigShader : ShaderMaterial;


# Processes

func _ready() -> void:
	
	TrigShader = CircleMesh.mesh.material;
	

# Functions

func UpdateData(weight : float, pos : Vector3) -> void:
	
	TrigShader.set_shader_parameter(&"weight", weight);
	TrigShader.set_shader_parameter(&"position", pos);