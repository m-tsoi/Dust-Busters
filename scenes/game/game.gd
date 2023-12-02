extends Node3D

var main_menu_scene = preload("res://scenes/user_interface/main_menu.tscn").instantiate()
var level1 = preload("res://scenes/levels/level.tscn")
var current_level = level1.instantiate()

# Unimplemented
var win_scene = preload("res://scenes/user_interface/win_screen.tscn").instantiate()
var lose_scene = preload("res://scenes/user_interface/lose_screen.tscn").instantiate()

var default_health = GlobalStatsManager.player_health

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu_scene.connect("play_level", receive_play_level)
	current_level.connect("lost", receive_lost)
	current_level.connect("won", receive_won)
	lose_scene.connect("lose_retry_pressed", receive_lose_retry_pressed)
	lose_scene.connect("lose_back_pressed", receive_lose_back_pressed)
	win_scene.connect("won_back_pressed", receive_win_back_pressed)
	win_scene.connect("won_restart_pressed", receive_win_restart_pressed)
	win_scene.connect("won_next_pressed", receive_win_next_pressed)
	add_child(main_menu_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reset_autoload():
	GlobalStatsManager.set_player_health(default_health)
	GlobalStatsManager.set_enemies_killed(0)
	GlobalStatsManager.set_trash_cleaned(0)
	GlobalStatsManager.set_puddles_cleaned(0)

func receive_play_level():
	current_level = level1.instantiate()
	current_level.connect("lost", receive_lost)
	current_level.connect("won", receive_won)
	remove_child(main_menu_scene)
	add_child(current_level)
	
func receive_lost():
	remove_child(current_level)
	current_level.queue_free()
	reset_autoload()
	add_child(lose_scene)

func receive_lose_retry_pressed():
	current_level = level1.instantiate()
	current_level.connect("lost", receive_lost)
	current_level.connect("won", receive_won)
	remove_child(lose_scene)
	add_child(current_level)

func receive_lose_back_pressed():
	remove_child(lose_scene)
	add_child(main_menu_scene)

func receive_won():
	remove_child(current_level)
	current_level.queue_free()
	reset_autoload()
	add_child(win_scene)

func receive_win_back_pressed():
	remove_child(win_scene)
	add_child(main_menu_scene)

func receive_win_restart_pressed():
	current_level = level1.instantiate()
	current_level.connect("lost", receive_lost)
	current_level.connect("won", receive_won)
	remove_child(win_scene)
	add_child(current_level)
	
func receive_win_next_pressed():
	print("Next scene pressed, but we only have 1 level")
