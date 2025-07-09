extends CharacterBody2D

@export var navigation_layer: TileMapLayer
@export var speed: int = 275
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_detectors: Detectors = $Detectors

# Dictionary containing all the player's "states"
@onready var states = {"idle": true, "move": false, "talking": false}


# Animation Variables
var current_frame: int
var current_frame_progress: float


# Movement variables:
var direction: Vector2 # stores the input direction
var idle_direction: Vector2 = Vector2.DOWN # stores the previous direction for the idle anim
var current_tile: Vector2i # the tile the player is currently on
var target_tile: Vector2i # the tile the player is trying to move to
var target_tile_location: Vector2 # the location of that tile
var distance_to_target: float # the distance to the target tile in pixels
var obstruction_detected: bool # allows/disallows movement based on obstacles
var moving_towards_target: bool # signals if the player is already moving or not


func _ready() -> void:
	# Centers the player on the tile they're on when loading in
	current_tile = navigation_layer.local_to_map(global_position)
	position = navigation_layer.map_to_local(current_tile)


func _physics_process(delta: float) -> void:
	match states:
		{"idle": true, ..}:
			idle_state(delta)
		{"move": true, ..}:
			move_state()
		{"talking": true, ..}:
			talk_state()


func transition_to_state(new_state: String) -> void:
	var valid_state: bool = false
	animated_sprite_2d.stop()
	for key in states.keys():
		if key == new_state:
			valid_state = true
			break
	if valid_state:
		for state in states:
			if state == new_state:
				states[state] = true
			else:
				states[state] = false
	else:
		push_error("Failed transitioning to ", new_state, ". State unchanged.")


func talk_state() -> void:
	print("Works so far, but needs a check for an interactable.")
	transition_to_state("idle")


var input_name: String = ""
func idle_state(delta: float) -> void:
	## Update the direction
	direction = GameInputEvents.get_movement_input()
	# For any direction:
	# update the idle_direction, and update input_name
	match direction:
		Vector2.UP:
			idle_direction = direction
			input_name = "move_forward"
		Vector2.DOWN:
			idle_direction = direction
			input_name = "move_back"
		Vector2.LEFT:
			idle_direction = direction
			input_name = "move_left"
		Vector2.RIGHT:
			idle_direction = direction
			input_name = "move_right"
	# Set current_frame and current_frame_progress
	current_frame = animated_sprite_2d.get_frame()
	current_frame_progress = animated_sprite_2d.get_frame_progress()
	# play the idle animation
	play_idle_anim(current_frame, current_frame_progress)
	## Move the interaction detector to the correct side
	set_interaction_detector_position(idle_direction)
	## Check for an interaction from the player
	if Input.is_action_just_pressed("interact"):
		print(collision_detectors.get_detector(4).get_collision_mask())
		if collision_detectors.interaction_detected == true:
			#get_interactable_type()
			pass
	
	## Transition to walking if the input is held for a short time
	if GameInputEvents.is_input_held(input_name, 0.125, delta):
		transition_to_state("move")


func play_idle_anim(frame: int, progress: float) -> void:
	## Determine the idle animation to play
	match idle_direction:
		Vector2.UP:
			animated_sprite_2d.play("idle_back")
		Vector2.DOWN:
			animated_sprite_2d.play("idle_front")
		Vector2.LEFT:
			animated_sprite_2d.play("idle_left")
		Vector2.RIGHT:
			animated_sprite_2d.play("idle_right")
	# Set the current frame and progress
	animated_sprite_2d.set_frame_and_progress(frame, progress)


func move_state() -> void:
	## Since this runs every frame, we must check to ensure we only allow
	## further movement input after the player has reached the destination tile.
	if !moving_towards_target:
		## Get the tile the player is currently standing on
		current_tile = navigation_layer.local_to_map(global_position)
		
		## Get the movement direction (4-way directional)
		direction = GameInputEvents.get_movement_input()
		
		if direction != Vector2.ZERO:
			## Record the current direction for the idle animation
			idle_direction = direction
			## Check if the desired direction is valid
			if collision_detectors.is_valid_direction(direction):
				# A "true" result means the tile is clear
				obstruction_detected = false
			else:
				# A "false" result means the tile is obstructed
				obstruction_detected = true
			## Move the interaction detector to the correct side
			set_interaction_detector_position(idle_direction)
		else:
			## Switch to the idle state
			transition_to_state("idle")
	
	# Attempt movement
	if !obstruction_detected:
		move()
	else:
		current_frame = animated_sprite_2d.get_frame()
		current_frame_progress = animated_sprite_2d.get_frame_progress()
		play_movement_anim(current_frame, current_frame_progress)


func play_movement_anim(frame: int, progress: float) -> void:
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
	# Set the current frame and progress
	animated_sprite_2d.set_frame_and_progress(frame, progress)
	
	if obstruction_detected:
		# If there's an obstruction, play animation at half-speed
		animated_sprite_2d.speed_scale = 0.5
	else:
		# Otherwise play at full-speed
		animated_sprite_2d.speed_scale = 1


## Handles movement logic after the direction and animation are determined
func move() -> void:
	## Check if the player is holding the "run" button
	if Input.is_action_pressed("run"):
		speed = 550
		animated_sprite_2d.set_speed_scale(2.0)
	else:
		speed = 275
		animated_sprite_2d.set_speed_scale(1.0)
	# If player is not already moving
	if !moving_towards_target:
		# Use gdscrtip's version of a switch statement to find the desired target
		# tile
		if direction != Vector2.ZERO:
			match direction:
				Vector2.UP:
					target_tile = navigation_layer.get_neighbor_cell(current_tile, TileSet.CELL_NEIGHBOR_TOP_SIDE)
				Vector2.DOWN:
					target_tile = navigation_layer.get_neighbor_cell(current_tile, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
				Vector2.RIGHT:
					target_tile = navigation_layer.get_neighbor_cell(current_tile, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
				Vector2.LEFT:
					target_tile = navigation_layer.get_neighbor_cell(current_tile, TileSet.CELL_NEIGHBOR_LEFT_SIDE)
			# Set the target location to the location of the chosen target tile
			target_tile_location = navigation_layer.map_to_local(target_tile)
			# Set the distance
			distance_to_target = position.distance_to(target_tile_location)
			# Set the player's velocity
			velocity = direction * speed
			# Set moving_towards_target to true
			moving_towards_target = true
			# Set current_frame and current_frame_progress
			current_frame = animated_sprite_2d.get_frame()
			current_frame_progress = animated_sprite_2d.get_frame_progress()
			# Play the walking animation
			play_movement_anim(current_frame, current_frame_progress)
	# If the player is moving,
	else:
		# Update the distance
		distance_to_target = position.distance_to(target_tile_location)
		# If the player has not reached the target point,
		if distance_to_target > 8:
			# move and slide
			move_and_slide()
		# Else, the player's target distance is 8 pixels or less
		else:
			# We have reached the target location, set the player's position to the
			# center of the tile
			position = navigation_layer.map_to_local(target_tile)
			# reset velocity
			velocity = Vector2.ZERO
			# and allow movement again
			if moving_towards_target:
				moving_towards_target = false


## Set the Interaction Detector's relative position given the player's direction
func set_interaction_detector_position(interact_direction: Vector2) -> void:
	var interact_detector: Area2D = collision_detectors.get_detector(4)
	match interact_direction:
		Vector2.UP:
			interact_detector.position = Vector2(0, -128)
		Vector2.DOWN:
			interact_detector.position = Vector2(0, 128)
		Vector2.LEFT:
			interact_detector.position = Vector2(-128, 0)
		Vector2.RIGHT:
			interact_detector.position = Vector2(128, 0)


#func get_interactable_type() -> 
