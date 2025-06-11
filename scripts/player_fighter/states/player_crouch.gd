class_name PlayerCrouchState
extends PlayerState

var is_crouched: bool = false
var i: int = 0


func enter() -> void:
	super()
	#print("Crouch States")
	player.velocity.x = 0
	player.animations.play(crouch_anim)

func exit(new_state: State = null) -> void:
	super(new_state)

func process_frame(delta: float) -> State:
	super(delta)
	return null

func process_input(event: InputEvent) -> State:
	super(event)
	if event.is_action_released(crouch_key):
		player.animations.current_animation
		if get_move_dir() != 0:
			return move_state
		else:
			return idle_state
	elif event.is_action_pressed(light_atk_key) or event.is_action_pressed(heavy_atk_key):
		# Transition into attack state when you actually have crouch attack animations_old
		print("attack pressed")
		pass
	return null

func get_move_dir() -> float:
	return Input.get_axis(move_l_key, move_r_key)
