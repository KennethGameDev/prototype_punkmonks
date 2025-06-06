class_name PlayerIdleState
extends PlayerState

func enter() -> void:
	print("Idle State")
	player.velocity.x = 0
	player.animations.play(idle_anim)

func exit(new_state: State = null) -> void:
	super(new_state)

func process_physics(delta: float) -> State:
	super(delta)
	determine_forward_direction()
	return null

func process_input(event: InputEvent) -> State:
	super(event)
	if Input.is_action_just_pressed(move_l_key) or Input.is_action_just_pressed(move_r_key):
		return move_state
	elif event.is_action_pressed(jump_key):
		return jump_state
	elif event.is_action_pressed(light_atk_key) and event.is_pressed() or event.is_action_pressed(heavy_atk_key) and event.is_pressed():
		#print("Attack Input")
		return attack_state
	elif event.is_action_pressed(crouch_key):
		return crouch_state
	return null
