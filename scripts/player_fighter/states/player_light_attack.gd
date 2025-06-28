class_name PlayerLightAttackState
extends PlayerAttackState

func enter() -> void:
	fighter.velocity.x = 0
	if fighter.is_heavy_attack_anim_playing():
		fighter.add_to_attack_chain(fighter.light_atk_anims[fighter.light_atk_anim_index])
	elif !fighter.attack_chain_active or fighter.attack_chain.is_empty():
		fighter.add_to_attack_chain(fighter.light_atk_anims[0])
		fighter.animations.play(fighter.light_atk_anims[0])

func exit(new_state: State = null) -> void:
	#new_state.player_pressed_button = player_pressed_button
	#new_state.light_atk_anim_index = light_atk_anim_index
	#new_state.heavy_atk_anim_index = heavy_atk_anim_index
	#new_state.attack_chain_active = attack_chain_active
	#new_state.attack_chain = attack_chain
	#new_state.attack_index = attack_index
	#super(new_state)
	pass

func process_input(event: InputEvent) -> State:
	if event.is_pressed():
		if fighter.is_light_attack_anim_playing():
			if event.is_action_pressed(fighter.light_atk_key):
				fighter.player_pressed_button = true
				if check_successful_chain_attack():
					fighter.add_to_attack_chain(fighter.light_atk_anims[fighter.light_atk_anim_index])
			elif event.is_action_pressed(fighter.heavy_atk_key):
				fighter.player_pressed_button = true
				if check_successful_chain_attack():
					return heavy_attack_state
	#super(event)
	return null

func process_frame(delta: float) -> State:
	if !fighter.animations.is_playing():
		if fighter.player_pressed_button:
			fighter.player_pressed_button = false
			if fighter.attack_chain_active:
				fighter.animations.play(fighter.attack_chain[fighter.attack_index])
			else:
				fighter.clear_attack_chain()
				fighter.light_atk_anim_index = 0
				fighter.heavy_atk_anim_index = 0
				return idle_state
		else:
			fighter.light_atk_anim_index = 0
			fighter.heavy_atk_anim_index = 0
			fighter.clear_attack_chain()
			return idle_state
	super(delta)
	return null

func check_successful_chain_attack() -> bool:
	var result: bool = false
	
	if fighter.animations.is_playing():
		if fighter.attack_chain.size() >= 1:
			if fighter.current_anim_frame >= fighter.current_anim_active_frames_start and fighter.current_anim_frame <= fighter.current_anim_active_frames_end:
				fighter.attack_chain_active = true
				result = true
			else:
				fighter.attack_chain_active = false
				result = false
		
	
	#region DEBUG Prints out frame timings
	#  Displays the frame the input was detected on
	#  and the frame window for an action chain (the last 3 frames of the attack)
	#prints("Current animation frame when input was detected:", current_anim_frame)
	#prints("Action Chain frame window:", current_anim_active_frames_start, "-", current_anim_active_frames_end, "inclusive")
	#endregion
	
	return result
