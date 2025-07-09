class_name NewPlayerFighter
extends CharacterBody2D

@export var player_id: int = 0
var state_machine_scene: PackedScene = preload("res://scenes/MVP/state_machine.tscn")
var state_machine: StateMachine
var opponent: NewPlayerFighter
var input_map: Dictionary


func _ready():
	state_machine = state_machine_scene.instantiate()
	#state_machine.state_machine_owner = self
	state_machine.state_machine_owner_id = player_id
	state_machine.default_starting_state = "S_Idle"
	add_child(state_machine)

func _input(event):
	if event is not InputEventMouse:
		if event is not InputEventJoypadMotion:
			if event.device == player_id:
				state_machine.process_input(event, player_id)

func _physics_process(delta):
	state_machine.process_physics(delta, player_id)
	move_and_slide()
