extends Node2D

@export var revolver_speed: float = 6.0
@export var fire_delay: float = 0.25
@export var rotate_delay: float = 0.1
@export var bullet_scene: PackedScene
@export var projectile_scene: PackedScene

const MAX_BULLETS := 6
const STEP_ANGLE := TAU / 6.0

var bullets_fired := 0
var is_running := false

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		print("test")
		fire_projectile(get_global_mouse_position())

func start_revolver() -> void:
	if is_running:
		return
	is_running = true
	revolver_loop()

func revolver_loop() -> void:
	while is_running and bullets_fired < MAX_BULLETS:
		#fire_bullet()
		bullets_fired += 1

func fire_projectile(target: Vector2) -> void:
	var radius: float = 22.0
	var direction: Vector2 = (target - global_position).normalized()
	
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.global_position = global_position + (direction * radius)
	projectile.direction = direction
	get_tree().current_scene.add_child(projectile)
