extends FieldObject


# Components

@onready var Shape : CSGCylinder3D = $CSGCylinder3D;


# Functions

func SetTransparency(value : float) -> void:
	Shape.transparency = value;