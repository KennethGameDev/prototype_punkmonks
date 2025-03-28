class_name Player
extends CharacterBody2D

var player_direction: Vector2
@export var navigation_layer: TileMapLayer

func _ready() -> void:
	# Centers the player on the tile they're on when loading in
	var current_tile: Vector2i = navigation_layer.local_to_map(global_position)
	position = navigation_layer.map_to_local(current_tile)
