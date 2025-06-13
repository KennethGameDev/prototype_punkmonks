class_name PlayerState
extends State

@onready var player: PlayerFighter = get_tree().get_first_node_in_group("Player")
@onready var stage_info: StageInfo = get_tree().get_first_node_in_group("Stage")

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity", -9.8) * 4.5

#region: Animation Names
var idle_anim: String = "Core Combat Animations/Idle"
var move_f_anim: String = "Core Combat Animations/Move Forward"
var move_b_anim: String = "Core Combat Animations/Move Backward"
var jump_u_anim: String = "Core Combat Animations/Jump Up"
var jump_uf_anim: String = "Core Combat Animations/Jump Forward"
var jump_ub_anim: String = "Core Combat Animations/Jump Back"
var crouch_anim: String = "Core Combat Animations/Crouch"
var light_atk_anims: Array[String] = [
	"Core Combat Animations/Light Attack 1",
	"Core Combat Animations/Light Attack 2",
	"Core Combat Animations/Light Attack 3"
	]
var heavy_atk_anims: Array[String] = [
	"Core Combat Animations/Heavy Attack 1",
	"Core Combat Animations/Heavy Attack 2"
	]
var special_atk_1_anim: String
var special_atk_2_anim: String
var block_anim: String
var grab_anim: String
var throw_f_anim: String
var throw_b_anim: String
var knockdown_anim: String
var get_up_anim: String
var hit_reactions: Array[String]
var win_anim: String
var lose_anim: String
#endregion

#region: Attack Animation Variables
var attack_chain_active: bool = false
var player_pressed_button: bool = false
var current_anim_frame: int = 0
var current_anim_length: int = 0
var current_anim_state: String = ""
var current_anim_active_frames_start: int = 0
var current_anim_active_frames_end: int = 0
var light_atk_anim_index: int = 0
var heavy_atk_anim_index: int = 0
#endregion

#region: States
@export_group("States")
@export var idle_state: PlayerState
@export var move_state: PlayerState
@export var jump_state: PlayerState
@export var crouch_state: PlayerState
@export var attack_state: PlayerState
#endregion

#region: State Variables
var sprite_flipped: bool = false
var forward_direction: int = 0
var attack_index: int = -1
var attack_chain: Array[String] = []
var prev_attack_chain: Array[String] = []
var last_pressed_key: String = ""
#endregion

#region: Inputs Keys
var move_l_key: String = "fight_move_l"
var move_r_key: String = "fight_move_r"
var jump_key: String = "fight_jump"
var crouch_key: String = "fight_crouch"
var light_atk_key: String = "fight_light_atk"
var heavy_atk_key: String = "fight_heavy_atk"
var special_atk_1_key: String = "fight_special_atk_1"
var special_atk_2_key: String = "fight_special_atk_2"
var block_key: String = "fight_block"
var grab_key: String = "fight_grab"
#endregion

#region: Input Actions
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
var light_attack_actions: Array = InputMap.action_get_events(light_atk_key).map(
	func(action: InputEvent) -> String:
		return action.as_text().get_slice(" (", 0))
var heavy_attack_actions: Array = InputMap.action_get_events(heavy_atk_key).map(
	func(action: InputEvent) -> String:
		return action.as_text().get_slice(" (", 0))
var special_attack_1_actions: Array = InputMap.action_get_events(special_atk_1_key).map(
	func(action: InputEvent) -> String:
		return action.as_text().get_slice(" (", 0))
var special_attack_2_actions: Array = InputMap.action_get_events(special_atk_2_key).map(
	func(action: InputEvent) -> String:
		return action.as_text().get_slice(" (", 0))
var block_actions: Array = InputMap.action_get_events(block_key).map(
	func(action: InputEvent) -> String:
		return action.as_text().get_slice(" (", 0))
var grab_actions: Array = InputMap.action_get_events(grab_key).map(
	func(action: InputEvent) -> String:
		return action.as_text().get_slice(" (", 0))
#endregion

## Base Functions
#region: Base State class function overrides
func process_input(event: InputEvent) -> State:
	if event.is_action_pressed(light_atk_key):
		last_pressed_key = light_atk_key
	elif event.is_action_pressed(heavy_atk_key):
		last_pressed_key = heavy_atk_key
	elif event.is_action_pressed(special_atk_1_key):
		last_pressed_key = special_atk_1_key
	elif event.is_action_pressed(special_atk_2_key):
		last_pressed_key = special_atk_2_key
	elif event.is_action_pressed(block_key):
		last_pressed_key = block_key
	elif event.is_action_pressed(grab_key):
		last_pressed_key = grab_key
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	player.move_and_slide()
	determine_forward_direction()
	return null

func exit(new_state: State = null) -> void:
	new_state.sprite_flipped = sprite_flipped
	new_state.forward_direction = forward_direction
	new_state.attack_index = attack_index
	new_state.attack_chain = attack_chain
	new_state.attack_chain_active = attack_chain_active
	new_state.player_pressed_button = player_pressed_button
	new_state.prev_attack_chain = prev_attack_chain
	new_state.last_pressed_key = last_pressed_key
	new_state.light_atk_anim_index = light_atk_anim_index
	new_state.heavy_atk_anim_index = heavy_atk_anim_index
	new_state.current_anim_frame = current_anim_frame
	new_state.current_anim_length = current_anim_length
	new_state.current_anim_state = current_anim_state
	new_state.current_anim_active_frames_start = current_anim_active_frames_start
	new_state.current_anim_active_frames_end = current_anim_active_frames_end
#endregion


## Utility Functions
#region Additional utility functions for the player fighter
func determine_distance_to_opponent() -> float:
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
	player.animated_sprite.set_flip_h(sprite_flipped)

func get_last_pressed_key() -> String:
	return last_pressed_key

func clear_last_pressed_key() -> void:
	last_pressed_key = ""
#endregion
