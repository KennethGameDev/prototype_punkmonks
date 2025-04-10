extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 450
@onready var collision_detectors: Array[Detector] = [$"../../ExtenededCollisionDetectors/North", $"../../ExtenededCollisionDetectors/South", $"../../ExtenededCollisionDetectors/East", $"../../ExtenededCollisionDetectors/West"]

# Movement variables:
var direction: Vector2 # stores the input direction
var current_tile: Vector2i # the tile the player is currently on
var target_tile: Vector2i # the tile the player is trying to move to
var target_tile_location: Vector2 # the location of that tile
var distance_to_target: float # the distance to the target tile in pixels
var obstruction_detected: bool # allows/disallows movement based on obstacles
var moving_towards_target: bool # signals if the player is already moving or not
var blocked_directions: Array[bool] # tracks which directions are currently invalid


func _ready() -> void:
	for detector in collision_detectors:
		detector.collision_detected.connect(on_adjacent_collision_detected)
		detector.no_collision_detected.connect(on_adjacent_collision_exit_detection)
	pass


func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	## Only set the movement direction if the player isn't already moving,
	# and if the target tile is clear
	#if !moving_towards_target:
		
	if !obstruction_detected:
		set_movement_direction()
	# The player is auto-walking to the target tile,
	if moving_towards_target:
		# clear the movement direction
		if direction != Vector2.ZERO:
			direction = Vector2.ZERO
	
	## Use my move() function to handle the player's movement
	move() # Updates every game tick

## This code contains the conditions that determine how and when the state
## transitions from walking to any other
func _on_next_transitions() -> void:
	## Walking -> Idle
	# If movement input stops, transition to idle
	if !GameInputEvents.is_movement_input():
		transition.emit("Idle")
		print("Transitioning from Walking to Idle...")
	
	## Other potential transitions:
	# Walking -> Running
	# Walking -> Talking (potential edge case)
	# Walking -> Interact (potential edge case)

## This code runs first, one time, when the state transitions into Walking
func _on_enter() -> void:
	print("Transitioned from Idle to Walking.")
	#pass

## This code runs once right before the state transitions out of Walking
func _on_exit() -> void:
	animated_sprite_2d.stop()

func set_movement_direction() -> void:
	## Get the movement direction (4-way directional)
	direction = GameInputEvents.get_movement_direction()
	
	## Determine the walking animation to play
	match direction:
		Vector2.UP:
			animated_sprite_2d.play("walk_back")
		Vector2.DOWN:
			animated_sprite_2d.play("walk_front")
		Vector2.LEFT:
			animated_sprite_2d.play("walk_left")
		Vector2.RIGHT:
			animated_sprite_2d.play("walk_right")
	
	## Store the current direction in the player
	if direction != Vector2.ZERO:
		player.player_direction = direction
		# Note that this never stores 0 as the player's direction
		# This is useful since idling references the player's direction when
		# determining which sprite to render, meaning the player will always
		# idle facing the direction they were last moving

## Handles movement logic after the direction and animation are determined
func move() -> void:
	# Get the tile the player is currently on (Vector2i)
	current_tile = player.navigation_layer.local_to_map(player.global_position)
	
	# If the player is not already moving,
	if !moving_towards_target:
		# Use gdscrtip's version of a switch statement to find the desired target
		# tile
		match direction:
			Vector2.UP:
				target_tile = player.navigation_layer.get_neighbor_cell(current_tile, TileSet.CELL_NEIGHBOR_TOP_SIDE)
			Vector2.DOWN:
				target_tile = player.navigation_layer.get_neighbor_cell(current_tile, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
			Vector2.RIGHT:
				target_tile = player.navigation_layer.get_neighbor_cell(current_tile, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
			Vector2.LEFT:
				target_tile = player.navigation_layer.get_neighbor_cell(current_tile, TileSet.CELL_NEIGHBOR_LEFT_SIDE)
			Vector2.ZERO:
				target_tile = current_tile
		# Set the target location to the location of the chosen target tile
		target_tile_location = player.navigation_layer.map_to_local(target_tile)
		# Set the distance
		distance_to_target = player.position.distance_to(target_tile_location)
		# Set the player's velocity
		player.velocity = direction * speed
		# Set moving_towards_target to true
		moving_towards_target = true
	# If the player is moving,
	else:
		# Update the distance
		distance_to_target = player.position.distance_to(target_tile_location)
	# If the player has not reached the target point,
	if distance_to_target > 8:
		# move and slide
		player.move_and_slide()
	# Else, the player's target distance is 8 pixels or less
	else:
		# We have reached the target location, set the player's position to the
		# center of the tile
		player.position = player.navigation_layer.map_to_local(current_tile)
		# and allow movement again
		if obstruction_detected:
			obstruction_detected = false
		if moving_towards_target:
			moving_towards_target = false
	
	#check_for_obstructions()
	
	## DEBUG ##
	#if !moving_towards_target:
	print(distance_to_target)

func on_adjacent_collision_detected(collider_label: StringName) -> Array[bool]:
	print("Attempt Collision Detected")
	match collider_label:
		"North":
			blocked_directions[0] = true
			print("Collision detected North")
		"Shouth":
			blocked_directions[1] = true
			print("Collision detected South")
		"East":
			blocked_directions[2] = true
			print("Collision detected East")
		"West":
			blocked_directions[3] = true
			print("Collision detected West")
	
	return blocked_directions

func on_adjacent_collision_exit_detection(collider_label: StringName) -> Array[bool]:
	print("Attempt Collision no longer Detected")
	match collider_label:
		"North":
			blocked_directions[0] = false
			print("Collision no longer detected North")
		"Shouth":
			blocked_directions[1] = false
			print("Collision no longer detected South")
		"East":
			blocked_directions[2] = false
			print("Collision no longer detected East")
		"West":
			blocked_directions[3] = false
			print("Collision no longer detected West")
	
	return blocked_directions


#func check_for_obstructions() -> void:
	#obstruction_detected = detector.obstruction_detected

#func on_obstruction_detected() -> void:
	#obstruction_detected = true
	#moving_towards_target = false
	#obstruction_checker.position = Vector2(0, 0)


#func _on_obstruction_checker_area_entered(_area: Area2D) -> void:
	#obstruction_detected = true
	#moving_towards_target = false
	#print("_on_obstruction_checker_area_entered from walk_state.gd")
#
#
#func _on_obstruction_checker_body_entered(_body: Node2D) -> void:
	#obstruction_detected = true
	#moving_towards_target = false
	#print("_on_obstruction_checker_body_entered from walk_state.gd")
