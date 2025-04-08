extends Node3D
class_name EnemySpawner3D
# Created by: simplex
# Last Edited: simplex, 4/5/2025

# Properties
## Node references
@export_subgroup("Nodes")
@export var Animator : AnimationPlayer;
@export var ParticleEmitterA : GPUParticles3D;
@export var ParticleEmitterB : GPUParticles3D;
@export var ParticleEmitterC : GPUParticles3D;


# Data

# Processes

func _ready() -> void:
	ParticleEmitterA.emitting = false;
	ParticleEmitterB.emitting = false;
	ParticleEmitterC.emitting = false;
	
	Animator.play(&"spawn");


func _end_animation() -> void:
	Animator.play(&"spawn");
