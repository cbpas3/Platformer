extends "res://src/Actors/Actor.gd"

func _ready() -> void:
	# Deactivates the enemy physics at the start of the game
	set_physics_process(false)
	_velocity.x = -speed.x

func _physics_process(delta: float) -> void:
	_velocity.y += gravity + delta
	if is_on_wall():
		_velocity.x *= -1.0
		
	# Reset the vertical velocity because
	# _velocity.y += gravity + delta accumulates even after it hits the ground
	_velocity.y = move_and_slide(_velocity, up_direction).y
