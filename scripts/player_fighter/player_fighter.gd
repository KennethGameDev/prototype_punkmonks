class_name PlayerFighter
extends CharacterBody2D

@onready var stage = get_tree().get_first_node_in_group("Stage")
@onready var sprite_root: Node2D = $SpriteRoot
@onready var animated_sprite: AnimatedSprite2D = $SpriteRoot/RYU
@onready var animations: AnimationPlayer = $SpriteRoot/RYU/AnimationPlayer

var player_id: int
var device: int
var state_machine_scene: PackedScene = preload("res://scenes/MVP/state_machine.tscn")
var state_machine: StateMachine
var input_map: Dictionary
var opponent: PlayerFighter
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity", -9.8) * 3
var sprite_flipped: bool = false
var forward_direction: int = 0
var last_pressed_key: String = ""
var attack_index: int = -1
var attack_chain: Array[String] = []
var prev_attack_chain: Array[String] = []

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

#region: Inputs Keys
var move_l_key: String
var move_r_key: String
var jump_key: String
var crouch_key: String
var light_atk_key: String
var heavy_atk_key: String
var special_atk_1_key: String
var special_atk_2_key: String
var block_key: String
var grab_key: String
#endregion

var single_input: bool = false

func _ready():
	move_l_key = input_map.keys()[0]
	move_r_key = input_map.keys()[1]
	jump_key = input_map.keys()[2]
	crouch_key = input_map.keys()[3]
	
	state_machine = state_machine_scene.instantiate()
	state_machine.state_machine_owner = self
	state_machine.state_machine_owner_id = player_id
	state_machine.default_starting_state = "S_Idle"
	add_child(state_machine)

func _input(event):
	if event is not InputEventMouse:
		if event is not InputEventJoypadMotion:
			if event.device == player_id:
				#if event.is_action_pressed(move_l_key):
					#last_pressed_key = move_l_key
				#elif event.is_action_pressed(move_r_key):
					#last_pressed_key = move_r_key
				#elif event.is_action_pressed(jump_key):
					#last_pressed_key = jump_key
				#elif event.is_action_pressed(crouch_key):
					#last_pressed_key = crouch_key
				#elif event.is_action_pressed(grab_key):
					#last_pressed_key = grab_key
				#elif event.is_action_pressed(light_atk_key):
					#last_pressed_key = light_atk_key
				#elif event.is_action_pressed(heavy_atk_key):
					#last_pressed_key = heavy_atk_key
				#elif event.is_action_pressed(special_atk_1_key):
					#last_pressed_key = special_atk_1_key
				#elif event.is_action_pressed(special_atk_2_key):
					#last_pressed_key = special_atk_2_key
				state_machine.process_input(event, player_id)

func _process(delta): state_machine.process_frame(delta, player_id)

func _physics_process(delta):
	velocity.y += gravity * delta
	determine_forward_direction()
	move_and_slide()
	state_machine.process_physics(delta, player_id)


## Utility Functions
#region Additional utility functions for the player fighter
func determine_forward_direction() -> void:
	if stage.calc_distance_between_fighters() > 0:
		# player 1 is on the left
		if player_id == 0:
			forward_direction = -1
			sprite_flipped = true
		# and player 2 is on the right
		elif player_id == 1:
			forward_direction = 1
			sprite_flipped = false
	else:
		# player 1 is on the right
		if player_id == 0:
			forward_direction = 1
			sprite_flipped = false
		# and player 2 is on the left
		elif player_id == 1:
			forward_direction = -1
			sprite_flipped = true
	if is_on_floor():
		flip_sprite()

func flip_sprite() -> void:
	animated_sprite.set_flip_h(sprite_flipped)

func get_last_pressed_key() -> String:
	return last_pressed_key

func clear_last_pressed_key() -> void:
	last_pressed_key = ""

func set_player_id(id: int) -> void:
	player_id = id

func add_to_attack_chain(anim_name: String) -> void:
	prev_attack_chain = attack_chain
	attack_index += 1
	if anim_name.contains("Light Attack"):
		if light_atk_anim_index + 1 < light_atk_anims.size():
			light_atk_anim_index += 1
		else:
			light_atk_anim_index = 0
	elif anim_name.contains("Heavy Attack"):
		if heavy_atk_anim_index + 1 < heavy_atk_anims.size():
			heavy_atk_anim_index += 1
		else:
			heavy_atk_anim_index = 0
	attack_chain.append(anim_name)

func clear_attack_chain() -> void:
	attack_index = -1
	attack_chain.clear()

func is_light_attack_anim_playing() -> bool:
	if animations.current_animation.get_basename() == light_atk_anims[0] or animations.current_animation.get_basename() == light_atk_anims[1] or animations.current_animation.get_basename() == light_atk_anims[2]:
		if animations.current_animation_position < animations.current_animation_length and animations.current_animation_position >= 0:
			return true
		else:
			return false
	else:
		return false

func is_heavy_attack_anim_playing() -> bool:
	if animations.current_animation.get_basename() == heavy_atk_anims[0] or animations.current_animation.get_basename() == heavy_atk_anims[1]:
		if animations.current_animation_position < animations.current_animation_length and animations.current_animation_position >= 0:
			return true
		else:
			return false
	else:
		return false
#endregion

## Animaiton Finctions
#region Animation Functions. Called by 'method call tracks' within the animation
func set_current_animation_frame(frame: int) -> void:
	current_anim_frame = frame

func set_current_animation_frame_info(number_of_frames: int, active_frame_start: int, active_frame_end: int) -> void:
	current_anim_length = number_of_frames
	current_anim_active_frames_start = active_frame_start
	current_anim_active_frames_end = active_frame_end

func set_current_animation_state(current_state: String) -> void:
	current_anim_state = current_state
#endregion
