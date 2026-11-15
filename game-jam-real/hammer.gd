extends AnimatableBody2D

@export var angle : float = 50
@export var swing_time : float = 1.2

func _ready():
	rotation_degrees = -angle
	var tween = create_tween().set_loops().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "rotation_degrees", angle, swing_time)
	tween.tween_property(self, "rotation_degrees", -angle, swing_time)
