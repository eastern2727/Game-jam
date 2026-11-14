extends CharacterBody2D

const SPEED : int = 200
const GRAVITY : int = 800
const HARD_HIT : int = 450
const BLAST_STRENGTH : float = 1.5
const COMPRESS_SPEED = 120
const BIG: float=50
const SMALL : float = 32
const PUSH_STRENGTH : float = 10
const ENERGY_BONUS : float = 0.004
const MAX_ENERGY : float = 300
const FRICTION: float = 150
const DRIFT : float = 150

var DECAY = 5
var energy : float = 0

func _ready():
		set_size(BIG)	
func _physics_process(delta : float):
		velocity.y += GRAVITY * delta
	
		var direction = Input.get_axis("left", "right")
		var top_speed = SPEED
		
		if Input.is_action_pressed("compress"):
			top_speed = COMPRESS_SPEED
		
		var target = direction * top_speed
		if direction ==0 and is_on_floor():
			target = get_floor_normal().x * DRIFT
		var accel = 1200
		if direction ==0 and !is_on_floor():
			accel = FRICTION
		velocity.x = move_toward(velocity.x, target, accel * delta)
		
		if Input.is_action_just_pressed("compress"):
			shrink()
			
		var speed_before_hit = velocity
		move_and_slide()
		
		for i in get_slide_collision_count():
			var surface : Vector2 = get_slide_collision(i).get_normal()
			var hit_strength = -speed_before_hit.dot(surface)
			if hit_strength >= HARD_HIT:
				energy += (hit_strength - HARD_HIT) #TODO: DETERMINE GOOD VALUE
		energy = min(energy,MAX_ENERGY)		
	
		if Input.is_action_just_released("compress"):
			puff_up()
		energy=move_toward(energy,0,DECAY*delta)
		$Label.text=str(int(energy))
func set_size(radius):
	$CollisionShape2D.shape.radius = radius
	$Sprite2D.scale = Vector2.ONE * radius / 64
func shrink():
	if is_on_floor():
		position.y += BIG-SMALL
	set_size(SMALL)
func puff_up():
	var power = max(energy*BLAST_STRENGTH,250)
	for obj in $bounceArea.get_overlapping_bodies():
		if obj.has_method("take_blast"):
			obj.take_blast(power)
			if obj.is_queued_for_deletion():
				add_collision_exception_with(obj)
	var reach = BIG - SMALL
	var push = Vector2.ZERO
	for dir in [Vector2.LEFT,Vector2.RIGHT,Vector2.UP,Vector2.DOWN]:
		var hit = move_and_collide(dir * reach, true, 0.08, true)
		if hit:
			var squeeze = reach - hit.get_travel().length()
			push -= dir * squeeze
	position += push
	set_size(BIG)
	velocity += push * PUSH_STRENGTH * (1 + energy * ENERGY_BONUS)
	#boii
	energy = 0
