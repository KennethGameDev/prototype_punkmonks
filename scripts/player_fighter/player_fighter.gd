class_name PlayerFighter
extends CharacterBody2D

@onready var state_machine: StateMachine = $"StateMachine"
@onready var sprite_root: Node2D = $SpriteRoot
@onready var animated_sprite: AnimatedSprite2D = $SpriteRoot/RYU
@onready var animations: AnimationPlayer = $SpriteRoot/RYU/AnimationPlayer


func _ready(): state_machine.init()

func _input(event): 
	if event is not InputEventMouseMotion:
		state_machine.process_input(event)

func _process(delta): state_machine.process_frame(delta)

func _physics_process(delta): state_machine.process_physics(delta)
