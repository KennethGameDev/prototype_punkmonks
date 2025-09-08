class_name TileMapManager
extends Node2D

# TODO: These functions should be called by the level itself, depending on the player's elevation
# TODO: This class should be responsible for all effects that need to be applied to individual tile map layers,
#		such as: changing their scale, moving them around, applying effects like blur and darken, and maybe more custom effects later
# TODO: A function that takes in a layer index, and a decimal 0-N, and gradually brings the scale of that layer to the number provided
# TODO: A function that takes in a layer index, a Vector2D direction, and a speed, and gradually moves the layer in that direction at speed as long as the function is being called
# TODO: A function that can apply a shader(?) that can gradually darken a selected layer
# TODO: Any additional effects we need/want later

func _ready() -> void:
	for elevation_level: Node2D in get_children():
		for tile_map_layer: TileMapLayer in elevation_level.get_children():
			# TODO: If the player's current elevation is equal to the layer's, disable ground collision for those layers
			if elevation_level.name == "Elevation 01":
				tile_map_layer.collision_enabled = false
			pass
