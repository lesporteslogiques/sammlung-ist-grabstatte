class_name Hero
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVIY = 0.002

var inertia = Vector2()
var started = false

func _physics_process(delta: float) -> void:
	if not started:
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta		
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "front", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		inertia = Vector2(velocity.x, velocity.z)
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("torchlight_bobbing")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		if is_on_floor():
			inertia *= 0.9
			velocity.x += inertia.x
			velocity.z += inertia.y
		
		if $AnimationPlayer.is_playing():
			$AnimationPlayer.pause()

	move_and_slide()


func _input(event):
	if not started:
		return
		
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVIY)
		$Camera3D.rotate_x(-event.relative.y * MOUSE_SENSITIVIY)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))


func reset():
	global_position = Vector3(0, 0, 0)
	$CollisionShape3D.disabled = false
	visible = true
	started = true
