class_name Detectors
extends Node2D

var allDetectors: Array[Area2D]
var validDirections = {"North": true, "South": true, "East": true, "West": true}


func _ready() -> void:
	for object in get_children():
		allDetectors.append(object)


func get_valid_directions() -> Dictionary:
	return validDirections


func is_valid_direction(direction: Vector2) -> bool:
	match direction:
		Vector2.UP:
			return validDirections["North"]
		Vector2.DOWN:
			return validDirections["South"]
		Vector2.RIGHT:
			return validDirections["East"]
		Vector2.LEFT:
			return validDirections["West"]
		_:
			return false


func _on_north_collision_body_entered(body: Node2D) -> void:
	validDirections["North"] = false

func _on_north_collision_body_exited(body: Node2D) -> void:
	validDirections["North"] = true


func _on_south_collision_body_entered(body: Node2D) -> void:
	validDirections["South"] = false

func _on_south_collision_body_exited(body: Node2D) -> void:
	validDirections["South"] = true


func _on_east_collision_body_entered(body: Node2D) -> void:
	validDirections["East"] = false

func _on_east_collision_body_exited(body: Node2D) -> void:
	validDirections["East"] = true


func _on_west_collision_body_entered(body: Node2D) -> void:
	validDirections["West"] = false

func _on_west_collision_body_exited(body: Node2D) -> void:
	validDirections["West"] = true


func _on_interaction_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

func _on_interaction_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


#func get_all_detectors() -> Array[Area2D]:
	#return allDetectors
#
#
#func get_detector(index: int) -> Area2D:
	#return allDetectors[index]
#
#
#func get_detector_group(first: int, last: int) -> Array[Area2D]:
	#var detectorGroup: Array[Area2D]
	#for i in range(first, last):
		#detectorGroup.append(allDetectors[i])
	#return detectorGroup
