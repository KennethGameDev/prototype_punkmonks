class_name PlayerMovementState
extends PlayerState

const SPEED: float = 900

func enter() -> void:
	super()

func exit(new_state: State = null) -> void:
	super(new_state)
	player.velocity.x = 0

func process_physics(delta: float) -> State:
	do_move(get_move_dir())
	# TODO: [FIX] New inputs get eaten when rolling into them
	if get_move_dir() == 0: return idle_state
	super(delta)
	return null

func get_move_dir() -> float:
	# Look here for potential fix to the above. Maybe, idk
	return Input.get_axis(move_l_key, move_r_key)

func do_move(move_dir: float) -> void:
	player.velocity.x = move_dir * SPEED
	if sprite_flipped == false:
		if move_dir > 0:
			player.animation.play(move_f_anim)
		else:
			player.animation.play(move_b_anim)
	else:
		if move_dir < 0:
			player.animation.play(move_f_anim)
		else:
			player.animation.play(move_b_anim)
