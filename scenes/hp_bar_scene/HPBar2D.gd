extends Node2D

# Sources: https://kidscancode.org/godot_recipes/3.x/ui/unit_healthbar/

# HP Bar appearance
var bar_high_hp = preload("res://assets/user_interface/hp_bar/barHorizontal_green_placeholder.png")
var bar_mid_hp = preload("res://assets/user_interface/hp_bar/barHorizontal_yellow_placeholder.png")
var bar_low_hp = preload("res://assets/user_interface/hp_bar/barHorizontal_red_placeholder.png")

@onready var healthbar = $HealthBar


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent() and get_parent().get("max_health"):
		healthbar.max_value = get_parent().max_health

# Called every frame. Keeps the health bar in the same angle.
func _process(delta):
	global_rotation = 0
	
func update_health(value):
	# Updates health bar based on the current hp of a unit
	# Will change health later according to whatever percentage is decided
	healthbar.texture_progress = bar_high_hp
	if value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_mid_hp
	if value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_low_hp
	healthbar.value = value
		
	
