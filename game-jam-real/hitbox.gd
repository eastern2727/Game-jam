extends Area2D

@export var force : float = 600

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.has_method("get_hit"):
		body.get_hit((body.global_position - global_position).normalized() * force)
