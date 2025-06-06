class_name PlayerAttackState
extends PlayerState

var i: int = 0
var attack_chain_active: bool = false
var player_pressed_button: bool = false

func enter() -> void:
	super()
	# The player can enter this state from Idle, Heavy Attack, Crouch, and Jump
	# Play the first animation in the sequence
	i = 0
	player.velocity.x = 0
	player.animations.play(light_atk_anims[0])
	if get_current_attack_queue().size() == 0:
		add_to_attack_queue(light_atk_anims[0])
	prints("Current:", get_current_attack_queue())

func exit(new_state: State = null) -> void:
	clear_attack_queue()
	super(new_state)

func process_input(event: InputEvent) -> State:
	super(event)
	player_pressed_button = true
	if player.animations.is_playing():
		if get_current_attack_queue().size() >= 1:
			if check_successful_chain_attack():
				if i + 1 < light_atk_anims.size():
					i += 1
					add_to_attack_queue(light_atk_anims[i])
				else:
					i = 0
	
	prints("Current:", attack_queue)
	return null

func process_frame(delta: float) -> State:
	super(delta)
	#print(i)
	if !player.animations.is_playing():
		if player_pressed_button:
			if attack_chain_active:
				player.animations.play(attack_queue[i])
			else:
				return idle_state
			player_pressed_button = false
		else:
			player_pressed_button = false
			return idle_state
	return null

func check_successful_chain_attack() -> bool:
	var result: bool = false
	var frame_window_size: int = 2
	var current_anim_frame: int
	var start_chain_frame: int
	var end_chain_frame: int
	
	if player.animations.is_playing():
		current_anim_frame = player.animations.frame
		start_chain_frame = player.animations.sprite_frames.get_frame_count(get_next_queued_attack()) - frame_window_size
		end_chain_frame = player.animations.sprite_frames.get_frame_count(get_next_queued_attack())
		if get_current_attack_queue().size() >= 1:
			if current_anim_frame >= start_chain_frame and current_anim_frame <= end_chain_frame:
				attack_chain_active = true
				result = true
			else:
				attack_chain_active = false
				result = false
		
	
	#region DEBUG Prints out frame timings
	#  Displays the frame the input was detected on
	#  and the frame window for an action chain (the last 3 frames of the attack)
	prints("Current animation frame when input was detected:", current_anim_frame)
	prints("Action Chain frame window (last", frame_window_size + 1 ,"frames of the attack):", start_chain_frame, "-", end_chain_frame, "inclusive")
	#endregion
	
	return result
