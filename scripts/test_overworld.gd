extends Node2D

@onready var game_ui: Control = load("res://scenes/MVP/game_ui.tscn").instantiate()
@onready var game_camera: Camera2D = $Player/Camera2D
@export var start_in_menu: bool = true
var num_players: int
signal set_current_level_info()


func _ready() -> void:
	game_ui.position = game_camera.position + game_camera.offset + Vector2(-800, -450)
	game_ui.scale = Vector2(1.25, 1.25)
	game_ui.current_level_name = name
	game_ui.start_in_main_menu = start_in_menu
	game_camera.add_child(game_ui)
	emit_signal("set_current_level_info", game_ui.set_current_level_info())

func add_player(device: int) -> void:
	pass

func remove_player(device: int) -> void:
	pass
