extends Button

signal quit_game_request()

func _ready() -> void:
	button_up.connect(on_quit_game_button_released)

func on_quit_game_button_released() -> void:
	emit_signal("quit_game_request")
