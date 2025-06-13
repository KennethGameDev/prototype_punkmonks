class_name PlayerAttackState
extends PlayerState

@export_group("Attack States")
@export var light_attack_state: PlayerAttackState
@export var heavy_attack_state: PlayerAttackState
@export var special_attack_state: PlayerAttackState


## Base Functions
#region Base State class function overrides
func enter() -> void:
	pass

func process_input(event: InputEvent) -> State:
	super(event)
	return null

func process_frame(delta: float) -> State:
	if get_last_pressed_key() == light_atk_key:
		return light_attack_state
	elif get_last_pressed_key() == heavy_atk_key:
		return heavy_attack_state
	super(delta)
	return null

func process_physics(delta: float) -> State:
	super(delta)
	return null

func exit(new_state: State = null) -> void:
	new_state.attack_chain = attack_chain
	new_state.prev_attack_chain = prev_attack_chain
	new_state.attack_index = attack_index
	new_state.player_pressed_button = player_pressed_button
	new_state.current_anim_length = current_anim_length
	new_state.current_anim_active_frames_start = current_anim_active_frames_start
	new_state.current_anim_active_frames_end = current_anim_active_frames_end
	new_state.current_anim_state = current_anim_state
	super(new_state)
#endregion

#region Animation Functions. Called by 'method call tracks' within the animation
func set_current_animation_frame(frame: int) -> void:
	current_anim_frame = frame

func set_current_animation_frame_info(number_of_frames: int, active_frame_start: int, active_frame_end: int) -> void:
	current_anim_length = number_of_frames
	current_anim_active_frames_start = active_frame_start
	current_anim_active_frames_end = active_frame_end

func set_current_animation_state(current_state: String) -> void:
	current_anim_state = current_state
#endregion

#region: Utility Functions
func add_to_attack_chain(anim_name: String) -> void:
	prev_attack_chain = attack_chain
	attack_index += 1
	if anim_name.contains("Light Attack"):
		if light_atk_anim_index + 1 < light_atk_anims.size():
			light_atk_anim_index += 1
		else:
			light_atk_anim_index = 0
	elif anim_name.contains("Heavy Attack"):
		if heavy_atk_anim_index + 1 < heavy_atk_anims.size():
			heavy_atk_anim_index += 1
		else:
			heavy_atk_anim_index = 0
	attack_chain.append(anim_name)

func clear_attack_chain() -> void:
	attack_index = -1
	attack_chain.clear()

func is_light_attack_anim_playing() -> bool:
	if player.animations.current_animation.get_basename() == light_atk_anims[0] or player.animations.current_animation.get_basename() == light_atk_anims[1] or player.animations.current_animation.get_basename() == light_atk_anims[2]:
		if player.animations.current_animation_position < player.animations.current_animation_length and player.animations.current_animation_position >= 0:
			return true
		else:
			return false
	else:
		return false

func is_heavy_attack_anim_playing() -> bool:
	if player.animations.current_animation.get_basename() == heavy_atk_anims[0] or player.animations.current_animation.get_basename() == heavy_atk_anims[1]:
		if player.animations.current_animation_position < player.animations.current_animation_length and player.animations.current_animation_position >= 0:
			return true
		else:
			return false
	else:
		return false
#endregion
