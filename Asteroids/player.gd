extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 1.5
@export var acceleration = 1500  # How fast you reach max speed
@export var friction = 1000      # How fast you come to a stop
@export var player_bullet : PackedScene
@onready var energy_bar = $TextureProgressBar


var max_energy = 10
var energy = 10.0 # Make this a float (100.0) for smooth math

var rotation_direction = 0.0

func _ready():
	energy_bar.max_value = max_energy
	energy_bar.value = energy

func _on_timer_timeout():
	if energy < max_energy:
		energy += 1
		
		if energy > max_energy:
			energy = max_energy
		

	

func _update_animations():
	var sprite = $AnimatedSprite2D
	
	
	var is_moving = Input.get_axis("down", "up") != 0
	
	if is_moving:
		sprite.play("thrust")
	else:
		sprite.play("default")

func get_input(delta):
	energy_bar.value = energy
	rotation_direction = Input.get_axis("left", "right")
	
	
	var input_dir = Input.get_axis("down", "up")
	var target_velocity = transform.x * input_dir * speed
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	if input_dir != 0:
		
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
	
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func shoot():
	if energy > 0:
		var b = player_bullet.instantiate()
		get_parent().add_child(b)
		b.transform = $Marker2D.global_transform
		energy -= 1
	else: 
		pass

func _wrap_screen() -> void:
	var screen_size = get_viewport_rect().size
	
	if position.x < 0:
		position.x = screen_size.x
	elif position.x > screen_size.x:
		position.x = 0
	
	if position.y < 0:
		position.y = screen_size.y
	elif position.y > screen_size.y:
		position.y = 0

func _physics_process(delta):
	get_input(delta)
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
	_update_animations()
	_wrap_screen()

	
