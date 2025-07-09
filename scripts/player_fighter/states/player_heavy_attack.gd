#class_name PlayerHeavyAttackState
#extends PlayerAttackState
#
#func enter() -> void:
	#active_player.velocity.x = 0
	#if active_player.is_light_attack_anim_playing():
		#active_player.add_to_attack_chain(active_player.heavy_atk_anims[active_player.heavy_atk_anim_index])
	#if !active_player.attack_chain_active or active_player.attack_chain.is_empty():
		#active_player.add_to_attack_chain(active_player.heavy_atk_anims[0])
		#active_player.animations.play(active_player.heavy_atk_anims[0])
		#
#
#func exit(new_state: State = null) -> void:
	##new_state.player_pressed_button = player_pressed_button
	##new_state.light_atk_anim_index = light_atk_anim_index
	##new_state.heavy_atk_anim_index = heavy_atk_anim_index
	##new_state.attack_chain_active = attack_chain_active
	##new_state.attack_chain = attack_chain
	##new_state.attack_index = attack_index
	##super(new_state)
	#pass
#
#func process_input(event: InputEvent) -> State:
	#if event.is_pressed():
		#if active_player.is_heavy_attack_anim_playing():
			#if event.is_action_pressed(active_player.heavy_atk_key):
				#active_player.player_pressed_button = true
				#if check_successful_chain_attack():
					#active_player.add_to_attack_chain(active_player.heavy_atk_anims[active_player.heavy_atk_anim_index])
			#elif event.is_action_pressed(active_player.light_atk_key):
				#active_player.player_pressed_button = true
				#if check_successful_chain_attack():
					#return light_attack_state
	##super(event)
	#return null
#
#func process_frame(delta: float) -> State:
	#if !active_player.animations.is_playing():
		#if active_player.player_pressed_button:
			#active_player.player_pressed_button = false
			#if active_player.attack_chain_active:
				#active_player.animations.play(active_player.attack_chain[active_player.attack_index])
			#else:
				#active_player.clear_attack_chain()
				#active_player.light_atk_anim_index = 0
				#active_player.heavy_atk_anim_index = 0
				#return idle_state
		#else:
			#active_player.clear_attack_chain()
			#active_player.light_atk_anim_index = 0
			#active_player.heavy_atk_anim_index = 0
			#return idle_state
	#super(delta)
	#return null
#
#func check_successful_chain_attack() -> bool:
	#var result: bool = false
	#
	#if active_player.animations.is_playing():
		#if active_player.attack_chain.size() >= 1:
			#if active_player.current_anim_frame >= active_player.current_anim_active_frames_start and active_player.current_anim_frame <= active_player.current_anim_active_frames_end:
				#active_player.attack_chain_active = true
				#result = true
			#else:
				#active_player.attack_chain_active = false
				#result = false
		#
	#
	##region DEBUG Prints out frame timings
	##  Displays the frame the input was detected on
	##  and the frame window for an action chain (the last 3 frames of the attack)
	##prints("Current animation frame when input was detected:", current_anim_frame)
	##prints("Action Chain frame window:", current_anim_active_frames_start, "-", current_anim_active_frames_end, "inclusive")
	##endregion
	#
	#return result
