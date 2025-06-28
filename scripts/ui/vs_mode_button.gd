extends Button

var switch_to_scene: PackedScene = preload("res://scenes/MVP/stage.tscn")
signal start_vs_mode_request(vs_mode_scene: PackedScene)

func _ready() -> void:
	button_up.connect(on_vs_mode_button_released)

func on_vs_mode_button_released() -> void:
	emit_signal("start_vs_mode_request", switch_to_scene)
