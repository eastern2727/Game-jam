extends Sprite2D
var startingPositionY: float = 200
var targetPosY: float = 500
var lock: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startingPositionY = position.y
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (position.y <500 && !lock):
		position.y = move_toward(position.y, targetPosY, delta*2000)
	else:
		lock = true
		position.y = move_toward(position.y, startingPositionY, delta*200)
		if (position.y<startingPositionY+0.05):
			lock = false
