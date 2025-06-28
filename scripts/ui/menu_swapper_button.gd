extends Button

@export var switch_to_node: Node
@export var current_node: Node
signal swap_menu_request(menu_index: int, return_index: int)

func _ready() -> void:
	button_up.connect(on_swapper_button_released)

func on_swapper_button_released() -> void:
	emit_signal("swap_menu_request", switch_to_node.get_index(), current_node.get_index())
