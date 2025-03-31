class_name ObstructionDetector
extends Area2D

signal obstruction_detected

func _on_body_entered(_body: Node2D) -> void:
	obstruction_detected.emit()
