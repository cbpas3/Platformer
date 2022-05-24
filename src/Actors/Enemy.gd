extends "res://src/Actors/Actor.gd"

func _ready() -> void:
	# Deactivates the enemy physics at the start of the game
	set_physics_process(false)
	_velocity.x = -speed.x

func _physics_process(delta: float) -> void:
	
	
	var snap:= Vector2.DOWN * 65
	
	if is_on_wall():
		_velocity.x *= -1
	_velocity.y += gravity * delta
	_velocity.y = move_and_slide_with_snap(_velocity,snap, up_direction,true,4,PI/3).y


func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
	get_node("CollisionShape2D").disabled = true
	queue_free()
