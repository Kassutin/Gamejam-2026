extends Label

# We need to tell the Label where the Player is
# Change "Player" to the actual name of your player node in the scene
# This looks for the node named "player_ship" in your scene
@onready var player = get_tree().root.find_child("player_ship", true, false)

func _process(_delta):
	# We check "is_instance_valid" to make sure the ship hasn't been deleted
	if is_instance_valid(player):
		# Access the energy variable from your ship script
		text = "Energy: " + str(int(player.energy))
	else:
		text = "Ship Offline"
