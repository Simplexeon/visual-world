@tool
extends Node3D


@export var Emitting : bool :
	set(value):
		Emitting = value;
		
		if(is_node_ready()):
			var children : Array[Node] = get_children();
			
			for child in children:
				if(child is GPUParticles3D):
					child.emitting = Emitting;