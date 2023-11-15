extends Node
var player_health: int = 5

signal health_changed

# Getters and Setters
func get_player_health():
	return player_health
		
func set_player_health(value: int):
	player_health = value
	health_changed.emit()
	
