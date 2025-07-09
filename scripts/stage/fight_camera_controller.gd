class_name CameraControllerFight
extends Node2D

var player_1_pos: float
var player_2_pos: float
var positions_aquired: bool = false

func _physics_process(delta: float) -> void:
	if positions_aquired:
		position.x = (player_1_pos + player_2_pos) / 2

func _on_stage_pass_player_positions_to_camera(player_1: PlayerFighter, player_2: PlayerFighter):
	player_1_pos = player_1.position.x
	player_2_pos = player_2.position.x
	positions_aquired = true
