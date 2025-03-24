class_name GameInputEvents

static var direction: Vector2
# Horizontal Movement: 0
# Vertical Movement: 1
# Neither: -1
static var primary_movement_axis: int = -1

static func movement_input() -> Vector2:
	#if Input.is_action_pressed("move_left"):
		#direction = Vector2.LEFT
	#elif Input.is_action_pressed("move_right"):
		#direction = Vector2.RIGHT
	#elif Input.is_action_pressed("move_forward"):
		#direction = Vector2.UP
	#elif Input.is_action_pressed("move_back"):
		#direction = Vector2.DOWN
	#else:
		#direction = Vector2.ZERO
	
	# Get input direction (includes diagonal movement)
	direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# The player is trying to move horizontally
	if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		# Check if they're already moving along an axis
		if primary_movement_axis == -1:
			# If no, set the primary axis to 0 for horizontal movement
			primary_movement_axis = 0
		else:
			direction.y = 0
	elif Input.is_action_pressed("move_forward") || Input.is_action_pressed("move_back"):
		# Check if they're already moving along an axis
		if primary_movement_axis == -1:
			# If no, set the primary axis to 1 for vertical movement
			primary_movement_axis = 1
		else:
			direction.x = 0
	else:
		primary_movement_axis = -1
		direction = Vector2.ZERO
	
	## If the primary axis is currently horizontal,
	## check for simultaneous movement on the vertical axis
	#if primary_movement_axis == 0:
		#if Input.is_action_pressed("move_forward"):
			#direction.y = -1.0
			#direction.x = 0
		#elif Input.is_action_pressed("move_back"):
			#direction.y = 1.0
			#direction.x = 0
		## Check if the player releases the input for the primary axis
		#if Input.is_action_just_released("move_right") || Input.is_action_just_released("move_left"):
			#primary_movement_axis = 1
	
	#if primary_movement_axis == 1:
		#if Input.is_action_pressed("move_right"):
			#primary_movement_axis = 0
			#direction.x = 1.0
			#direction.y = 0
		#elif Input.is_action_pressed("move_left"):
			#primary_movement_axis = 0
			#direction.x = -1.0
			#direction.y = 0
	
	direction = direction.normalized()
	prints(direction)
	
	return direction


static func is_movement_input() -> bool:
	if direction == Vector2.ZERO:
		return false
	else:
		return true


static func check_simulatneous_movement() -> String:
	var result: String
	
	if direction == Vector2.ZERO:
		result = "null"
		
	
	return result


#static func get_primary_movement_axis() -> int:
	#var result: int
	#
	#if direction != Vector2.ZERO:
		#if direction == Vector2.UP || direction == Vector2.DOWN:
			#result = 1
		#elif direction == Vector2.LEFT || direction == Vector2.RIGHT:
			#result = 0
		#else:
			#result = -1
	#else:
		#result = -1
	#
	#return result
