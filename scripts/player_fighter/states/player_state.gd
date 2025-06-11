class_name PlayerState
extends State

@onready var player: PlayerFighter = get_tree().get_first_node_in_group("Player")
@onready var stage_info: StageInfo = get_tree().get_first_node_in_group("Stage")

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity", -9.8) * 4.5

# Animation Names
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

# States
@export_group("States")
@export var idle_state: PlayerState
@export var move_state: PlayerState
@export var jump_state: PlayerState
@export var crouch_state: PlayerState
@export var light_attack_state: PlayerState
@export var heavy_attack_state: PlayerState

# State Variables
var sprite_flipped: bool = false
var forward_direction: int = 0
var attack_index: int = 0
var attack_queue: Array[String] = []
var prev_attack_queue: Array[String] = []

# Inputs Keys
var move_l_key: String = "fight_move_l"
var move_r_key: String = "fight_move_r"
var jump_key: String = "fight_jump"
var crouch_key: String = "fight_crouch"
var light_atk_key: String = "fight_light_atk"
var heavy_atk_key: String = "fight_heavy_atk"

#region Input Actions
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
#endregion



## Utility Functions
#region Addition utility functions for the player fighter
func determine_distance_to_opponent() -> float:
	#print(stage_info.player2.position.x - player.position.x)
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

func ground_sprite() -> void:
	var sprite: Texture = player.animated_sprite.sprite_frames.get_frame_texture(player.animated_sprite.animation.get_basename(), 0)
	var sprite_height: int = sprite.get_height() * 7
	player.animated_sprite.position.y = (sprite_height / 2.0) * -1

func add_to_attack_queue(anim_name: String) -> void:
	prev_attack_queue = attack_queue
	prints("Previous:", prev_attack_queue)
	attack_index += 1
	attack_queue.append(anim_name)

func clear_attack_queue() -> void:
	attack_index = 0
	attack_queue.clear()

func get_next_queued_attack() -> String:
	return attack_queue.back()

func get_current_attack_queue() -> Array[String]:
	return attack_queue

func get_prev_attack_queue() -> Array[String]:
	return prev_attack_queue

func compare_queues() -> bool:
	return prev_attack_queue == attack_queue
#endregion


## Base Functions
#region Base State class function overrides
func process_input(event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	#ground_sprite()
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
