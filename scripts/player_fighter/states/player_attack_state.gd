#class_name PlayerAttackState
#extends PlayerState
#
#@export_group("Attack States")
#@export var light_attack_state: PlayerAttackState
#@export var heavy_attack_state: PlayerAttackState
#@export var special_attack_state: PlayerAttackState
#
#
### Base Functions
##region Base State class function overrides
#func enter() -> void:
	#pass
#
#func process_input(event: InputEvent) -> State:
	##super(event)
	#return null
#
#func process_frame(delta: float) -> State:
	#if active_player.last_pressed_key == active_player.light_atk_key:
		#return light_attack_state
	#elif active_player.last_pressed_key == active_player.heavy_atk_key:
		#return heavy_attack_state
	##super(delta)
	#return null
#
#func process_physics(delta: float) -> State:
	##super(delta)
	#return null
#
#func exit(new_state: State = null) -> void:
	##new_state.attack_chain = attack_chain
	##new_state.prev_attack_chain = prev_attack_chain
	##new_state.attack_index = attack_index
	##new_state.player_pressed_button = player_pressed_button
	##new_state.current_anim_length = current_anim_length
	##new_state.current_anim_active_frames_start = current_anim_active_frames_start
	##new_state.current_anim_active_frames_end = current_anim_active_frames_end
	##new_state.current_anim_state = current_anim_state
	##super(new_state)
	#pass
##endregion
