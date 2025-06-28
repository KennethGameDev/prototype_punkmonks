extends Button

var switch_to_scene: PackedScene = preload("res://scenes/test/maps/test_overworld.tscn")
signal start_singleplayer_request(singleplayer_scene: PackedScene)

func _ready() -> void:
	button_up.connect(on_singleplayer_button_released)

func on_singleplayer_button_released() -> void:
	emit_signal("start_singleplayer_request", switch_to_scene)
