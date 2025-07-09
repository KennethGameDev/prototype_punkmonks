class_name PlayerJumpState
extends PlayerState

const JUMP_FORCE: int = -1000

func enter() -> void:
	##super()
	print("Jump State")
	state_machine_owner.velocity.y = JUMP_FORCE
	var move_dir: float = get_move_dir()
	if state_machine_owner.sprite_flipped == false:
		if move_dir > 0:
			state_machine_owner.animations.play(state_machine_owner.jump_uf_anim)
		elif move_dir < 0:
			state_machine_owner.animations.play(state_machine_owner.jump_ub_anim)
		else:
			state_machine_owner.animations.play(state_machine_owner.jump_u_anim)
	else:
		if move_dir < 0:
			state_machine_owner.animations.play(state_machine_owner.jump_uf_anim)
		elif move_dir > 0:
			state_machine_owner.animations.play(state_machine_owner.jump_ub_anim)
		else:
			state_machine_owner.animations.play(state_machine_owner.jump_u_anim)

func process_physics(delta: float) -> PlayerState:
	if state_machine_owner.is_on_floor():
		if get_move_dir() != 0:
			return move_state
		else:
			return idle_state
	return null

func process_input(event: InputEvent) -> PlayerState:
	#super(event)
	# Process arial attacks here
	return null
