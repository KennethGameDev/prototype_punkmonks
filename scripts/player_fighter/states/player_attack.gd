class_name PlayerAttackState
extends PlayerState



func enter() -> void:
	super()
	print("Attack_State")

func exit(new_state: State = null) -> void:
	super(new_state)

func process_input(event: InputEvent) -> State:
	if event.is_action(light_atk_key):
		player.animations.play(light_atk_anims[0])
	if event.is_action(heavy_atk_key):
		player.animations.play(heavy_atk_anims[0])
	return null

func process_frame(delta: float) -> State:
	if !player.animations.is_playing():
		return idle_state
	return null
