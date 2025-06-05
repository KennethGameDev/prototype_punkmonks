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
var light_atk_anims: Array[String] = ["Light_Atk_1", "Light_Atk_2", "Light_Atk_3"]
var heavy_atk_anims: Array[String] = ["Heavy_Atk_1", "Heavy_Atk_2"]

# States
@export_group("States")
@export var idle_state: PlayerState
@export var move_state: PlayerState
@export var jump_state: PlayerState
@export var crouch_state: PlayerState
@export var attack_state: PlayerState

# State Variables
var sprite_flipped: bool = false
var forward_direction: int = 0
var attack_buffer: Array[String]

# Inputs Keys
var move_l_key: String = "fight_move_l"
var move_r_key: String = "fight_move_r"
var jump_key: String = "fight_jump"
var crouch_key: String = "fight_crouch"
var light_atk_key: String = "fight_light_atk"
var heavy_atk_key: String = "fight_heavy_atk"

#region Input Actions
var move_l_actions: Array = InputMap.action_get_events(move_l_key).map(
	func(action: InputEvent) -> InputEventAction: return action)
		#return action.as_text().get_slice(" (", 0))
var move_r_actions: Array = InputMap.action_get_events(move_r_key).map(
	func(action: InputEvent) -> InputEventAction: return action)
		#return action.as_text().get_slice(" (", 0))
var jump_actions: Array = InputMap.action_get_events(jump_key).map(
	func(action: InputEvent) -> InputEventAction: return action)
		#return action.as_text().get_slice(" (", 0))
var crouch_actions: Array = InputMap.action_get_events(crouch_key).map(
	func(action: InputEvent) -> InputEventAction: return action)
		#return action.as_text().get_slice(" (", 0))
var light_attack_actions: Array = InputMap.action_get_events(light_atk_key).map(
	func(action: InputEvent) -> InputEventAction: return action)
		#return action.as_text().get_slice(" (", 0))
var heavy_attack_actions: Array = InputMap.action_get_events(heavy_atk_key).map(
	func(action: InputEvent) -> InputEventAction: return action)
		#return action.as_text().get_slice(" (", 0))



## Utility Functions
#region Addition utility functions for the player fighter
func determine_distance_to_opponent() -> float:
	print(stage_info.player2.position.x - player.position.x)
	return stage_info.player2.position.x - player.position.x

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

func ground_sprite() -> void:
	var sprite: Texture = player.animations.sprite_frames.get_frame_texture(player.animations.animation.get_basename(), 0)
	var sprite_height: int = sprite.get_height() * 7
	#print(player.animations.position.y)
	player.animations.position.y = (sprite_height / 2.0) * -1

func add_to_input_buffer(input_key: String) -> void:
	attack_buffer.append(input_key)

func clear_input_buffer() -> void:
	attack_buffer.clear()

func get_next_buffered_input() -> String:
	var next_input: String = ""
	next_input = attack_buffer.pop_front()
	return next_input

func get_current_input_buffer() -> Array[String]:
	return attack_buffer
#endregion


## Base Functions
#region Base State class function overrides
func process_frame(_delta: float) -> State:
	ground_sprite()
	return null

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	player.move_and_slide()
	determine_forward_direction()
	return null

func exit(new_state: State = null) -> void:
	super()
	new_state.sprite_flipped = sprite_flipped
#endregion
