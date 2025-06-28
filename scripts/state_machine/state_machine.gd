class_name StateMachine
extends Node2D

@export var starting_state: State
var current_state: State


func init() -> void: change_state(starting_state)

func process_input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion and (event.is_pressed() or event.is_released()):
		var new_state: State = current_state.process_input(event)
		if new_state: change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state: State = current_state.process_frame(delta)
	if new_state: change_state(new_state)

func process_physics(delta: float) -> void:
	var new_state: State = current_state.process_physics(delta)
	if new_state: change_state(new_state)

func change_state(new_state: State) -> void:
	if current_state: current_state.exit(new_state)
	current_state = new_state
	current_state.enter()
