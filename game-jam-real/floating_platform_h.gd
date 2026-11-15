extends AnimatableBody2D

@export var distance : float = 600
@export var speed : float = 100
@export var wait : float = 1

func _ready():
	var time = distance / speed
	var tween = create_tween().set_loops().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position:x", position.x + distance, time).set_delay(wait)
	tween.tween_property(self, "position:x", position.x, time).set_delay(wait)
