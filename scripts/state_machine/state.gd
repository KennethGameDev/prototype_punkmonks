class_name State
extends Node2D


func enter() -> void:
	pass

func exit(new_state: State = null) -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
