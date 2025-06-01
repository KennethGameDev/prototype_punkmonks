class_name PlayerCrouchState
extends PlayerState

func enter() -> void:
	super()
	print("Crouch States")
	player.velocity.x = 0
	player.animations.play(crouch_start_anim)

func exit(new_state: State = null) -> void:
	super(new_state)

func process_frame(delta: float) -> State:
	super(delta)
	if player.animations.animation.get_basename() == crouch_start_anim:
		if !player.animations.is_playing():
			player.animations.play(crouching_anim)
	return null

func process_input(event: InputEvent) -> State:
	super(event)
	if event.is_action_released(crouch_key):
		if get_move_dir() != 0:
			return move_state
		else:
			return idle_state
	return null

func get_move_dir() -> float:
	return Input.get_axis(move_l_key, move_r_key)
