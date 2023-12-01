extends Control

signal won_back_pressed
signal won_restart_pressed
signal won_next_pressed


func _on_button_menu_pressed():
	won_back_pressed.emit()

func _on_button_restart_pressed():
	won_restart_pressed.emit()

func _on_button_next_pressed():
	won_next_pressed.emit()
