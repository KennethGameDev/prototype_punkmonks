class_name PlayerState
extends State

@onready var player: PlayerFighter = get_tree().get_first_node_in_group("Player")

# Animation Names
var idle_anim: String = "Idle"
var move_f_anim: String = "Walk_Forward"
var move_b_anim: String = "Walk_Backward"

# States
@export_group("States")
@export var idle_state: PlayerState
@export var move_state: PlayerState

# Inputs
var movement_key: String = "fight_movement"
