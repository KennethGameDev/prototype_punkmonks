class_name Stage
extends Node2D

@onready var player_1: PlayerFighter = preload("res://scenes/MVP/fighter.tscn").instantiate()
@onready var player_2: PlayerFighter = preload("res://scenes/MVP/fighter.tscn").instantiate()
@onready var game_ui: Control = load("res://scenes/MVP/game_ui.tscn").instantiate()
@onready var game_camera: Camera2D = $CameraPos/Camera2D
@export var start_in_menu: bool = true
signal set_current_level_info(level_name: String, menu_start: bool)
signal UNUSED_player_1_setup(player_id: int)
signal UNUSED_player_2_setup(player_id: int)
signal set_players(player_1: PlayerFighter, player_2: PlayerFighter)

func _ready() -> void:
	# Add UI to scene
	game_ui.position = Vector2(-640, -360)
	game_camera.add_child(game_ui)
	ready.connect(on_ui_added)
	
	# Add Player 1 to scene
	player_1.position = Vector2(-320, 100)
	player_1.name = "Player 1"
	player_1.player_id = 0
	player_1.opponent = player_2
	add_child(player_1)
	move_child(player_1, 3)
	ready.connect(on_player_1_added)
	
	# Add Player 2 to scene
	player_2.position = Vector2(320, 100)
	player_2.name = "Player 2"
	player_2.player_id = 1
	player_2.opponent = player_1
	add_child(player_2)
	move_child(player_2, 4)
	ready.connect(on_player_2_added)
	
	# Set up signal to send both player's positions
	ready.connect(on_get_players)
	
	get_tree().paused = start_in_menu

func on_ui_added() -> void:
	emit_signal("set_current_level_info", game_ui.set_current_level_info(name, start_in_menu))

func on_player_1_added() -> void:
	emit_signal("UNUSED_player_1_setup", 0)

func on_player_2_added() -> void:
	emit_signal("UNUSED_player_2_setup", 1)

func on_get_players() -> void:
	emit_signal("set_players", player_1, player_2)
