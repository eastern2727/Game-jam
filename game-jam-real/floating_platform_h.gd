extends Sprite2D
var targetPosX = 800
var startingPosX = 200
var lock: bool = false
var firstLock: bool = false
var secondLock: bool = false
var timer: Timer = Timer.new()
var timer2: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.wait_time = 1
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	add_child(timer2)
	timer2.wait_time = 1
	timer2.one_shot = true
	timer2.timeout.connect(_on_timeout2)

func _process(delta: float) -> void:
	if (position.x <targetPosX-0.05 && !lock):
		position.x = move_toward(position.x, targetPosX, delta*100)
	else:
		if (!lock):
			timer2.start()
			lock = true
		elif (timer2.time_left == 0):
			lock = true
			position.x = move_toward(position.x, startingPosX, delta*100)
			if (position.x<startingPosX+0.05 && timer.time_left == 0):
				timer.start()
func _on_timeout():
	lock = false
	pass
func _on_timeout2():
	pass
