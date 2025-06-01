class_name SpriteRoot
extends StateMachine

@onready var animated_sprite: AnimatedSprite2D = $RYU

func process_physics(delta: float) -> void:
	var sprite: Texture = animated_sprite.sprite_frames.get_frame_texture(animated_sprite.animation.get_basename(), 0)
	var sprite_height: int = sprite.get_height()
	animated_sprite.offset.y = (sprite_height / 2) * -1
