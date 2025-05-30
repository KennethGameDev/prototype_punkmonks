class_name PlayerWalkState
extends PlayerState

func enter() -> void:
	print("Movement State")
	player.animation.play(move_f_anim)
