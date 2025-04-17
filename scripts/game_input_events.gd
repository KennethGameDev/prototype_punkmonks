class_name GameInputEvents

static var direction: Vector2

## The 'primary movement axis' determines which movement axis (horizontal or
## vertical) the player must be moving in. It is set when the player presses any
## movement input and it is later used when handling the case where two
## opposing digital inputs are being held. Works in a top-down, 2D game that
## restricts movement to up, down, left, and right
# No Moving: -1
# Horizontal Movement: 0
# Vertical Movement: 1
static var primary_movement_axis: int = -1


static func get_movement_input() -> Vector2:	
	## Get input direction (includes diagonal movement)
	direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	## Filter out diagonals
	# The player is trying to move horizontally
	if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		# Check if they're starting from a standstill
		if primary_movement_axis == -1:
			# If yes, set the primary axis to 0 for horizontal movement
			primary_movement_axis = 0
		# If they're already moving, set direction's vertical component to 0
		# (It doesn't matter what axis we check here since pressing the other
		# horizontal input would make the player stop moving, which is natural)
		else:
			direction.y = 0
	# The player is trying to move vertically
	elif Input.is_action_pressed("move_forward") || Input.is_action_pressed("move_back"):
		# Check if they're starting from a standstill
		if primary_movement_axis == -1:
			# If yes, set the primary axis to 1 for vertical movement
			primary_movement_axis = 1
		# If they're already moving, set direction's horizontal component to 0
		# (It doesn't matter what axis we check here since pressing the other
		# vertical input would make the player stop moving, which is natural)
		else:
			direction.x = 0
	# The player is standing still (not pressing any direction)
	else:
		# Primary axis becomes -1 for not moving and direction is zeroed out
		primary_movement_axis = -1
		direction = Vector2.ZERO
	
	## Handle simultaneous digital input direction part 1
	## Horizontal -> Vertical
	# If the primary axis is currently horizontal,
	# check for simultaneous movement on the vertical axis
	if primary_movement_axis == 0:
		if Input.is_action_pressed("move_forward"):
			direction.y = -1.0
			direction.x = 0
			# Check if the player releases the input for the primary axis
			if Input.is_action_just_released("move_right") || Input.is_action_just_released("move_left"):
				primary_movement_axis = 1
		elif Input.is_action_pressed("move_back"):
			direction.y = 1.0
			direction.x = 0
			# Check if the player releases the input for the primary axis
			if Input.is_action_just_released("move_right") || Input.is_action_just_released("move_left"):
				primary_movement_axis = 1
	
	## Handle simultaneous digital input direction part 2
	## Vertical -> Horizontal
	# If the primary axis is currently vertical,
	# check for simultaneous movement on the horizontal axis
	if primary_movement_axis == 1:
		if Input.is_action_pressed("move_right"):
			direction.x = 1.0
			direction.y = 0
			# Check if the player releases the input for the primary axis
			if Input.is_action_just_released("move_forward") || Input.is_action_just_released("move_back"):
				primary_movement_axis = 0
		elif Input.is_action_pressed("move_left"):
			direction.x = -1.0
			direction.y = 0
			# Check if the player releases the input for the primary axis
			if Input.is_action_just_released("move_forward") || Input.is_action_just_released("move_back"):
				primary_movement_axis = 0
	
	# Normalize the direction vector (set the vector's length to 1)
	direction = direction.normalized()
	
	return direction

static func is_movement_input() -> bool:
	if direction == Vector2.ZERO:
		return false
	else:
		return true

static func get_primary_movement_axis() -> String:
	var result: String
	
	match primary_movement_axis:
		0:
			result = "Horizontal"
		1:
			result = "Vertical"
		_:
			result = "Not Moving"
	
	return result


static var elapsed_time: float = 0
static var previous_input_name: String = ""
static func is_input_held(input_name: String, seconds_to_hold: float, delta: float) -> bool:
	if previous_input_name != input_name:
		elapsed_time = 0
	if input_name != "":
		previous_input_name = input_name
		if Input.is_action_pressed(input_name):
			elapsed_time += delta
		else:
			elapsed_time = 0
		if elapsed_time >= seconds_to_hold:
			elapsed_time = 0
			return true
	return false
