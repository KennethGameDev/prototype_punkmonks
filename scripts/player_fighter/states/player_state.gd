class_name PlayerState
extends State

@onready var player: PlayerFighter = get_tree().get_first_node_in_group("Player")
@onready var stage_info: StageInfo = get_tree().get_first_node_in_group("Stage")

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity", -9.8) * 4.5

# Animation Names
var idle_anim: String = "Idle"
var move_f_anim: String = "Walk_Forward"
var move_b_anim: String = "Walk_Backward"
var jump_u_anim: String = "Jump_Up"
var jump_uf_anim: String = "Jump_Forward"
var jump_ub_anim: String = "Jump_Backward"
var crouch_start_anim: String = "Crouch_Start"
var crouching_anim: String = "Crouch"

# States
@export_group("States")
@export var idle_state: PlayerState
@export var move_state: PlayerState
@export var jump_state: PlayerState
@export var crouch_state: PlayerState

# State Variables
var sprite_flipped: bool = false
var forward_direction: int = 0

# Inputs
var movement_keys: String = "fight_movement"
var move_l_key: String = "move_left"
var move_r_key: String = "move_right"
var jump_key: String = "fight_jump"
var crouch_key: String = "fight_crouch"

# Input Actions
var move_l_actions: Array = InputMap.action_get_events(move_l_key).map(
	func(action: InputEvent) -> String:
		return action.as_text().get_slice(" (", 0))
var move_r_actions: Array = InputMap.action_get_events(move_r_key).map(
	func(action: InputEvent) -> String:
		return action.as_text().get_slice(" (", 0))
var jump_actions: Array = InputMap.action_get_events(jump_key).map(
	func(action: InputEvent) -> String:
		return action.as_text().get_slice(" (", 0))
var crouch_actions: Array = InputMap.action_get_events(crouch_key).map(
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
	player.animations.set_flip_h(sprite_flipped)


## Base Functions

func process_physics(delta: float) -> State:
	var tex: Texture = player.animations.sprite_frames.get_frame_texture(player.animations.animation.get_basename(), 0)
	print(tex.get_height())
	player.velocity.y += gravity * delta
	player.move_and_slide()
	determine_forward_direction()
	return null

func exit(new_state: State = null) -> void:
	super()
	new_state.sprite_flipped = sprite_flipped
