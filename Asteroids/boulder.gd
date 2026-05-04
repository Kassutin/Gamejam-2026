extends RigidBody2D

# Size category: 0 = small, 1 = medium, 2 = big
@export var size: int = 2

# Movement
@export var min_speed: float = 50.0
@export var max_speed: float = 150.0
@export var max_spin: float = 2.0

# How many smaller pieces to spawn when destroyed (only if size > 0)
const SPLIT_COUNT: int = 2

# Points awarded for destroying this asteroid (small = most, big = least)
const POINTS_BY_SIZE = {0: 100, 1: 50, 2: 20}


func _ready() -> void:
	# Scale the visual + physics down based on size
	# size 2 (big) = scale 1.0, size 1 (medium) = 0.6, size 0 (small) = 0.35
	var scale_by_size = {0: 0.35, 1: 0.6, 2: 1.0}
	scale = Vector2.ONE * scale_by_size[size]
	
	# Pick a random drift direction and speed
	var random_angle = randf() * TAU
	var direction = Vector2.RIGHT.rotated(random_angle)
	var speed = randf_range(min_speed, max_speed)
	linear_velocity = direction * speed
	angular_velocity = randf_range(-max_spin, max_spin)


# Called by the bullet when it hits this asteroid
func hit() -> void:
	# Award points based on size
	var points = POINTS_BY_SIZE[size]
	print("Asteroid destroyed! +", points, " points")
	
	# If we're not the smallest size, spawn smaller children
	if size > 0:
		_spawn_children()
	
	# Remove this asteroid
	queue_free()


func _spawn_children() -> void:
	# Load our own scene file so we can spawn copies of ourselves
	var asteroid_scene = load("res://boulder.tscn")
	
	for i in SPLIT_COUNT:
		var child = asteroid_scene.instantiate()
		child.size = size - 1          # one size smaller
		child.global_position = global_position  # spawn at our location
		# Add to the same parent so it lives in the same scene
		get_parent().add_child(child)
