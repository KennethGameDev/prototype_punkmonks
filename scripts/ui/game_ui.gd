class_name GameUI
extends Control

var current_level_name: String = ""
var active_hud: int = -1
var go_back_list: Array
var current_menu: int = -1
var start_in_main_menu: bool = true
signal on_paused_game_pressed(level_name: String)

func _ready() -> void:
	pass

var button_counter: float = 0
func _physics_process(delta: float) -> void:
	# In-Game HUDs
	if current_menu == 0 or current_menu == 1:
		if Input.is_action_just_pressed("menu_back"):
			button_counter += delta
			pause_game_pressed()
	# Menu screens
	elif current_menu >= 2:
		if Input.is_action_just_released("menu_back"):
			if button_counter == 0:
				# Main Menu
				if current_menu == 2:
					on_quit_game_button_released()
				# Main Menu Settings Page and Pause Screen Settings Page
				elif current_menu == 3 or current_menu == 5:
					swap_menu_to_previous()
				# Pause Screen
				elif current_menu == 4:
					pause_game_pressed()
			else:
				button_counter = 0

func pause_game_pressed() -> void:
	if !get_tree().paused:
		emit_signal("on_paused_game_pressed", current_level_name)
		get_tree().paused = true
		swap_menu_request(4, current_menu)
	else:
		get_tree().paused = false
		swap_menu_request(active_hud, current_menu)

func set_current_level_info(level_name: String, menu_start: bool) -> void:
	current_level_name = level_name
	start_in_main_menu = menu_start
	
	if current_level_name == "":
		# Fallback to Main Menu if no level is found
		active_hud = 2
	
	if current_level_name == "TestOverworld":
		active_hud = 0
	
	if current_level_name == "Stage":
		active_hud = 1
	
	swap_menu_request(active_hud, current_menu)

func start_singleplayer_request(singleplayer_scene: PackedScene) -> void:
	if current_level_name == "TestOverworld":
		get_tree().paused = false
		swap_menu_request(0, current_menu)
	else:
		on_swap_scene(singleplayer_scene)

func start_vs_mode_request(vs_mode_scene: PackedScene) -> void:
	if current_level_name == "Stage":
		get_tree().paused = false
		swap_menu_request(1, current_menu)
	else:
		on_swap_scene(vs_mode_scene)

var game_started_once: bool = false
func swap_menu_request(menu_index: int, return_index: int) -> void:
	if menu_index >= get_child_count() or menu_index < 0:
		return
	
	current_menu = menu_index
	
	var child = get_child(current_menu)
	child.visible = true
	
	if return_index >= 0:
		go_back_list.append(return_index)
		if return_index >= 2:
			get_child(return_index).visible = false
	
	if start_in_main_menu and !game_started_once:
		game_started_once = true
		swap_menu_request(2, current_menu)

func swap_menu_to_previous() -> void:
	if go_back_list.is_empty():
		return
	
	if current_menu >= 2:
		get_child(current_menu).visible = false
	swap_menu_request(go_back_list[go_back_list.size() - 1], -1)
	go_back_list.pop_back()

func on_swap_scene(new_scene: PackedScene) -> void:
	get_tree().paused = start_in_main_menu
	get_tree().root.get_child(0).queue_free()
	get_tree().root.add_child(new_scene.instantiate())
	queue_free()

func on_switch_game_mode(game_mode_1: PackedScene, game_mode_2: PackedScene) -> void:
	if game_mode_1.resource_name == current_level_name:
		on_swap_scene(game_mode_2)
	
	if game_mode_2.resource_name == current_level_name:
		on_swap_scene(game_mode_1)

func on_quit_game_button_released() -> void:
	get_tree().quit()
