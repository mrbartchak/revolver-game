class_name Enemy
extends Node2D

@export var movement_speed: float = 10.0
var movement_direction: Vector2

func _ready() -> void:
	var screen_center = get_viewport_rect().size * 0.5
	movement_direction = (screen_center - global_position).normalized()

func _physics_process(delta: float) -> void:
	global_position += movement_direction * movement_speed * delta
