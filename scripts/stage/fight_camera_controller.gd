class_name CameraControllerFight
extends Node2D

var player_1: PlayerFighter
var player_2: PlayerFighter

func _physics_process(delta: float) -> void:
	position.x = (player_1.position.x + player_2.position.x) / 2

func set_players(p1: PlayerFighter, p2: PlayerFighter) -> void:
	player_1 = p1
	player_2 = p2
