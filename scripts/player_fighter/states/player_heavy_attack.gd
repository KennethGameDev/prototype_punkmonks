class_name PlayerHeavyAttackState
extends PlayerAttackState

func enter() -> void:
	player.velocity.x = 0
	if is_light_attack_anim_playing():
		add_to_attack_chain(heavy_atk_anims[heavy_atk_anim_index])
	if !attack_chain_active or attack_chain.is_empty():
		add_to_attack_chain(heavy_atk_anims[0])
		player.animations.play(heavy_atk_anims[0])
		

func exit(new_state: State = null) -> void:
	new_state.player_pressed_button = player_pressed_button
	new_state.light_atk_anim_index = light_atk_anim_index
	new_state.heavy_atk_anim_index = heavy_atk_anim_index
	new_state.attack_chain_active = attack_chain_active
	new_state.attack_chain = attack_chain
	new_state.attack_index = attack_index
	super(new_state)
	pass

func process_input(event: InputEvent) -> State:
	if event.is_pressed():
		if is_heavy_attack_anim_playing():
			if event.is_action_pressed(heavy_atk_key):
				player_pressed_button = true
				if check_successful_chain_attack():
					add_to_attack_chain(heavy_atk_anims[heavy_atk_anim_index])
			elif event.is_action_pressed(light_atk_key):
				player_pressed_button = true
				if check_successful_chain_attack():
					return light_attack_state
	super(event)
	return null

func process_frame(delta: float) -> State:
	if !player.animations.is_playing():
		if player_pressed_button:
			player_pressed_button = false
			if attack_chain_active:
				player.animations.play(attack_chain[attack_index])
			else:
				clear_attack_chain()
				light_atk_anim_index = 0
				heavy_atk_anim_index = 0
				return idle_state
		else:
			clear_attack_chain()
			light_atk_anim_index = 0
			heavy_atk_anim_index = 0
			return idle_state
	super(delta)
	return null

func check_successful_chain_attack() -> bool:
	var result: bool = false
	
	if player.animations.is_playing():
		if attack_chain.size() >= 1:
			if current_anim_frame >= current_anim_active_frames_start and current_anim_frame <= current_anim_active_frames_end:
				attack_chain_active = true
				result = true
			else:
				attack_chain_active = false
				result = false
		
	
	#region DEBUG Prints out frame timings
	#  Displays the frame the input was detected on
	#  and the frame window for an action chain (the last 3 frames of the attack)
	#prints("Current animation frame when input was detected:", current_anim_frame)
	#prints("Action Chain frame window:", current_anim_active_frames_start, "-", current_anim_active_frames_end, "inclusive")
	#endregion
	
	return result
