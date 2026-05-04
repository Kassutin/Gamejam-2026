extends RigidBody2D

# Koot: 0 = peini, 1 = keskikokoinen, 2 = iso
@export var size: int = 2

# Movement
@export var min_speed: float = 50.0
@export var max_speed: float = 150.0
@export var max_spin: float = 2.0

# split isosta asteroidista (only if size > 0)
const SPLIT_COUNT: int = 2

# pisteiden määrä kun boulder osunut.
const POINTS_BY_SIZE = {0: 100, 1: 50, 2: 20}


func _ready() -> void:
	
	var scale_by_size = {0: 0.35, 1: 0.6, 2: 1.0}
	scale = Vector2.ONE * scale_by_size[size]
	
	# Satunnainen suunta ja nopeus
	var random_angle = randf() * TAU
	var direction = Vector2.RIGHT.rotated(random_angle)
	var speed = randf_range(min_speed, max_speed)
	linear_velocity = direction * speed
	angular_velocity = randf_range(-max_spin, max_spin)


func hit() -> void:
	# pisteet myönnetään asteroidin koon perusteella.
	var points = POINTS_BY_SIZE[size]
	print("Asteroid destroyed! +", points, " points")
	
	if size > 0:
		_spawn_children()
	
	queue_free()


func _spawn_children() -> void:
	var asteroid_scene = load("res://boulder.tscn")
	
	for i in SPLIT_COUNT:
		var child = asteroid_scene.instantiate()
		child.size = size - 1          # yksi koko pienempi
		child.global_position = global_position
		
		get_parent().add_child(child)
		
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Game-area koko
	var screen_size = get_viewport_rect().size
	
	var current_transform = state.transform
	var pos = current_transform.origin
	
	if pos.x < 0:
		pos.x = screen_size.x
	elif pos.x > screen_size.x:
		pos.x = 0
	
	if pos.y < 0:
		pos.y = screen_size.y
	elif pos.y > screen_size.y:
		pos.y = 0
	
	current_transform.origin = pos
	state.transform = current_transform
