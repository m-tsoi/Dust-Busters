extends StaticBody3D

signal cleaned

# Deletes object when hit by player's basic attack
func _on_hurtbox_area_entered(area):
	if area.is_in_group("player_basic_attack"):
		print("Cleanable object hit by normal attack")
		cleaned.emit()
		self.queue_free()
		
