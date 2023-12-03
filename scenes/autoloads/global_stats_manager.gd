extends Node

var player_health := 100
var max_enemy_count := 0
var enemies_killed := 0
var max_trash_count := 0
var trash_cleaned := 0
var max_puddle_count := 0
var puddles_cleaned := 0

signal stats_changed
		
func set_player_health(value: int):
	player_health = value
	stats_changed.emit()
	
func set_max_enemy_count(value: int):
	max_enemy_count = value
	stats_changed.emit()
	
func set_enemies_killed(value: int):
	enemies_killed = value
	stats_changed.emit()
	print("Autoload: enemies killed=", enemies_killed)
	
func set_max_trash_count(value: int):
	max_trash_count = value
	stats_changed.emit()

func set_trash_cleaned(value: int):
	trash_cleaned = value
	stats_changed.emit()

func set_max_puddle_count(value: int):
	max_puddle_count = value
	stats_changed.emit()

func set_puddles_cleaned(value: int):
	puddles_cleaned = value
	stats_changed.emit()

