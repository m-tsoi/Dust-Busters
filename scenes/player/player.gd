extends CharacterBody3D


const SPEED = 15.0 * 1.5
const JUMP_VELOCITY = 56

var hitbox_scene: PackedScene = preload("res://scenes/player/player_hitbox.tscn")
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var basic_attack_hitbox: Node
var is_attacking: bool = false
var health: int = 5
var enemies_touching: int = 0
var invulnerable: bool = false
var is_facing_left: bool = true

func _process(delta):
	# Basic attack
	if Input.is_action_just_pressed("basic_attack") and not is_attacking:
		is_attacking = true
		basic_attack_hitbox = hitbox_scene.instantiate()
		basic_attack_hitbox.add_to_group("player_basic_attack")
		add_child(basic_attack_hitbox)
		var timer := Timer.new()
		add_child(timer)
		timer.wait_time = 0.5
		timer.one_shot = true
		timer.start()
		timer.connect("timeout", _on_basic_attack_hitbox_timer_timeout)
	
	# Take damage from enemy
	if enemies_touching > 0:
		if (not invulnerable):
			#TODO: Play animation, play sound, death
			invulnerable = true
			var invuln_timer := Timer.new()
			add_child(invuln_timer)
			invuln_timer.wait_time = 1
			invuln_timer.one_shot = true
			invuln_timer.start()
			invuln_timer.connect("timeout", _on_invuln_timer_timeout)
			health -= 1
			print("Player health: ", health)
			if (health <= 0):
				print("[Unimplemented] Player died")
		elif (invulnerable):
			pass
	
	# Change facing direction
	if not is_facing_left and Input.is_action_just_pressed("move_left"):
		is_facing_left = true
		$Sprite3D.flip_h = false
	elif is_facing_left and Input.is_action_just_pressed("move_right"):
		is_facing_left = false
		$Sprite3D.flip_h = true

func _on_basic_attack_hitbox_timer_timeout() -> void:
	print("Timer timeouted")
	basic_attack_hitbox.queue_free()
	is_attacking = false

func _on_invuln_timer_timeout() -> void:
	print("Invuln timer timeouted")
	invulnerable = false

func _on_hurtbox_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	enemies_touching += 1
	print("Area ", area_rid, " ", area, " entered player's hurtbox")

func _on_hurtbox_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	enemies_touching -= 1
	print("Area ", area_rid, " ", area, " left player's hurtbox")


func _physics_process(delta):
	# Add the gravity.
	var current_speed = SPEED
	if not is_on_floor():
		velocity.y -= gravity * delta
		current_speed = current_speed / 1.5

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()

