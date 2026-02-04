extends AnimatableBody3D

signal hero_caught()

@export var voice: Resource

const SPEED = 2
const RAY_LENGTH = 10
const TURN_SPEED = 2

@onready var rays = [$Rays/Left, $Rays/CenterLeft, $Rays/Center, $Rays/CenterRight, $Rays/Right]
@onready var center_ray_i := int(len(rays)/2)
var rays_dist: PackedFloat32Array = []
var max_dist := 0.0
var max_dist_i := -1

var player_pos = -1

enum {IDLE, CHASING, ALARM}
var state = IDLE


func _ready() -> void:
	# Set guardian's voice
	$AudioVoice.stream = voice
	
	# Fill up ray detection arrays with default values
	for i in range(len(rays)):
		rays_dist.append(999)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match state:
		ALARM:
			if not $AudioAlert.is_playing():
				$AudioAlert.play()
			state = CHASING
		IDLE:
			# Idle speech
			if not $AudioVoice.is_playing() and randf() < 0.00004:
				$AudioVoice.play()


func _physics_process(delta):
	var walk_speed = delta * -SPEED
	var turn_speed = delta * TURN_SPEED
	if state == CHASING:
		walk_speed *= 2
		turn_speed *= 2
	
	# Walk forward
	# We need to do that before tuning, for some reason
	transform.origin += (transform.basis * Vector3(0, 0, walk_speed))
	
	for ray in rays:
		ray.force_raycast_update()
	cast_rays()
	
	if player_pos >= 0:
		if state == IDLE:
			state = ALARM
		$ChasingTimer.start(6.66)
		
		# Turn towards player
		if player_pos < center_ray_i:
			rotate_y(turn_speed)
		elif player_pos > center_ray_i:
			rotate_y(-turn_speed)
			
	elif max_dist_i >= 0 and max_dist_i != center_ray_i:
		# Turn to avoid obstacles
		if rays_dist[center_ray_i] < max_dist:
			if max_dist_i > center_ray_i:
				rotate_y(-turn_speed)
			else:
				rotate_y(turn_speed)
			
	elif max_dist < 2 and max_dist_i == center_ray_i:
		# Weird 180 turn around
		rotate_y(PI)


func cast_rays() -> void:
	# Calculate collision distance for each ray
	max_dist = 0
	max_dist_i = -1
	player_pos = -1
	
	for i in range(len(rays)):
		var ray: RayCast3D = rays[i]
		if ray.is_colliding():
			if ray.get_collider() is Hero:
				player_pos = i
				rays_dist[i] = 999
				continue
			
			var ray_dist = get_collision_distance(rays[i])
			#if dist < min_dist:
				#min_dist = dist
				#min_dist_i = i
			if ray_dist > max_dist:
				max_dist = ray_dist
				max_dist_i = i
				
			rays_dist[i] = ray_dist
		else:
			rays_dist[i] = 999
			max_dist = 999
			max_dist_i = i


func get_collision_distance(ray: RayCast3D) -> float:
	var collision_point = ray.get_collision_point()
	return (collision_point - global_position).length()


func _on_chasing_timer_timeout() -> void:
	state = IDLE


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Hero:
		emit_signal("hero_caught")
