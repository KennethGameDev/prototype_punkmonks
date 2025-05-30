class_name CameraControllerFight
extends Node2D

@export var fighter1: PlayerFighter
@export var fighter2: PlayerFighter

func _physics_process(delta: float) -> void:
	position = fighter1.position + Vector2(766, 132)
