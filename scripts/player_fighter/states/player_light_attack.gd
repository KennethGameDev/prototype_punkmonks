class_name PlayerAttackState
extends PlayerState

var i: int = 0
var allow_input: bool = false
var active_combo_string: Array[String] = []

func enter() -> void:
	super()
	# The player can enter this state from Idle, Heavy Attack, Crouch, and Jump
	# Play the first animation in the sequence
	player.animations.play(light_atk_anims[0])
	i = 1

func exit(new_state: State = null) -> void:
	i = 0
	super(new_state)

func process_input(event: InputEvent) -> State:
	super(event)
	prints("Light Attack", i)
	if i == 1:
		add_to_attack_queue(light_atk_anims[0])
	if player.animations.is_playing():
		if get_current_attack_queue().size() >= 1:
			if check_successful_chain_attack():
				if i < light_atk_anims.size():
					add_to_attack_queue(light_atk_anims[i])
					i += 1
	return null

func process_frame(delta: float) -> State:
	super(delta)
	if !player.animations.is_playing():
		if attack_queue.size() == 1:
			attack_queue.clear()
		elif !attack_queue.is_empty():
			print(attack_queue)
			player.animations.play(attack_queue.pop_at(1))
		else:
			return idle_state
	return null

func check_successful_chain_attack() -> bool:
	var result: bool = false
	#region DEBUG Prints out frame timings on inputs and the frame window for an action chain
	prints("Current animation frame when input was detected:", player.animations.frame)
	prints("Action Chain frame window (last 3 frames of the attack):", player.animations.sprite_frames.get_frame_count(get_next_queued_attack()) - 3, "-", player.animations.sprite_frames.get_frame_count(get_next_queued_attack()))
	#endregion
	if player.animations.is_playing():
		if get_current_attack_queue().size() >= 1:
			if player.animations.frame >= player.animations.sprite_frames.get_frame_count(get_next_queued_attack()) - 3 and player.animations.frame <= player.animations.sprite_frames.get_frame_count(get_next_queued_attack()):
				result = true
			else:
				result = false
	
	return result
