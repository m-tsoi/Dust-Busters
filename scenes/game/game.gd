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
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	main_menu_scene.connect("play_level", receive_play_level)
	current_level.connect("lost", receive_lost)
	current_level.connect("won", receive_won)
	current_level.connect("menu_button_pressed", receive_menu_button_pressed)
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
	GlobalStatsManager.set_puddles_mopped(0)

func receive_play_level():
	current_level = level1.instantiate()
	current_level.connect("lost", receive_lost)
	current_level.connect("won", receive_won)
	current_level.connect("menu_button_pressed", receive_menu_button_pressed)
	remove_child(main_menu_scene)
	add_child(current_level)
	
func receive_lost():
	current_level.get_node("InGameUI").queue_free()
	add_child(lose_scene)
	move_child(current_level, 0)
	move_child(lose_scene, 1)
	get_tree().paused = true

func receive_lose_retry_pressed():
	get_tree().paused = false
	remove_child(current_level)
	current_level.queue_free()
	reset_autoload()
	current_level = level1.instantiate()
	current_level.connect("lost", receive_lost)
	current_level.connect("won", receive_won)
	current_level.connect("menu_button_pressed", receive_menu_button_pressed)
	remove_child(lose_scene)
	add_child(current_level)

func receive_lose_back_pressed():
	get_tree().paused = false
	remove_child(lose_scene)
	remove_child(current_level)
	current_level.queue_free()
	reset_autoload()
	add_child(main_menu_scene)

func receive_won():
	current_level.get_node("InGameUI").queue_free()
	add_child(win_scene)
	move_child(current_level, 0)
	move_child(win_scene, 1)
	get_tree().paused = true

func receive_win_back_pressed():
	get_tree().paused = false
	remove_child(win_scene)
	remove_child(current_level)
	current_level.queue_free()
	reset_autoload()
	add_child(main_menu_scene)

func receive_win_restart_pressed():
	get_tree().paused = false
	remove_child(current_level)
	current_level.queue_free()
	reset_autoload()
	current_level = level1.instantiate()
	current_level.connect("lost", receive_lost)
	current_level.connect("won", receive_won)
	current_level.connect("menu_button_pressed", receive_menu_button_pressed)
	remove_child(win_scene)
	add_child(current_level)
	
func receive_win_next_pressed():
	print("Next scene pressed, but we only have 1 level")

func receive_menu_button_pressed():
	remove_child(current_level)
	current_level.queue_free()
	reset_autoload()
	add_child(main_menu_scene)
