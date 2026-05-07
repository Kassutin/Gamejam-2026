extends Label

func _process(_delta):
	text = "Lives: " + str(int(Score.lives))
	
