extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var auto_interactable_component: AutoInteractableComponent = $AutoInteractableComponent


func _ready() -> void:
	auto_interactable_component.auto_interactable_activated.connect(on_interactable_activated)
	auto_interactable_component.auto_interactable_deactivated.connect(on_interactable_deactivated)
	collision_layer = 1

func on_interactable_activated() -> void:
	# Play opening animation
	animated_sprite_2d.play("open_door")
	collision_layer = 2
	#prints("activated")

func on_interactable_deactivated() -> void:
	# Play closing animation
	animated_sprite_2d.play("close_door")
	collision_layer = 1
	#prints("deactivated")
