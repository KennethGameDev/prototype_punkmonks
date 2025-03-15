extends CharacterBody3D

@export var speed = 0.15
var target_velocity = Vector3.ZERO

func _process(_delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot/AnimatedSprite3D.play()
	if direction == Vector3.ZERO:
		$Pivot/AnimatedSprite3D.stop()
		$Pivot/AnimatedSprite3D.set_frame(0)
	
	target_velocity.x = direction.x * speed
	target_velocity.z = (direction.z * speed) * 1.275
	
	velocity = target_velocity
	move_and_slide()
