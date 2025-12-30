class_name Projectile
extends Area2D

var max_range: float = 360.0
var direction: Vector2 = Vector2.ZERO
var speed: float = 200.0

var _travelled_distance: float = 0.0

func _physics_process(delta: float) -> void:
	var distance: float = speed * delta
	var motion: Vector2 = direction * distance
	
	position += motion
	
	_travelled_distance += distance
	if _travelled_distance > max_range:
		queue_free()
