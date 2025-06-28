extends Button

signal swap_menu_to_previous()

func _ready() -> void:
	button_up.connect(on_swapper_button_released)

func on_swapper_button_released() -> void:
	emit_signal("swap_menu_to_previous")
