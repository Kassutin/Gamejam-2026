
extends Area2D

var speed = 650

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemies"):
		body.queue_free()
	
	if body.is_in_group("terrain"):
		# Asteroidin split, score, jne.
		if body.has_method("hit"):
			body.hit()
		else:
			body.queue_free()
	
	# Luoti käytetty kun osuu
	queue_free()
	
