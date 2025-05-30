class_name NPCMovementState
extends NPCState

const SPEED: float = 1000

func enter() -> void:
	super()
	npc.animation.play(move_f_anim)

func exit(new_state: State = null) -> void:
	super(new_state)
	npc.velocity.x = 0

func process_physics(delta: float) -> State:
	#do_move(get_move_dir())
	#if get_move_dir() == 0: return idle_state
	super(delta)
	return null

#func get_move_dir() -> float: return Input.get_axis(move_l_key, move_r_key)

#func do_move(move_dir: float) -> void: npc.velocity.x = move_dir * SPEED
