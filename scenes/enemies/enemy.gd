extends RigidBody3D

var health := 10
var knockback := Vector3.ZERO
@export var goofy_collisions: bool = false
@export var leftmost_patrol_point: int = -20
@export var rightmost_patrol_point: int = 20
@export var cur_direction = "left"
var ready_to_jump: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health == 0:
		self.queue_free()
	if ready_to_jump:
		set_sleeping(false)


func _on_hurtbox_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("Area ", area_rid, " ", area, " entered enemy's hurtbox")
	if area.is_in_group("player_basic_attack"):
		set_sleeping(false)
		print("Enemy has received player's basic attack")
		health -= 2
		var raw_knockback = self.global_position.direction_to(area.global_position) * 40
		if raw_knockback.x > 0:
			knockback = Vector3(-25, 40, 0)
		elif raw_knockback.x < 0:
			knockback = Vector3(25, 40, 0)
	print("Enemy health: ", health)

func _integrate_forces(state):
	if ready_to_jump:
		if position.x < leftmost_patrol_point:
			cur_direction = "right"
			$Sprite3D.flip_h = true
		if position.x > rightmost_patrol_point:
			cur_direction = "left"
			$Sprite3D.flip_h = false
		if cur_direction == "left":
			state.apply_impulse(Vector3(-20, 30, 0))
		elif cur_direction == "right":
			state.apply_impulse(Vector3(20, 30, 0))
		var jump_timer := Timer.new()
		add_child(jump_timer)
		jump_timer.wait_time = 2.5
		jump_timer.one_shot = true
		jump_timer.start()
		jump_timer.connect("timeout", _on_jump_timer_timeout)
		ready_to_jump = false
	if knockback != Vector3.ZERO:
		state.apply_impulse(knockback)
		knockback = Vector3.ZERO
	if not goofy_collisions:
		rotation = Vector3.ZERO
		position.z = 0

func _on_jump_timer_timeout() -> void:
	ready_to_jump = true
