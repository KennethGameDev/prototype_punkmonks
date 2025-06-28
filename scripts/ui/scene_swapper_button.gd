extends Button

@export var switch_to_scene: PackedScene
signal swap_scene(new_scene: PackedScene)

func _ready() -> void:
	button_up.connect(on_swapper_button_released)

func on_swapper_button_released() -> void:
	emit_signal("swap_scene", switch_to_scene)
