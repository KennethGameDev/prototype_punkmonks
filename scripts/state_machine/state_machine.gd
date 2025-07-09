class_name StateMachine
extends Node2D

@onready var stage = get_tree().get_first_node_in_group("Stage")
var all_states: Array[Node2D]
var all_state_names: Array[String] = [
	"S_Idle",
	"S_Movement",
	"S_Jump",
	"S_Crouch",
	#"S_Light_Attack",
	#"S_Heavy_Attack",
	#"S_Special_Attack",
	#"S_Use_Item",
	#"S_Hit"
	]
var all_state_scripts: Array = [
	load("res://scripts/player_fighter/states/fighter_idle.gd"),
	load("res://scripts/player_fighter/states/fighter_movement.gd"),
	load("res://scripts/player_fighter/states/fighter_jump.gd"),
	load("res://scripts/player_fighter/states/fighter_crouch.gd"),
	#load(),
	#load(),
	#load(),
	#load(),
	#load(),
]
var default_starting_state: String
var starting_state: PlayerState
var current_state: PlayerState
var state_machine_owner: PlayerFighter
var state_machine_owner_id: int


func _ready() -> void:
	initialize_states()
	change_state(starting_state, state_machine_owner_id)

func initialize_states() -> void:
	var i: int = 0
	if all_state_names.size() == all_state_scripts.size():
		while i < all_state_names.size():
			# Create a new "NewPlayerState" and add it to the all_states array
			all_states.append(PlayerState.new())
			# Create a variable to reference the newly created state
			var state: PlayerState = all_states[i]
			# Add the new state node as a child of the state machine
			add_child(state)
			# Set the state's script (needs to line up correctly in the initialized array above)
			state.set_script(all_state_scripts[i])
			# Set the state's name (needs to line up correctly in the initialized array above)
			state.name = all_state_names[i]
			# Set the state's ownership variables and input map
			state.stage = stage
			state.state_machine_owner = state_machine_owner
			state.state_machine_owner_id = state_machine_owner_id
			state.move_l_key = state_machine_owner.input_map.keys()[0]
			state.move_r_key = state_machine_owner.input_map.keys()[1]
			state.jump_key = state_machine_owner.input_map.keys()[2]
			state.crouch_key = state_machine_owner.input_map.keys()[3]
			# Check if the newly added state is the default starting state, determined by the state_machine
			if state.name == default_starting_state:
				starting_state = state
			# Increment the counter and loop
			i += 1
		# Set up all state references
		for state in all_states:
			state.idle_state = all_states[0]
			state.move_state = all_states[1]
			state.jump_state = all_states[2]
			state.crouch_state = all_states[3]
	else:
		push_error("Some states are missing scripts or vice/versa.")

func process_input(event: InputEvent, player_id: int) -> void:
	if player_id == state_machine_owner_id:
		if event.is_pressed() or event.is_released():
			var new_state: PlayerState = current_state.process_input(event)
			if new_state: change_state(new_state, state_machine_owner_id)

func process_frame(delta: float, player_id: int) -> void:
	if player_id == state_machine_owner_id:
		var new_state: PlayerState = current_state.process_frame(delta)
		if new_state: change_state(new_state, state_machine_owner_id)

func process_physics(delta: float, player_id: int) -> void:
	if player_id == state_machine_owner_id:
		var new_state: PlayerState = current_state.process_physics(delta)
		if new_state: change_state(new_state, state_machine_owner_id)

func change_state(new_state: PlayerState, player_id: int) -> void:
	if player_id == state_machine_owner_id:
		if current_state: current_state.exit(new_state)
		current_state = new_state
		current_state.enter()
