class_name CameraControllerFight
extends Node2D

@export var fighter1: PlayerFighter
@export var fighter2: NPCFighter

func _physics_process(delta: float) -> void:
	position.x = (fighter1.position.x + fighter2.position.x) / 2
