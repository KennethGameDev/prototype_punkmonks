extends Node2D

@onready var game_ui: Control = load("res://scenes/MVP/game_ui.tscn").instantiate()
@onready var game_camera: Camera2D = $Player/Camera2D
@export var DEBUGGING: bool = false
@export var start_in_menu: bool = true
var num_players: int
signal set_current_level_info


func _ready() -> void:
	# Inherit parent.DEBUGGING if this scene is not the entry point.
	var parent_node: Node = get_parent()
	if parent_node.name != "root":
		DEBUGGING = parent_node.DEBUGGING
	
	if DEBUGGING:
		print("Parent of '{n}' is '{p}'".format({
			"n": name,
			"p": get_parent().name
		}))
	
	game_ui.scale = game_ui.scale / game_camera.zoom
	game_ui.position = Vector2(game_camera.position.x - game_camera.get_viewport_rect().size.x / game_camera.zoom.x / 2, game_camera.position.y - game_camera.get_viewport_rect().size.y / game_camera.zoom.y / 2)
	game_ui.current_level_name = name
	game_ui.start_in_main_menu = start_in_menu
	set_current_level_info.connect(game_ui.on_stage_set_current_level_info)
	emit_signal("set_current_level_info")
	game_camera.add_child(game_ui)

func add_player(device: int) -> void:
	pass

func remove_player(device: int) -> void:
	pass
