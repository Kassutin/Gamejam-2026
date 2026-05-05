
extends Area2D

var speed = 650



func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("terrain"):
		print("Hit")
		Score.player_score += 1
		queue_free()
