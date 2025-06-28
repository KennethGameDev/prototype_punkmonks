extends Button

var game_mode_1: PackedScene = preload("res://scenes/test/maps/test_overworld.tscn")
var game_mode_2: PackedScene = preload("res://scenes/MVP/stage.tscn")
signal on_switch_game_mode(game_mode_1: PackedScene, game_mode_2: PackedScene)

func _ready() -> void:
	button_up.connect(on_switch_game_mode_button_released)
	game_mode_1.resource_name = "TestOverworld"
	game_mode_2.resource_name = "Stage"

func on_paused_game_pressed(current_level: String) -> void:
	if current_level == "TestOverworld":
		text = "VS Mode"
	
	if current_level == "Stage":
		text = "Single Player"

func on_switch_game_mode_button_released() -> void:
	emit_signal("on_switch_game_mode", game_mode_1, game_mode_2)
