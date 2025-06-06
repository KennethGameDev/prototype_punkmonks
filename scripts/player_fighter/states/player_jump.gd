class_name PlayerJumpState
extends PlayerState

const JUMP_FORCE: int = -2500

func enter() -> void:
	super()
	#print("Jump State")
	player.velocity.y = JUMP_FORCE
	var move_dir: float = get_move_dir()
	if sprite_flipped == false:
		if move_dir > 0:
			player.animations.play(jump_uf_anim)
		elif move_dir < 0:
			player.animations.play(jump_ub_anim)
		else:
			player.animations.play(jump_u_anim)
	else:
		if move_dir < 0:
			player.animations.play(jump_uf_anim)
		elif move_dir > 0:
			player.animations.play(jump_ub_anim)
		else:
			player.animations.play(jump_u_anim)

func exit(new_state: State = null) -> void:
	super(new_state)

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	player.move_and_slide()
	if player.is_on_floor(): 
		if get_move_dir() != 0:
			return move_state
		else:
			return idle_state
	return null

func process_input(event: InputEvent) -> State:
	super(event)
	# Process arial attacks here
	return null

func get_move_dir() -> float:
	return Input.get_axis(move_l_key, move_r_key)
