extends Node2D

# Sources: https://kidscancode.org/godot_recipes/3.x/ui/unit_healthbar/

# HP Bar appearance
var bar_high_hp = preload("res://assets/user_interface/hp_bar/barHorizontal_green_placeholder.png")
var bar_mid_hp = preload("res://assets/user_interface/hp_bar/barHorizontal_yellow_placeholder.png")
var bar_low_hp = preload("res://assets/user_interface/hp_bar/barHorizontal_red_placeholder.png")

@onready var healthbar = $HealthBar


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_parent().get_node("CharacterBody3D").health_changed.connect(update_health)
	healthbar.texture_progress = bar_high_hp
	healthbar.max_value = get_parent().get_parent().get_node("CharacterBody3D").get("health")
	healthbar.value = healthbar.max_value
	
func update_health(value):
	print("Updating health: ", value)
	# Updates health bar based on the current hp of a unit
	# Will change health later according to whatever percentage is decided
	if value < healthbar.max_value * 0.8 && value > healthbar.max_value * 0.4:
		healthbar.texture_progress = bar_mid_hp
	elif value < healthbar.max_value * 0.4:
		healthbar.texture_progress = bar_low_hp
	healthbar.value = value
		
	
