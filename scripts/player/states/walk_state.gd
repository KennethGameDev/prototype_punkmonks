extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 500
@onready var obstruction_checker: ObstructionDetector = $"../../ObstructionChecker"

# Movement variables:
var direction: Vector2 # stores the input direction (Vector2)
var current_tile: Vector2i # the tile the player is currently on (Vector2i)
var target_tile: Vector2i # the tile the player is trying to move to (Vector2i)
var target_tile_location: Vector2 # the location of that tile (Vector2)
var distance_to_target: float # the distance to the target tile in pixels (float)
var allow_movement: bool = true # allows/disallows movement based on obstacles(bool)
var already_moving: bool # signals if the player is already moving or not (bool)


func _ready() -> void:
	obstruction_checker.obstruction_detected.connect(on_obstruction_detected)


func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	## Walking
	# Only update the direction and animations after the player is done
	# moving to their target tile
	if allow_movement and !already_moving:
		## Get the movement direction (4-way directional)
		direction = GameInputEvents.get_movement_direction()
		
		## Determine the walking animation to play
		if direction == Vector2.UP:
			animated_sprite_2d.play("walk_back")
			obstruction_checker.position = Vector2(0, -128)
		elif direction == Vector2.DOWN:
			animated_sprite_2d.play("walk_front")
			obstruction_checker.position = Vector2(0, 128)
		elif direction == Vector2.LEFT:
			animated_sprite_2d.play("walk_left")
			obstruction_checker.position = Vector2(-128, 0)
		elif direction == Vector2.RIGHT:
			animated_sprite_2d.play("walk_right")
			obstruction_checker.position = Vector2(128, 0)
		
		## Store the current direction in the player
		if direction != Vector2.ZERO:
			player.player_direction = direction
			# Note that this never stores 0 as a direction
			# This is useful since idling references the player's direction when
			# determining which sprite to render, meaning the player will always
			# idle facing the direction they were last moving
	
	## Use my move() function to handle the player's movement
	# Updates every game tick
	move()

## This code contains the conditions that determine how and when the state
## transitions from walking to any other
func _on_next_transitions() -> void:
	## Walking -> Idle
	# If movement input stops, transition to idle
	if !GameInputEvents.is_movement_input():
		transition.emit("Idle")
	
	## Other potential transitions:
	# Walking -> Running
	# Walking -> Talking (potential edge case)
	# Walking -> Interact (potential edge case)

## This code runs first, one time, when the state transitions into Walking
func _on_enter() -> void:
	pass

## This code runs once right before the state transitions out of Walking
func _on_exit() -> void:
	animated_sprite_2d.stop()

## Handles movement logic after the direction and animation are determined
func move() -> void:
	# Get the tile the player is currently on (Vector2i)
	current_tile = player.navigation_layer.local_to_map(player.global_position)
	
	# If the player is not already moving,
	if !already_moving:
		# Use gdscrtip's version of a switch statement to find the desired target
		# tile and move the player's obstruction checker to the correct side of the
		# player
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
				obstruction_checker.position = Vector2(0, 0)
				allow_movement = true
		# Set the target location to the location of the chosen target tile
		target_tile_location = player.navigation_layer.map_to_local(target_tile)
	# Set the distance
	distance_to_target = player.position.distance_to(target_tile_location)
	# If the player's distance to the target tile is 4 pixels or more,
	if distance_to_target >= 4 and allow_movement:
		# If yes, set already_moving to true
		already_moving = true
		# set the player's velocity and move
		player.velocity = direction * speed
		player.move_and_slide()
	# Else, the player's target distance is 4 pixels or less
	else:
		# We have reached the target location, set the player's position to the
		# center of the tile
		player.position = player.navigation_layer.map_to_local(current_tile)
		# and allow movement again
		allow_movement = true
		already_moving = false
	
	## DEBUG ##
	prints(distance_to_target)

func on_obstruction_detected() -> void:
	allow_movement = false
	obstruction_checker.position = Vector2(0, 0)
