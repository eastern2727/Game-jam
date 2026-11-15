extends AnimatableBody2D

@export var drop : float = 165
@export var slam_time : float = 0.1
@export var rise_time : float = 0.8
@export var wait : float = 0.5

func _ready():
	var tween = create_tween().set_loops().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position:y", position.y + drop, slam_time).set_delay(wait)
	tween.tween_property(self, "position:y", position.y, rise_time)
