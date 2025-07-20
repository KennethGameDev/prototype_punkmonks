class_name PlayerJumpState
extends PlayerState

const JUMP_FORCE: int = -1250
var state_active: bool = false
var directional_influence: float = 0
var di_active: bool = false

func enter() -> void:
	##super()
	print("Jump State")
	state_active = true
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

func exit(new_state: PlayerState = null) -> void:
	state_active = false

func process_physics(delta: float) -> PlayerState:
	if state_active:
		# TODO: Increase DI strength
		if di_active:
			directional_influence += delta * 10
		else:
			directional_influence -= delta * 100
		if directional_influence != 0:
			state_machine_owner.velocity.x += directional_influence
		if state_machine_owner.is_on_floor():
			directional_influence = 0
			if get_move_dir() != 0:
				return move_state
			else:
				if Input.is_action_pressed(crouch_key):
					return crouch_state
				else:
					return idle_state
	return null

func process_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed(move_l_key) or event.is_action_pressed(move_r_key):
		di_active = true
	if event.is_action_released(move_l_key) or event.is_action_released(move_r_key):
		di_active = false
	return null
