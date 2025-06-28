class_name PlayerIdleState
extends PlayerState

func enter() -> void:
	#print("Idle State")
	fighter.velocity.x = 0
	fighter.clear_attack_chain()
	fighter.animations.play(fighter.idle_anim)

func exit(new_state: State = null) -> void:
	super(new_state)

func process_physics(delta: float) -> State:
	super(delta)
	fighter.determine_forward_direction()
	return null

func process_input(event: InputEvent) -> State:
	#super(event)
	if event.is_pressed():
		prints(name, event.device, fighter.move_l_key)
		if Input.is_action_just_pressed(fighter.move_l_key) or Input.is_action_just_pressed(fighter.move_r_key):
			return move_state
		elif event.is_action_pressed(fighter.jump_key):
			return jump_state
		elif event.is_action_pressed(fighter.light_atk_key):
			return attack_state
		elif event.is_action_pressed(fighter.heavy_atk_key):
			return attack_state
		elif event.is_action_pressed(fighter.crouch_key):
			return crouch_state
	return null
