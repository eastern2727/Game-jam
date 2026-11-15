extends AnimatableBody2D

@export var spin_speed : float = 6

func _physics_process(delta):
	rotation += spin_speed * delta
