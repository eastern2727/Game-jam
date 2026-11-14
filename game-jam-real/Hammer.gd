extends Sprite2D
var SwingAngle: float = -50
var previousRotationValue: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.rotate(deg_to_rad(SwingAngle-0.1))
	previousRotationValue = 0.002


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (previousRotationValue>=0 && previousRotationValue<=0.01 && rotation_degrees>0):
		previousRotationValue = -0.01
	elif (previousRotationValue<=0 && previousRotationValue>=-0.01 && rotation_degrees<0):
		previousRotationValue = 0.01
	elif (self.rotation_degrees <0 && previousRotationValue >0):
		previousRotationValue *=1.0101
	elif (self.rotation_degrees >0 && previousRotationValue >0):
		previousRotationValue *=0.99
	elif (self.rotation_degrees >0 && previousRotationValue <0):
		previousRotationValue *=1.0101
	elif (self.rotation_degrees <0 && previousRotationValue <0):
		previousRotationValue *=0.99
	self.rotate(deg_to_rad(previousRotationValue))

	
