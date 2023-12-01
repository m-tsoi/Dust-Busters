extends CanvasLayer

# Sources: https://kidscancode.org/godot_recipes/3.x/ui/unit_healthbar/

# HP Bar appearance
var bar_high_hp = preload("res://assets/user_interface/hp_bar/barHorizontal_green_placeholder.png")
var bar_mid_hp = preload("res://assets/user_interface/hp_bar/barHorizontal_yellow_placeholder.png")
var bar_low_hp = preload("res://assets/user_interface/hp_bar/barHorizontal_red_placeholder.png")

@onready var healthbar = $Control/MarginContainer/HealthBar
@onready var tasklist_node = $Control2/ItemList


# Called when the node enters the scene tree for the first time.
func _ready():
	#get_parent().get_parent().get_node("CharacterBody3D").health_changed
	GlobalStatsManager.connect("stats_changed", update_stats)
	healthbar.texture_progress = bar_high_hp
	healthbar.max_value = GlobalStatsManager.player_health
	healthbar.value = healthbar.max_value
	
	tasklist_node.add_item("enemies")
	tasklist_node.add_item("trash bags")
	tasklist_node.add_item("puddles")

	
	
func update_stats():
	update_health()
	update_tasklist()
	
func update_health():
	print("Updating health: ", GlobalStatsManager.player_health)
	# Updates health bar based on the current hp of a unit
	# Will change health later according to whatever percentage is decided
	if GlobalStatsManager.player_health < healthbar.max_value * 0.8 \
	&& GlobalStatsManager.player_health > healthbar.max_value * 0.4:
		healthbar.texture_progress = bar_mid_hp
	elif GlobalStatsManager.player_health < healthbar.max_value * 0.4:
		healthbar.texture_progress = bar_low_hp
	healthbar.value = GlobalStatsManager.player_health
		
	
	
func update_tasklist():
	var enemy_task = "enemies " + str(GlobalStatsManager.enemies_killed) + " / " + str(GlobalStatsManager.max_enemy_count)
	var trashbag_task = "trashbags " + str(GlobalStatsManager.trash_cleaned) + " / " + str(GlobalStatsManager.max_trash_count)
	var puddle_task = "puddles " + str(GlobalStatsManager.puddles_cleaned) + " / " + str(GlobalStatsManager.max_puddle_count)
	tasklist_node.set_item_text(0, enemy_task)
	tasklist_node.set_item_text(1, trashbag_task)
	tasklist_node.set_item_text(2, puddle_task)
