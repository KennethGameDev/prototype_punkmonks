class_name PlayerAttackState
extends PlayerState


func enter() -> void:
	super()
	print("Attack_State")

func exit(new_state: State = null) -> void:
	super(new_state)
	clear_input_buffer()

func process_input(event: InputEvent) -> State:
	# Input Chain Loop:
	#	if the attack_buffer not full (<= 5):
	#		add the input_key to the attack_buffer,
	#		if current_combo != null:
	#			check current_combo + attack_buffer for a recognized combo string
	#		else, current_combo is empty:
	#			check only the attack_buffer for a recognized combo string
	#		if a match is found:
	#			save the combination of those arrays in the current_combo variable
	#	else, the attack_buffer is full:
	#		ignore futher inputs
	#	if current_combo != null:
	#		track the current move in the combo using an iterator,
	#		play the corresponding combo animation
	#	
	
	var combo_allowed: bool = true
	while combo_allowed:
		if event.is_action(light_atk_key):
			pass
	
	#var already_added: bool = false
	#if event.is_action(light_atk_key):
		#while !already_added:
			#already_added = true
			#if player.animations.is_playing():
				#add_to_input_buffer(light_atk_key)
		#player.animations.play(light_atk_anims[0])
	#if event.is_action(heavy_atk_key):
		#if player.animations.is_playing():
			#add_to_input_buffer(heavy_atk_key)
		#player.animations.play(heavy_atk_anims[0])
	#print(get_current_input_buffer())
	return idle_state

func process_frame(_delta: float) -> State:
	if !player.animations.is_playing():
		return idle_state
	return null
