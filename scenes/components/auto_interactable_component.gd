class_name AutoInteractableComponent
extends Area2D

signal auto_interactable_activated
signal auto_interactable_deactivated


func _on_body_entered(_body: Node2D) -> void:
	auto_interactable_activated.emit()


func _on_body_exited(_body: Node2D) -> void:
	auto_interactable_deactivated.emit()
