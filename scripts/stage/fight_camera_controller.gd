class_name CameraControllerFight
extends Node2D

@export var stage_info: StageInfo
var fighter1: PlayerFighter
var fighter2: PlayerFighter

func _ready() -> void:
	fighter1 = stage_info.player1
	fighter2 = stage_info.player2

func _physics_process(delta: float) -> void:
	position.x = (fighter1.position.x + fighter2.position.x) / 2
