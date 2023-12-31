extends Node3D

signal won
signal lost
signal menu_button_pressed

func _ready():
	var player_node := $CharacterBody3D
	player_node.connect("died", _on_player_died)
	
	var enemy_list := get_tree().get_nodes_in_group("enemies")
	var init_enemy_count := enemy_list.size()
	GlobalStatsManager.set_max_enemy_count(init_enemy_count)
	for enemy in enemy_list:
		enemy.connect("killed", _on_enemy_killed)
	
	var trash_list := get_tree().get_nodes_in_group("trash")
	var init_trash_count := trash_list.size()
	GlobalStatsManager.set_max_trash_count(init_trash_count)
	for trash in trash_list:
		trash.connect("cleaned", _on_trash_cleaned)
	
	var puddle_list := get_tree().get_nodes_in_group("puddle")
	var init_puddle_count := puddle_list.size()
	GlobalStatsManager.set_max_puddle_count(init_puddle_count)
	for puddle in puddle_list:
		puddle.connect("mopped", _on_puddle_mopped)
	# TODO: connect signals from puddle objects

func _process(delta):
	check_winning_conditions()
	
func _on_player_died():
	print("LOST :((")
	lost.emit()

func _on_enemy_killed():
	GlobalStatsManager.set_enemies_killed(GlobalStatsManager.enemies_killed + 1)
	
func _on_trash_cleaned():
	GlobalStatsManager.set_trash_cleaned(GlobalStatsManager.trash_cleaned + 1)
	
func _on_puddle_mopped():
	GlobalStatsManager.set_puddles_mopped(GlobalStatsManager.puddles_mopped + 1)
	
func check_winning_conditions():
	if (GlobalStatsManager.enemies_killed >= GlobalStatsManager.max_enemy_count
		&& GlobalStatsManager.trash_cleaned >= GlobalStatsManager.max_trash_count
		&& GlobalStatsManager.puddles_mopped >= GlobalStatsManager.max_puddle_count):
			print("WON!!!")
			won.emit()


func _on_in_game_ui_main_menu_button_pressed():
	menu_button_pressed.emit()
