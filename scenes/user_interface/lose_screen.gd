extends Control

signal lose_retry_pressed
signal lose_back_pressed


func _on_button_next_pressed():
	lose_retry_pressed.emit()


func _on_button_menu_pressed():
	lose_back_pressed.emit()

