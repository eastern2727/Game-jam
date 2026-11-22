extends CharacterBody2D

const BIG_RADIUS : float = 16
const SMALL_RADIUS : float = 8
const ART = preload("res://player.png")

@export var speed : Vector2 = Vector2(0, 0)
@export var compressed_speed = Vector2(120, 0)

@export var gravity : float = 800.0
@export var blast_strength : float = 1.5
@export var push_strength : float = 10.0

@export var hard_hit_threshold : float = 450.0
@export var energy_bonus : float = 0.004
@export var energy : float = 0.0
@export var impact_energy : float = 0.6
@export var max_energy : float = 1000.0
@export var energy_decay : float = 5.0

@export var friction: float = 150.0
@export var drift : float = 150.0

@export var frame : int = 0
const NUM_FRAMES : int = 4;
var dx_accumulator : float = 0.0;
var last_target_x : float = 0.0;
@export var charge_percent : float = 0.0
enum chargestate {
	none,
	low,
	medium,
	high,
}
var charge_state : chargestate = chargestate.none;

func _ready():
	$Sprite2D.set_region_enabled(true);
	$Sprite2D.set_region_rect(Rect2(0, 0, 32, 32))
	$Sprite2D.texture = ART
	set_size(BIG_RADIUS)

func _physics_process(delta : float):
	if position.y > 2000:
		get_tree().reload_current_scene()
		return

	velocity.y += gravity * delta
	
	var direction_x : float = Input.get_axis("left", "right")
	if Input.is_action_pressed("compress"):
		speed = compressed_speed
	if Input.is_action_just_pressed("compress"):
		shrink()
	if Input.is_action_just_released("compress"):
		puff_up()

	var target_x : float = speed.x * direction_x
	var accel : float = 1200.0
	if direction_x == 0.0 and is_on_floor():
		target_x = get_floor_normal().x * drift
	elif direction_x == 0.0:
		accel = friction
	
	if (sign(target_x) != sign(last_target_x)):
		dx_accumulator = 0.0
	last_target_x = target_x;
		
	velocity.x = move_toward(velocity.x, target_x, accel * delta)
	
	animate(velocity.x);
	
	var speed_before_hit = velocity
	move_and_slide()

	for i : int in get_slide_collision_count():
		var hit = get_slide_collision(i)
		var relative_speed = speed_before_hit - hit.get_collider_velocity()
		var hit_strength = -relative_speed.dot(hit.get_normal())
		if hit_strength >= hard_hit_threshold:
			energy += (hit_strength - hard_hit_threshold) * impact_energy
	
	energy = min(energy, max_energy)

	energy = move_toward(energy, 0, energy_decay * delta)

func animate(dx : float):
	dx_accumulator += dx;
	var diameter : float = $CollisionShape2D.shape.radius * 2.0;
	var dx_required : float = (PI * diameter) * 4.0
	if (abs(dx_accumulator) >= dx_required):
		if (dx_accumulator > 0.0):
			frame = (frame + 1) % NUM_FRAMES;
		else:
			frame = frame - 1 if frame - 1 >= 0 else NUM_FRAMES - 1;
		dx_accumulator = 0.0
	
	
	var x_offset : float = frame * diameter * 2;
	charge_percent = energy / max_energy;
	charge_state = int(fmod(charge_percent, 25.0))
	var y_offset : float = diameter * (charge_state * 2.0) + (diameter * 2 - 8 if diameter < 32.0 else 0.0);
	$Sprite2D.set_region_rect(Rect2(x_offset, y_offset, diameter * 2, diameter * 2));
	

func set_size(radius):
	$CollisionShape2D.shape.radius = radius
	$Sprite2D.scale = Vector2.ONE * 16.0 * (radius * 2) / $Sprite2D.texture.get_width()

func shrink():
	if is_on_floor():
		position.y += BIG_RADIUS - SMALL_RADIUS
	set_size(SMALL_RADIUS)

func puff_up():
	var broke_wall : bool = false
	var power : float = max(energy * blast_strength, 250.0)
	for obj in $bounceArea.get_overlapping_bodies():
		if obj.has_method("take_blast"):
			obj.take_blast(power)
			if obj.is_queued_for_deletion():
				add_collision_exception_with(obj)
				broke_wall = true

	var reach = BIG_RADIUS - SMALL_RADIUS
	var push = Vector2.ZERO
	for dir in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
		var hit = move_and_collide(dir * reach, true, 0.08, true)
		if hit:
			var squeeze = reach - hit.get_travel().length()
			push -= dir * squeeze

	position += push
	set_size(BIG_RADIUS)
	if !broke_wall:
		velocity += push * push_strength * (1 + energy * energy_bonus)
	energy = 0

func get_hit(force : Vector2):
	velocity += force
	energy = min(energy + force.length() * 0.5, max_energy)
	
