class_name PlayerCrouchState
extends PlayerState

var state_active: bool = false
var is_crouched: bool = false
var i: int = 0


func enter() -> void:
	state_active = true
	state_machine_owner.velocity.x = 0
	state_machine_owner.animations.play(state_machine_owner.crouch_anim)

func exit(new_scene: PlayerState = null) -> void:
	state_active = false

func process_input(event: InputEvent) -> PlayerState:
	#super(event)
	print(event)
	if state_active:
		if event.is_action_released(crouch_key) or event.is_action_pressed(move_l_key) or event.is_action_pressed(move_r_key):
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
