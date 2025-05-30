class_name NPCState
extends State

@onready var npc: NPCFighter = get_tree().get_first_node_in_group("NPC")

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity", -9.8) * 2.5

# Animation Names
var idle_anim: String = "Idle"
var move_f_anim: String = "Walk_Forward"
var move_b_anim: String = "Walk_Backward"

# States
@export_group("States")
@export var idle_state: NPCState
@export var move_state: NPCState

# Inputs
#var movement_key: String = "fight_movement"
#var move_l_key: String = "move_left"
#var move_r_key: String = "move_right"

## Base Functions

func process_physics(delta: float) -> State:
	npc.velocity.y += gravity * delta
	npc.move_and_slide()
	return null
