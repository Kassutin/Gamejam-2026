extends Node

@export var asteroid_scene: PackedScene

# Asteroidin määrä levelin alkaessa
@export var initial_count: int = 4

# Kuinka usei uusi asteroidi tulee
@export var spawn_interval: float = 3.0

var _time_since_last_spawn: float = 0.0

func _ready() -> void:
	for i in initial_count:
		_spawn_asteroid_at_random_position()


func _process(delta: float) -> void:
	_time_since_last_spawn += delta
	if _time_since_last_spawn >= spawn_interval:
		_time_since_last_spawn = 0.0
		_spawn_asteroid_at_edge()


func _spawn_asteroid_at_random_position() -> void:
	var asteroid = asteroid_scene.instantiate()
	var screen_size = get_viewport().get_visible_rect().size
	asteroid.global_position = Vector2(
		randf_range(0, screen_size.x),
		randf_range(0, screen_size.y)
	)
	# Varmistetaan että asteroidin koko on "iso"
	asteroid.size = 2
	get_parent().add_child(asteroid)


func _spawn_asteroid_at_edge() -> void:
	var asteroid = asteroid_scene.instantiate()
	var screen_size = get_viewport().get_visible_rect().size
	
	# Valise random kulma, josta uusia asteroideja tulevat: 0=top, 1=right, 2=bottom, 3=left
	var edge = randi() % 4
	var spawn_pos: Vector2
	match edge:
		0:  # top
			spawn_pos = Vector2(randf_range(0, screen_size.x), 0)
		1:  # right
			spawn_pos = Vector2(screen_size.x, randf_range(0, screen_size.y))
		2:  # bottom
			spawn_pos = Vector2(randf_range(0, screen_size.x), screen_size.y)
		3:  # left
			spawn_pos = Vector2(0, randf_range(0, screen_size.y))
	
	asteroid.global_position = spawn_pos
	asteroid.size = 2
	get_parent().add_child(asteroid)
