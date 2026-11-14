extends Sprite2D
var targetPosY = 400
var startingPosY = 100
var lock: bool = false
var firstLock: bool = false
var secondLock: bool = false
var timer: Timer = Timer.new()
var timer2: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(timer)
	timer.wait_time = 1
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	add_child(timer2)
	timer2.wait_time = 1
	timer2.one_shot = true
	timer2.timeout.connect(_on_timeout2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (position.y <targetPosY-0.05 && !lock):
		position.y = move_toward(position.y, targetPosY, delta*100)
	else:
		if (!lock):
			timer2.start()
			lock = true
		elif (timer2.time_left == 0):
			lock = true
			position.y = move_toward(position.y, startingPosY, delta*100)
			if (position.y<startingPosY+0.05 && timer.time_left == 0):
				timer.start()
func _on_timeout():
	lock = false
	pass
func _on_timeout2():
	pass
