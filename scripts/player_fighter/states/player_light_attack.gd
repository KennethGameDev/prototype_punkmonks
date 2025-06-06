class_name PlayerAttackState
extends PlayerState

var i: int = 0
var allow_input: bool = false

func enter() -> void:
	super()
	#print("Light Attack State")
	# The player can enter this state from Idle, Heavy Attack, Crouch, and Jump
	# Play the first animation in the sequence
	i = 1
	player.animations.play(light_atk_anims[0])
	#print(attack_queue)

func exit(new_state: State = null) -> void:
	i = 0
	attack_queue.clear()
	super(new_state)

func process_input(event: InputEvent) -> State:
	#prints("attack", i)
	if player.animations.is_playing():
		if player.animations.frame >= player.animations.sprite_frames.get_frame_count(light_atk_anims[0]) - 3:
			#print("valid combo window")
			if i < light_atk_anims.size():
				attack_queue.push_back(light_atk_anims[i])
				i += 1
				#print(attack_queue)
	
	return null

func process_frame(_delta: float) -> State:
	if !player.animations.is_playing():
		allow_input = false
		if !attack_queue.is_empty():
			player.animations.play(attack_queue[0])
		else:
			return idle_state
		attack_queue.remove_at(0)
	else:
		if attack_queue:
			if player.animations.frame >= player.animations.sprite_frames.get_frame_count(attack_queue[0]) - 3:
				allow_input = true
	print(allow_input)
	return null
