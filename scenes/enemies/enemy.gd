extends CharacterBody3D

var health := 10
@export var leftmost_patrol_offset: int = 15
@export var rightmost_patrol_offset: int = 15
var leftmost_patrol_point: int
var rightmost_patrol_point: int
@export var cur_direction = "left"
@export var JUMP_SPEEDS = Vector2(15.0, 30.0)
@export var KNOCKBACK_SPEEDS = Vector2(20, 30)
var jump_timer_timeoutted: bool = true
var knockback_dir = "none"

signal killed

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	cur_direction = "left"
	leftmost_patrol_point = global_position.x - leftmost_patrol_offset
	rightmost_patrol_point = global_position.x + rightmost_patrol_offset

func _process(delta):
	# Free when health is 0
	if health == 0:
		killed.emit()
		self.queue_free()

func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump
	if knockback_dir != "none":
		velocity.y += KNOCKBACK_SPEEDS.y
		if knockback_dir == "left":
			velocity.x += KNOCKBACK_SPEEDS.x * -1
		elif knockback_dir == "right":
			velocity.x += KNOCKBACK_SPEEDS.x
		knockback_dir = "none"
	elif jump_timer_timeoutted and is_on_floor():
		jump_timer_timeoutted = false
		if global_position.x < leftmost_patrol_point:
			cur_direction = "right"
			$Sprite3D.flip_h = true
		if global_position.x > rightmost_patrol_point:
			cur_direction = "left"
			$Sprite3D.flip_h = false
		velocity.y = JUMP_SPEEDS.y
		if cur_direction == "left":
			velocity.x += JUMP_SPEEDS.x * -1
		elif cur_direction == "right":
			velocity.x += JUMP_SPEEDS.x
		var jump_timer := Timer.new()
		add_child(jump_timer)
		jump_timer.wait_time = 2.5
		jump_timer.one_shot = true
		jump_timer.start()
		$EnemyJump.play()
		jump_timer.connect("timeout", _on_jump_timer_timeout)
	elif is_on_floor():
		velocity.x = 0
	move_and_slide()

func _on_hurtbox_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("Area ", area_rid, " ", area, " entered enemy's hurtbox")
	if area.is_in_group("player_basic_attack"):
		print("Enemy has received player's basic attack")
		health -= 2
		$EnemyHurt.play()
	print("Enemy health: ", health)
	#if self.global_position.x < area.global_position.x:
	if area.is_in_group("left_hitbox"):
		knockback_dir = "left"
	else:
		knockback_dir = "right"

func _on_jump_timer_timeout() -> void:
	jump_timer_timeoutted = true

