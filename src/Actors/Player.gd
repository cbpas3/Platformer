extends Actor

export var stomp_impulse: = 1000.0 #per second
export var bumper_impulse: = 2000.0 #per second

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	# bounce off enemy
	_velocity = calculate_stomp_velocity(_velocity,stomp_impulse)

func _on_EnemyDetector_body_entered(body: Node) -> void:
	# kills player
	queue_free()

func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	# Reset the player's vertical velocity
	# Is needed because of out.y += gravity * get_physics_process_delta_time()
	# Velocity keeps accumulating even after they hit the floor
	
	# if the character is not jumping, stick to the ground
	var snap:= Vector2.DOWN * 80.0 if is_equal_approx(direction.y, 1.0) else Vector2.ZERO
	# fourth parameter is stop on slope
	_velocity.y = move_and_slide_with_snap(
		_velocity,
		snap,
		up_direction,
		true,
		4,
		PI / 4.0
		).y
	
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.get_action_strength("jump") and is_on_floor() else 1.0
	)

func calculate_move_velocity(
	linear_velocity: Vector2,
	direction: Vector2,
	speed: Vector2,
	is_jump_interrupted: bool
	) -> Vector2:
	var out = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	
	# Code for jumping
	if direction.y == -1.0:
		out.y = speed.y * direction.y
		
	# Code for interrupting jump
	if is_jump_interrupted:
		out.y = 0.0
	return out

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	# Bounce off enemy
	var out: = linear_velocity
	out.y = -impulse
	return out
	





func _on_BumperDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity,bumper_impulse)
