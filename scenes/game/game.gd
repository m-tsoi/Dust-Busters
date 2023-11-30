extends Node3D

var main_menu_scene = preload("res://scenes/user_interface/main_menu.tscn").instantiate()
var level1 = preload("res://scenes/levels/level.tscn")
var current_level = level1.instantiate()

# Unimplemented
var win_scene = preload("res://scenes/user_interface/main_menu.tscn").instantiate()
var lose_scene = preload("res://scenes/user_interface/main_menu.tscn").instantiate()

var default_health = GlobalStatsManager.player_health

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu_scene.connect("play_level", receive_play_level_signal)
	current_level.connect("lost", receive_lost_signal)
	current_level.connect("won", receive_won_signal)
	add_child(main_menu_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reset_autoload():
	GlobalStatsManager.set_player_health(default_health)
	GlobalStatsManager.set_enemies_killed(0)
	GlobalStatsManager.set_trash_cleaned(0)
	GlobalStatsManager.set_puddles_cleaned(0)

func receive_play_level_signal():
	current_level = level1.instantiate()
	current_level.connect("lost", receive_lost_signal)
	current_level.connect("won", receive_won_signal)
	remove_child(main_menu_scene)
	add_child(current_level)
	
func receive_lost_signal():
	remove_child(current_level)
	current_level.queue_free()
	reset_autoload()
	add_child(main_menu_scene)

func receive_won_signal():
	remove_child(current_level)
	current_level.queue_free()
	reset_autoload()
	add_child(main_menu_scene)
