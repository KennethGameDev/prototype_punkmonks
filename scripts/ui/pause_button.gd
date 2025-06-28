extends Button

signal pause_game_request()

func _ready() -> void:
	button_up.connect(on_return_button_released)

func on_return_button_released() -> void:
	emit_signal("pause_game_request")
