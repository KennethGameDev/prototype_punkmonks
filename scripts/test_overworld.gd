extends Node

@onready var game_ui: Control = load("res://scenes/MVP/game_ui.tscn").instantiate()
@onready var game_camera: Camera2D = $Player/Camera2D
@export var start_in_menu: bool = true
signal set_current_level_info(level_name: String, menu_start: bool)


func _ready() -> void:
	game_ui.position = game_camera.position + game_camera.offset + Vector2(-800, -450)
	game_ui.scale = Vector2(1.25, 1.25)
	game_camera.add_child(game_ui)
	ready.connect(on_ui_added)
	get_tree().paused = start_in_menu

func on_ui_added() -> void:
	emit_signal("set_current_level_info", game_ui.set_current_level_info(name, start_in_menu))
