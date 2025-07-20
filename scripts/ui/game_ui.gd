class_name GameUI
extends Control

var current_level_name: String = ""
var active_hud: int = -1
var go_back_list: Array
var start_in_main_menu: bool = true
var current_menu: int = -1
# 0: Overworld UI
# 1: Fighting UI
# 2: Main Menu
# 3: VS Mode Menu
# 4: Pause Screen
# 5: Settings
# 6: Character Select Screen (VS Mode)
# 7: Controller Disconnected Screen
signal on_paused_game_pressed(level_name: String)
signal update_disconnect_screen(player_index: int)

func _ready() -> void:
	pass

# Counts up as long as the pause button is pressed down during gameplay
# and resets after the button is released. This prevents the pause menu
# from closing instantly after the player releases the button that opened it.
var button_counter: float = 0
func _physics_process(delta: float) -> void:
	## Pressing the Pause button ##
	# Pressing the Pause button in game (activates on press)
	if current_menu <= 1:
		if Input.is_action_just_pressed("pause"):
			# Button counter becomes > 0
			button_counter += delta
			pause_game_pressed()
	# Pressing the Pause button in the Menu (activates on release)
	else:
		if Input.is_action_just_released("pause"):
			if button_counter == 0: # Block the release action that fires after opening the menu
				# If the Main Menu is open
				if current_menu == 2:
					on_quit_game_button_released()
				# If the Pause Screen is open
				elif current_menu == 4:
					pause_game_pressed()
				# If the Settings Page is open
				elif current_menu == 5:
					swap_menu_to_previous()
			else: # Use that blocked release action to clear the counter so the next release action can be processed normally
				button_counter = 0
	pass

func pause_game_pressed() -> void:
	if !get_tree().paused:
		emit_signal("on_paused_game_pressed", current_level_name)
		get_tree().paused = true
		swap_menu_request(4, current_menu)
	else:
		get_tree().paused = false
		button_counter = 0
		swap_menu_request(active_hud, current_menu)

func on_stage_set_current_level_info() -> void:
	#current_level_name = level_name
	#start_in_main_menu = menu_start
	
	# Fallback to Main Menu if no level is found
	if current_level_name == "":
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
		if current_level_name == "TestOverworld":
			swap_menu_request(2, current_menu)
		if current_level_name == "Stage":
			swap_menu_request(3, current_menu)

func swap_menu_to_previous() -> void:
	if go_back_list.is_empty():
		return
	
	if current_menu >= 2:
		get_child(current_menu).visible = false
	swap_menu_request(go_back_list[go_back_list.size() - 1], -1)
	go_back_list.pop_back()

func on_swap_scene(new_scene: PackedScene) -> void:
	game_started_once = false
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

func on_controller_connected() -> void:
	pass

func on_controller_disconnected(player_index: int) -> void:
	emit_signal("update_disconnect_screen", player_index)
	swap_menu_request(7, current_menu)
	get_tree().paused = true
	
func on_controller_reconnected() -> void:
	swap_menu_request(4, current_menu)
