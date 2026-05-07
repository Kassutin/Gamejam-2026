extends Button




func _on_pressed() -> void:
	Score.lives = 3
	get_tree().change_scene_to_file("res://startscreen.tscn")
	
