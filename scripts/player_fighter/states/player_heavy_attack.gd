class_name PlayerHeavyAttackState
extends PlayerState

var i: int = 0
var attack_chain_active: bool = false
var player_pressed_button: bool = false
var current_anim_frame: int = 0
var current_anim_length: int = 0
var current_anim_state: String = ""
var current_anim_active_frames_start: int = 0
var current_anim_active_frames_end: int = 0

func enter() -> void:
	super()
	# TODO Crouch Attack, and Jump Attack
	# The player can enter this state from Idle, Light Attack, Crouch, and Jump
	# Play the first animation in the sequence
	i = 0
	player.velocity.x = 0
	player.animations.play(heavy_atk_anims[0])
	add_to_attack_queue(heavy_atk_anims[0])
	prints("Current:", get_current_attack_queue())

func exit(new_state: State = null) -> void:
	super(new_state)

func process_input(event: InputEvent) -> State:
	super(event)
	if event.is_pressed():
		player_pressed_button = true
		if player.animations.is_playing():
			if event.is_action_pressed(heavy_atk_key):
				if get_current_attack_queue().size() >= 1:
					if check_successful_chain_attack():
						if i + 1 < heavy_atk_anims.size():
							i += 1
						else:
							i = 0
						add_to_attack_queue(heavy_atk_anims[i])
			elif event.is_action_pressed(light_atk_key) and attack_chain_active:
				return light_attack_state
		prints("Current:", attack_queue)
	return null

func process_frame(delta: float) -> State:
	super(delta)
	if !player.animations.is_playing():
		if player_pressed_button:
			if attack_chain_active:
				player.animations.play(attack_queue[i])
			else:
				clear_attack_queue()
				return idle_state
			player_pressed_button = false
		else:
			player_pressed_button = false
			clear_attack_queue()
			return idle_state
	return null

func check_successful_chain_attack() -> bool:
	var result: bool = false
	
	if player.animations.is_playing():
		if get_current_attack_queue().size() >= 1:
			if current_anim_frame >= current_anim_active_frames_start and current_anim_frame <= current_anim_active_frames_end:
				attack_chain_active = true
				result = true
			else:
				attack_chain_active = false
				result = false
		
	
	#region DEBUG Prints out frame timings
	#  Displays the frame the input was detected on
	#  and the frame window for an action chain (the last 3 frames of the attack)
	prints("Current animation frame when input was detected:", current_anim_frame)
	prints("Action Chain frame window:", current_anim_active_frames_start, "-", current_anim_active_frames_end, "inclusive")
	#endregion
	
	return result

#region Animation Functions. Called by 'method call tracks' within the animation
func set_current_animation_frame(frame: int) -> void:
	current_anim_frame = frame

func set_current_animation_total_frames(number_of_frames: int, active_frame_start: int, active_frame_end: int) -> void:
	current_anim_length = number_of_frames
	current_anim_active_frames_start = active_frame_start
	current_anim_active_frames_end = active_frame_end

func set_current_animation_state(current_state: String) -> void:
	current_anim_state = current_state
#endregion
