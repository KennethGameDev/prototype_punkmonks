class_name PlayerMovementState
extends PlayerState

const SPEED: float = 450

func process_physics(delta: float) -> PlayerState:
	# TODO: [FIX] New inputs get eaten when rolling into them
	if Input.is_action_just_pressed(move_l_key) or Input.is_action_just_pressed(move_r_key):
		state_machine_owner.determine_forward_direction()
		do_move(get_move_dir())
	elif get_move_dir() == 0: return idle_state
	return null
#
func process_input(event: InputEvent) -> PlayerState:
	if event.is_pressed():
		prints(name, event.device, state_machine_owner.name)
		if event.is_action_pressed(jump_key):
			return jump_state
		elif event.is_action_pressed(crouch_key):
			return crouch_state
		#elif event.is_action_pressed(active_player.light_atk_key):
			#return attack_state
		#elif event.is_action_pressed(active_player.heavy_atk_key):
			#return attack_state
	return null

func do_move(move_dir: int) -> void:
	state_machine_owner.velocity.x = move_dir * SPEED
	if state_machine_owner.sprite_flipped == false:
		if move_dir > 0:
			state_machine_owner.animations.play(state_machine_owner.move_f_anim)
		else:
			state_machine_owner.animations.play(state_machine_owner.move_b_anim)
	else:
		if move_dir < 0:
			state_machine_owner.animations.play(state_machine_owner.move_f_anim)
		else:
			state_machine_owner.animations.play(state_machine_owner.move_b_anim)
