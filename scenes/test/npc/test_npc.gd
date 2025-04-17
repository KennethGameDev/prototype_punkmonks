class_name NPC
extends CharacterBody2D

@export var navigation_layer: TileMapLayer
@export var speed: int = 450
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_detectors: Detectors = $Detectors

# the direction the npc will face on load
@export_enum("up", "down", "left", "right") var starting_direction: String
var current_tile: Vector2i # the tile the npc is currently on

func _ready() -> void:
	# Connect to the interaction signal
	
	
	# Centers the npc on the tile they're on when loading in
	current_tile = navigation_layer.local_to_map(global_position)
	position = navigation_layer.map_to_local(current_tile)
	
	# face the npc sprite towards its starting direction
	match starting_direction:
		"up":
			animated_sprite_2d.play("idle_back")
		"down":
			animated_sprite_2d.play("idle_front")
		"left":
			animated_sprite_2d.play("idle_left")
		"right":
			animated_sprite_2d.play("idle_right")


func _physics_process(_delta: float) -> void:
	pass


func handle_interaction() -> void:
	prints("Interaction with", name, "successful.")
