class_name NPCIdleState
extends NPCState

func enter() -> void:
	npc.animation.play(idle_anim)

func process_physics(delta: float) -> State:
	super(delta)
	return null

func process_input(event: InputEvent) -> State:
	super(event)
	#if event.is_action_pressed(movement_key):
		#return move_state
	return null
