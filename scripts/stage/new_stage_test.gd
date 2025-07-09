extends Node2D

@onready var fighter: PackedScene = preload("res://scenes/MVP/fighter.tscn")
#@onready var fighter_2: NewPlayerFighter = preload("res://scenes/MVP/new_fighter_test.tscn").instantiate()
@onready var game_ui: Control = load("res://scenes/MVP/game_ui.tscn").instantiate()
@export var DEBUGGING: bool = false
@export var start_in_menu: bool = true
@export var keyboard_allowed: bool = false
var num_players: int
var players: Array[PlayerFighter] = []
var input_maps: Array[Dictionary] = []
#signal set_players(player_1: NewPlayerFighter, player_2: NewPlayerFighter)
signal set_current_level_info
signal controller_connected
signal controller_disconnected
signal controller_reconnected

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
	
	# Add UI to scene
	game_ui.position = Vector2(-640, -360 - 146.835)
	game_ui.current_level_name = name
	game_ui.start_in_main_menu = start_in_menu
	emit_signal("set_current_level_info", game_ui.set_current_level_info())
	add_child(game_ui)
	#ready.connect(on_ui_added)
	
	# Add Player 1 to scene
	#fighter_1.opponent = fighter_2
	#ready.connect(on_player_1_added)
	
	# Add Player 2 to scene
	#fighter_2.position = Vector2(320, 100)
	#fighter_2.name = "Player 2"
	#fighter_2.player_id = 1
	#fighter_2.opponent = fighter_1
	#add_child(fighter_2)
	#move_child(fighter_2, 4)
	#ready.connect(on_player_2_added)
	
	# Set up signal to send both player's positions
	#ready.connect(on_get_players)
	
	get_tree().paused = start_in_menu

func remove_player(player_index: int) -> void:
	emit_signal("controller_disconnected", game_ui.on_controller_disconnected(player_index))

func add_player(player_index: int) -> void:
	# Add a player to the game.
	# 'player_index' is the player's index in the array 'players'.
	# It is also the player's joypad device number.
	
	# First handle the edge case:
	# If a player disconnects and reconnects, the Level already knows
	# about them and should just "revive" them.
	# To do so, check if the player is "new".
	# They're "new" if player_index == num of players so far.
	# If player_index < num of players so far, this is an "old" player.
	if player_index < players.size():
		emit_signal("controller_reconnected", game_ui.on_controller_reconnected())
		return
	
	players.append(fighter.instantiate())
	
	var player = players[-1]
	
	if player_index == 0:
		player.position = Vector2(-320, 100)
	elif player_index == 1:
		player.position = Vector2(320, 100)
	player.name = "Player {n}".format({"n": player_index + 1})
	player.player_id = player_index
	
	if DEBUGGING:
		print(players[player_index].name)
	
	input_maps.append({
		"f_move_left{n}".format({"n": player_index}): Vector2.LEFT,
		"f_move_right{n}".format({"n": player_index}): Vector2.RIGHT,
		"f_jump{n}".format({"n": player_index}): Vector2.UP,
		"f_crouch{n}".format({"n": player_index}): Vector2.DOWN,
		"f_light_attack{n}".format({"n": player_index}): false,
		"f_heavy_attack{n}".format({"n": player_index}): false,
		"f_special_attack{n}".format({"n": player_index}): false,
		"f_use_item{n}".format({"n": player_index}): false,
		"f_block{n}".format({"n": player_index}): false,
		"f_grab{n}".format({"n": player_index}): false
	})
	
	player.input_map = input_maps[player_index]
	
	if !keyboard_allowed:
		# Use controllers only
		#region Setup controller input actions and events
		#region Declare input action and event variables
		var move_left_action: String
		var move_left_action_event: InputEventJoypadButton
		
		var move_right_action: String
		var move_right_action_event: InputEventJoypadButton
		
		var jump_action: String
		var jump_action_event: InputEventJoypadButton
		
		var crouch_action: String
		var crouch_action_event: InputEventJoypadButton
		
		#var light_attack_action: String
		#var light_attack_action_event: InputEventJoypadButton
		#
		#var heavy_attack_action: String
		#var heavy_attack_action_event: InputEventJoypadButton
		#
		#var special_attack_action: String
		#var special_attack_action_event: InputEventJoypadButton
		#
		#var use_item_action: String
		#var use_item_action_event: InputEventJoypadButton
		#
		#var block_action: String
		#var block_action_event: InputEventJoypadButton
		#
		#var grab_action: String
		#var grab_action_event: InputEventJoypadButton
		#endregion
		#region Set the above actions and events and add them to the input map
		move_left_action = "f_move_left{n}".format({"n": player_index})
		InputMap.add_action(move_left_action)
		move_left_action_event = InputEventJoypadButton.new()
		move_left_action_event.device = player_index
		move_left_action_event.button_index = JOY_BUTTON_DPAD_LEFT
		InputMap.action_add_event(move_left_action, move_left_action_event)
		
		move_right_action = "f_move_right{n}".format({"n": player_index})
		InputMap.add_action(move_right_action)
		move_right_action_event = InputEventJoypadButton.new()
		move_right_action_event.device = player_index
		move_right_action_event.button_index = JOY_BUTTON_DPAD_RIGHT
		InputMap.action_add_event(move_right_action, move_right_action_event)
		
		jump_action = "f_jump{n}".format({"n": player_index})
		InputMap.add_action(jump_action)
		jump_action_event = InputEventJoypadButton.new()
		jump_action_event.device = player_index
		jump_action_event.button_index = JOY_BUTTON_DPAD_UP
		InputMap.action_add_event(jump_action, jump_action_event)
		
		crouch_action = "f_crouch{n}".format({"n": player_index})
		InputMap.add_action(crouch_action)
		crouch_action_event = InputEventJoypadButton.new()
		crouch_action_event.device = player_index
		crouch_action_event.button_index = JOY_BUTTON_DPAD_DOWN
		InputMap.action_add_event(crouch_action, crouch_action_event)
		
		#light_attack_action = "f_light_attack{n}".format({"n": player_index})
		#InputMap.add_action(light_attack_action)
		#light_attack_action_event = InputEventJoypadButton.new()
		#light_attack_action_event.device = player_index
		#light_attack_action_event.button_index = JOY_BUTTON_X
		#InputMap.action_add_event(light_attack_action, light_attack_action_event)
		#
		#heavy_attack_action = "f_heavy_attack{n}".format({"n": player_index})
		#InputMap.add_action(heavy_attack_action)
		#heavy_attack_action_event = InputEventJoypadButton.new()
		#heavy_attack_action_event.device = player_index
		#heavy_attack_action_event.button_index = JOY_BUTTON_A
		#InputMap.action_add_event(heavy_attack_action, heavy_attack_action_event)
		#
		#special_attack_action = "f_special_attack{n}".format({"n": player_index})
		#InputMap.add_action(special_attack_action)
		#special_attack_action_event = InputEventJoypadButton.new()
		#special_attack_action_event.device = player_index
		#special_attack_action_event.button_index = JOY_BUTTON_Y
		#InputMap.action_add_event(special_attack_action, special_attack_action_event)
		#
		#use_item_action = "f_use_item{n}".format({"n": player_index})
		#InputMap.add_action(use_item_action)
		#use_item_action_event = InputEventJoypadButton.new()
		#use_item_action_event.device = player_index
		#use_item_action_event.button_index = JOY_BUTTON_B
		#InputMap.action_add_event(use_item_action, use_item_action_event)
		#
		#block_action = "f_block{n}".format({"n": player_index})
		#InputMap.add_action(block_action)
		#block_action_event = InputEventJoypadButton.new()
		#block_action_event.device = player_index
		#block_action_event.button_index = JOY_BUTTON_RIGHT_SHOULDER
		#InputMap.action_add_event(block_action, block_action_event)
		#
		#grab_action = "f_grab{n}".format({"n": player_index})
		#InputMap.add_action(grab_action)
		#grab_action_event = InputEventJoypadButton.new()
		#grab_action_event.device = player_index
		#grab_action_event.button_index = JOY_BUTTON_LEFT_SHOULDER
		#InputMap.action_add_event(grab_action, grab_action_event)
		#endregion
		#endregion
	else:
		pass
	
	add_child(player)

#func on_ui_added() -> void:
	#emit_signal("set_current_level_info", game_ui.set_current_level_info(name, start_in_menu))

#func on_player_1_added() -> void:
	#emit_signal("player_1_setup", 0, player_2)
#
#func on_player_2_added() -> void:
	#emit_signal("player_2_setup", 1, player_1)

#func on_get_players() -> void:
	#emit_signal("set_players", fighter_1, fighter_2)
