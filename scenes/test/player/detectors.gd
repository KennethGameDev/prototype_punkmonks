class_name Detectors
extends Node2D

var valid_directions = {"Up": true, "Down": true, "Right": true, "Left": true}
var interaction_detected: bool
var interactable_name: String
var interactable: Node2D


func _ready() -> void:
	pass


func get_all_detectors() -> Array[Area2D]:
	var result: Array[Area2D]
	
	for object in get_children():
		result.append(object)
	
	return result


func get_detector(index: int) -> Area2D:
	var all_detectors: Array[Area2D] = get_all_detectors()
	
	return all_detectors[index]


func get_valid_directions() -> Dictionary:
	var result = {}
	
	for direction_label in valid_directions.keys():
		if valid_directions[direction_label] == true:
			result.get_or_add(direction_label, true)
	print(result)
	
	return result


func is_valid_direction(direction: Vector2) -> bool:
	match direction:
		Vector2.UP:
			return valid_directions["Up"]
		Vector2.DOWN:
			return valid_directions["Down"]
		Vector2.RIGHT:
			return valid_directions["Right"]
		Vector2.LEFT:
			return valid_directions["Left"]
		_:
			return false


func get_interactable() -> Node2D:
	interactable.get_node()
	return interactable


func _on_Up_collision_body_entered(_body: Node2D) -> void:
	valid_directions["Up"] = false
	prints(get_parent().name, "detected Collision (UP direction):", _body.name)

func _on_Up_collision_body_exited(_body: Node2D) -> void:
	valid_directions["Up"] = true


func _on_Down_collision_body_entered(_body: Node2D) -> void:
	valid_directions["Down"] = false
	prints(get_parent().name, "detected Collision (DOWN direction):", _body.name)

func _on_Down_collision_body_exited(_body: Node2D) -> void:
	valid_directions["Down"] = true


func _on_Right_collision_body_entered(_body: Node2D) -> void:
	valid_directions["Right"] = false
	prints(get_parent().name, "detected Collision (RIGHT direction):", _body.name)

func _on_Right_collision_body_exited(_body: Node2D) -> void:
	valid_directions["Right"] = true


func _on_Left_collision_body_entered(_body: Node2D) -> void:
	valid_directions["Left"] = false
	prints(get_parent().name, "detected Collision (LEFT direction):", _body.name)

func _on_Left_collision_body_exited(_body: Node2D) -> void:
	valid_directions["Left"] = true


func _on_interaction_body_entered(body: Node2D) -> void:
	interaction_detected = true
	interactable_name = body.name
	interactable = body
	prints(get_parent().name, "detected an Interactable:", body.name)

func _on_interaction_body_exited(_body: Node2D) -> void:
	interaction_detected = false
