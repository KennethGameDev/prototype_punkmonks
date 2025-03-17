extends Node2D

@onready var ground_tile_map: TileMapLayer = $"../GroundLayer"
@onready var structures_tile_map: TileMapLayer = $"../StructuresLayer"

func _process(_delta):
	if Input.is_action_pressed("move_forward"):
		move(Vector2.UP)
	if Input.is_action_pressed("move_back"):
		move(Vector2.DOWN)
	if Input.is_action_pressed("move_left"):
		move(Vector2.LEFT)
	if Input.is_action_pressed("move_right"):
		move(Vector2.RIGHT)

func move(direction: Vector2):
	# Get current tile Vector2i
	var current_tile: Vector2i = ground_tile_map.local_to_map(global_position)
	
	# Get target tile Vector2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	
	# Get custom data layer from the target tile
	var tile_data: TileData = ground_tile_map.get_cell_tile_data(target_tile)
	
	if tile_data.get_custom_data("walkable") == false:
		return
	
	global_position = ground_tile_map.map_to_local(target_tile)
	
	# Move player
