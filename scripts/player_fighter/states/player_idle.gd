class_name PlayerIdleState
extends PlayerState

func enter() -> void:
	player.animation.play(idle_anim)

func exit(new_state: State = null) -> void:
	super(new_state)

func process_physics(delta: float) -> State:
	super(delta)
	determine_forward_direction()
	return null

func process_input(event: InputEvent) -> State:
	super(event)
	if event.is_action_pressed(movement_key):
		return move_state
	return null
