class_name PlayerMovementState
extends PlayerState

const SPEED: float = 900
var going_right: bool = true

func enter() -> void:
	#print("Movement State")
	super()

func exit(new_state: State = null) -> void:
	super(new_state)

func process_physics(delta: float) -> State:
	do_move(get_move_dir())
	# TODO: [FIX] New inputs get eaten when rolling into them
	if get_move_dir() == 0: return idle_state
	super(delta)
	return null

func process_input(event: InputEvent) -> State:
	super(event)
	if event.is_action_pressed(jump_key):
		return jump_state
	elif event.is_action_pressed(crouch_key):
		return crouch_state
	elif event.is_action_pressed(light_atk_key) or event.is_action_pressed(heavy_atk_key):
		return attack_state
	return null

func get_move_dir() -> float:
	var direction: int
	
	if direction:
		if direction < 0:
			going_right = false
		elif direction > 0:
			going_right = true
		else:
			pass
	else:
		direction = Input.get_axis(move_l_key, move_r_key)
	
	return direction

func do_move(move_dir: float) -> void:
	player.velocity.x = move_dir * SPEED
	if sprite_flipped == false:
		if move_dir > 0:
			player.animations.play(move_f_anim)
		else:
			player.animations.play(move_b_anim)
	else:
		if move_dir < 0:
			player.animations.play(move_f_anim)
		else:
			player.animations.play(move_b_anim)
