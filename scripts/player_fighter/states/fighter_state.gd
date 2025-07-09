class_name PlayerState
extends Node2D

var stage
var state_machine_owner: PlayerFighter
var state_machine_owner_id: int
signal get_state_machine_info

#region: States
var idle_state: PlayerState
var move_state: PlayerState
var jump_state: PlayerState
var crouch_state: PlayerState
var attack_state: PlayerState
#endregion

#region: InputMap variables
var move_l_key: String
var move_r_key: String
var jump_key: String
var crouch_key: String
#endregion

#region: Base State class functions
func enter() -> void:
	pass

func exit(new_state: PlayerState = null) -> void:
	pass

func process_input(event: InputEvent) -> PlayerState:
	return null

func process_frame(_delta: float) -> PlayerState:
	return null

func process_physics(delta: float) -> PlayerState:
	return null
#endregion

func get_move_dir() -> int:
	return Input.get_axis(move_l_key, move_r_key)
