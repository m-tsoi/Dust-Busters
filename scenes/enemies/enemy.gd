extends RigidBody3D

var health := 10
var knockback := Vector3.ZERO
@export var goofy_collisions: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health == 0:
		self.queue_free()


func _on_hurtbox_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("Area ", area_rid, " ", area, " entered enemy's hurtbox")
	if area.is_in_group("player_basic_attack"):
		set_sleeping(false)
		print("Enemy has received player's basic attack")
		health -= 2
		var raw_knockback = self.global_position.direction_to(area.global_position) * 40
		if raw_knockback.x > 0:
			knockback = Vector3(-25, 30, 0)
		elif raw_knockback.x < 0:
			knockback = Vector3(25, 30, 0)
	print("Enemy health: ", health)

func _integrate_forces(state):
	if knockback != Vector3.ZERO:
		state.apply_impulse(knockback)
		knockback = Vector3.ZERO
	if not goofy_collisions:
		rotation = Vector3.ZERO
		position.z = 0
	
