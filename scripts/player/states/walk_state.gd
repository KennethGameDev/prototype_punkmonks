extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 500

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()
	
	if direction == Vector2.UP:
		animated_sprite_2d.play("walk_back")
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("walk_front")
	elif direction == Vector2.LEFT:
		animated_sprite_2d.play("walk_left")
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("walk_right")
	
	if direction != Vector2.ZERO:
		player.player_direction = direction
	
	#move(direction)
	player.velocity = direction * speed
	player.move_and_slide()


func _on_next_transitions() -> void:
	if !GameInputEvents.is_movement_input():
		transition.emit("Idle")


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite_2d.stop()


#func move(direction: Vector2):
	## Get the tile the player is currently on (Vector2i)
	#var current_tile: Vector2i = walkability_layer.local_to_map(player.global_position)
	#
	## Get the tile the player is trying to move to (Vector2i)
	#var target_tile: Vector2i = Vector2i(
		#current_tile.x + direction.x,
		#current_tile.y + direction.y
	#)
	#prints(current_tile, target_tile)
	
