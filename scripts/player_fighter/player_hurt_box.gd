class_name HurtBox
extends Area2D

func _ready():
	collision_layer = 12
	collision_mask = 11
	self.area_entered.connect(on_area_entered)

func on_area_entered(hit_box: HitBox) -> void:
	if hit_box == null: return
	# TODO: Deal damage
	print("Damage Dealt")
