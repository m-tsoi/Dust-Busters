extends RigidBody3D

var health := 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health == 0:
		self.queue_free()
	

func _on_hurtbox_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("Area ", area_rid, " ", area, " entered enemy's hurtbox")
	if area.is_in_group("player_basic_attack"):
		print("Enemy has received player's basic attack")
		health -= 2
	print("Enemy health: ", health)
