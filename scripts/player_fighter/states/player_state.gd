class_name PlayerState
extends State

@onready var player: PlayerFighter = get_tree().get_first_node_in_group("Player")
@onready var stage_info: StageInfo = get_tree().get_first_node_in_group("Stage")

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity", -9.8) * 2.5

# Animation Names
var idle_anim: String = "Idle"
var move_f_anim: String = "Walk_Forward"
var move_b_anim: String = "Walk_Backward"

# States
@export_group("States")
@export var idle_state: PlayerState
@export var move_state: PlayerState

# State Variables
var sprite_flipped: bool = false
var forward_direction: int = 0

# Inputs
var movement_key: String = "fight_movement"
var move_l_key: String = "move_left"
var move_r_key: String = "move_right"

# Input Actions
var move_l_actions: Array = InputMap.action_get_events(move_l_key).map(
	func(action: InputEvent) -> String:
		return action.as_text().get_slice(" (", 0))
var move_r_actions: Array = InputMap.action_get_events(move_r_key).map(
	func(action: InputEvent) -> String:
		return action.as_text().get_slice(" (", 0))


## Utility Functions

func determine_distance_to_opponent() -> float:
	var distance = stage_info.player2.position.x - player.position.x
	return distance

func determine_forward_direction() -> void:
	if determine_distance_to_opponent() < 0:
		# on the right (facing left)
		forward_direction = -1
		sprite_flipped = true
	else:
		# on the left (facing right)
		forward_direction = 1
		sprite_flipped = false
	flip_sprite()

func flip_sprite() -> void:
	player.animation.set_flip_h(sprite_flipped)


## Base Functions

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	player.move_and_slide()
	determine_forward_direction()
	return null

func exit(new_state: State = null) -> void:
	super()
	new_state.sprite_flipped = sprite_flipped
