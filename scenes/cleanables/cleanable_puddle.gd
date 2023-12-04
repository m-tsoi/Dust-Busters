extends StaticBody3D

signal mopped

# Deletes object when hit by player's basic attack
func _on_hurtbox_area_entered(area):
	if area.is_in_group("player_basic_attack"):
		print("Puddle object hit by normal attack")
		mopped.emit()
		self.queue_free()
