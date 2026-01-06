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
		try_fire()

func try_fire() -> void:
	if not $CooldownTimer.is_stopped():
		return
	
	var target = get_nearest_enemy()
	if not target:
		return
	
	fire_projectile(target.global_position)
	play_gunshot_sound()
	play_recoil()
	$CooldownTimer.start()

func fire_projectile(target: Vector2) -> void:
	print("firing")
	var radius: float = 22.0
	var direction: Vector2 = (target - global_position).normalized()
	
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.global_position = global_position + (direction * radius)
	projectile.velocity = direction * projectile.speed
	get_tree().current_scene.add_child(projectile)

func get_nearest_enemy() -> Node2D:
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty():
		return null
	
	var closest_enemy: Node2D = null
	var closest_dist_sq: float = INF
	
	for enemy in enemies:
		enemy = enemy as Node2D
		var dist_sq: float = global_position.distance_squared_to(enemy.global_position)
		if dist_sq < closest_dist_sq:
			closest_dist_sq = dist_sq
			closest_enemy = enemy
	
	return closest_enemy

#=== Visuals ===
var recoil_offset_y: float = -6.0
var recoil_time: float = 0.08

func play_recoil() -> void:
	var base_y: float = $Sprite2D.position.y
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	# Pop up
	tween.tween_property(
		$Sprite2D,
		"position:y",
		base_y + recoil_offset_y,
		recoil_time
	)

	# Snap back
	tween.tween_property(
		$Sprite2D,
		"position:y",
		base_y,
		recoil_time
	)

func play_gunshot_sound() -> void:
	$GunshotAudio.pitch_scale = 0.95 + randf() * 0.1
	$GunshotAudio.play()
