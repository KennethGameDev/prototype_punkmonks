extends Node2D

@export var DEBUGGING: bool = false
@export var start_multiplayer: bool = false
# TODO: Update to instead load a level manager scene to better control input mapping contexts.
# I think this would allow for broader gameplay contexts, maybe
var singleplayer_world: PackedScene = preload("res://scenes/test/maps/test_overworld.tscn")
var vs_mode_world: PackedScene = preload("res://scenes/MVP/stage.tscn")
var connected_controllers: Array
var level: Node2D

func _ready():
	if DEBUGGING:
		print("Running {n}._ready()... connected joypads: {j}".format({
			"n": name,
			"j": Input.get_connected_joypads()
		}))
		print("Parent of '{n}' is '{p}' (Expect 'root')".format({
			"n": name,
			"p": get_parent().name
		}))
	
	if start_multiplayer:
		level = vs_mode_world.instantiate()
	else:
		level = singleplayer_world.instantiate()
	
	level.num_players = Input.get_connected_joypads().size()
	
	add_child(level)
	
	var _ret: int
	_ret = Input.connect("joy_connection_changed", _on_joy_connection_changed)
	if _ret != 0:
		print("Error {e} connecting 'Input' signal 'joy_connection_changed'.".format({"e": _ret}))

func _on_joy_connection_changed(device: int, connected: bool) -> void:
	if DEBUGGING:
		if connected:
			print("Connected to device {d}.".format({"d": device}))
		else:
			print("Disconnected device {d}.".format({"d": device}))
	
	if connected:
		# Update the number of players in the world
		level.num_players = Input.get_connected_joypads().size()
		
		# Add the player to the world. Use the device number as the
		# player index in the array of players
		level.add_player(device)
		print("Added player index {d} to the world.".format({"d": device}))
	else:
		# Do not change the number of players when a controller disconnects
		level.remove_player(device)
		print("Removed player index {d} from the world.".format({"d": device}))
