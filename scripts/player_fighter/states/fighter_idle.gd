class_name PlayerIdleState
extends PlayerState

func enter() -> void:
	prints("Player", state_machine_owner_id + 1, "Idle State")
	state_machine_owner.velocity.x = 0
	#active_player.clear_attack_chain()
	state_machine_owner.determine_forward_direction()
	#prints(active_player.name, "sprite flipped:", active_player.sprite_flipped)
	state_machine_owner.animations.play(state_machine_owner.idle_anim)

func process_physics(delta: float) -> PlayerState:
	#super(delta)
	state_machine_owner.determine_forward_direction()
	return null

func process_input(event: InputEvent) -> PlayerState:
	if event.is_pressed():
		prints(name, event.device, state_machine_owner.name)
		if Input.is_action_pressed(move_l_key) or Input.is_action_pressed(move_r_key):
			return move_state
		elif event.is_action_pressed(jump_key):
			return jump_state
		#elif event.is_action_pressed(active_player.light_atk_key):
			#return attack_state
		#elif event.is_action_pressed(active_player.heavy_atk_key):
			#return attack_state
		#elif event.is_action_pressed(active_player.crouch_key):
			#return crouch_state
	return null
