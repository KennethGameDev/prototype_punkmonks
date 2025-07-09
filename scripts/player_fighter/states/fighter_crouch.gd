class_name PlayerCrouchState
extends PlayerState

var is_crouched: bool = false
var i: int = 0


func enter() -> void:
	state_machine_owner.velocity.x = 0
	state_machine_owner.animations.play(state_machine_owner.crouch_anim)

func process_input(event: InputEvent) -> PlayerState:
	#super(event)
	if event.is_action_released(crouch_key):
		state_machine_owner.animations.current_animation
		if get_move_dir() != 0:
			return move_state
		else:
			return idle_state
	#elif event.is_action_pressed(active_player.light_atk_key) or event.is_action_pressed(active_player.heavy_atk_key):
		## Transition into attack state when you actually have crouch attack animations_old
		#print("attack pressed")
		#pass
	return null
#
#func get_move_dir() -> float:
	#return Input.get_axis(active_player.move_l_key, active_player.move_r_key)
