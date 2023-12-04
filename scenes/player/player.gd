extends CharacterBody3D


const SPEED = 20.0 * 1.6
const JUMP_VELOCITY = 56

var hitbox_scene: PackedScene = preload("res://scenes/player/player_hitbox.tscn")
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var basic_attack_hitbox: Node
var is_attacking: bool = false
var enemies_touching: int = 0
var invulnerable: bool = false
var is_facing_left: bool = false
var knockback: Vector3

@onready var _animation_player = $AnimationPlayer

signal died

func _process(delta):
	# Basic attack
	if Input.is_action_just_pressed("basic_attack") and not is_attacking:
		is_attacking = true
		$PlayerAttack.play()
		_animation_player.play("Basic_Attack")
		basic_attack_hitbox = hitbox_scene.instantiate()
		basic_attack_hitbox.add_to_group("player_basic_attack")
		if is_facing_left == true:
			basic_attack_hitbox.add_to_group("left_hitbox")
			basic_attack_hitbox.position = Vector3(-4,0,0)
		else:
			basic_attack_hitbox.add_to_group("right_hitbox")
			basic_attack_hitbox.position = Vector3(4,0,0)
		add_child(basic_attack_hitbox)
		var timer := Timer.new()
		add_child(timer)
		timer.wait_time = 0.2
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
			invuln_timer.wait_time = 0.4
			invuln_timer.one_shot = true
			invuln_timer.start()
			invuln_timer.connect("timeout", _on_invuln_timer_timeout)
			var health = GlobalStatsManager.player_health
			health -= 4
			GlobalStatsManager.set_player_health(health)
			$PlayerHurt.play()
			_animation_player.play("Damage")
			#print("Player health: ", health)
			if (health <= 0):
				$PlayerDeath.play()
				died.emit()
		elif (invulnerable):
			pass
	
	# Change facing direction
	if not is_facing_left and Input.is_action_just_pressed("move_left"):
		is_facing_left = true
		$Sprite3D.flip_h = true
	elif is_facing_left and Input.is_action_just_pressed("move_right"):
		is_facing_left = false
		$Sprite3D.flip_h = false
	
	

		

func _on_basic_attack_hitbox_timer_timeout() -> void:
	#print("Timer timeouted")
	basic_attack_hitbox.queue_free()
	is_attacking = false

func _on_invuln_timer_timeout() -> void:
	#print("Invuln timer timeouted")
	invulnerable = false

func _on_hurtbox_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var raw_knockback = self.global_position.direction_to(area.global_position)
	if raw_knockback.x > 0 and not invulnerable:
		#print("Knockback to the left")
		knockback = Vector3(-45, 5, 0)
	elif raw_knockback.x <= 0 and not invulnerable:
		#print("Knockback to the right")
		knockback = Vector3(45, 5, 0)
		
	enemies_touching += 1
	print("Area ", area_rid, " ", area, " entered player's hurtbox")

func _on_hurtbox_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if enemies_touching > 0:
		enemies_touching -= 1
	print("Area ", area_rid, " ", area, " left player's hurtbox")


func _physics_process(delta):
	# Add the gravity.
	var current_speed = SPEED
	if not is_on_floor() and velocity.y > -100:
		velocity.y -= gravity * delta
		current_speed = current_speed

	# Handle Jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$PlayerJump.play()
		_animation_player.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# TODO: Add periodic step sound effect for walking
	var input_dir = Input.get_vector("move_left", "move_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		_animation_player.play("Run")
		velocity.x = direction.x * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		
	if knockback != Vector3.ZERO:
		velocity.x = knockback.x
		if velocity.y + knockback.y > JUMP_VELOCITY:
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y += knockback.y
		knockback = lerp(knockback, Vector3.ZERO, 0.2)
		if knockback.length() < 1:
			knockback = Vector3.ZERO

	move_and_slide()

