class_name SpriteRoot
extends StateMachine

@onready var animated_sprite: AnimatedSprite2D = $RYU

func process_physics(delta: float) -> void:
	super(delta)
	
