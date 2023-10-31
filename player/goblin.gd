extends CharacterBody3D

@onready var camera = $YawAxis/Camera3D
@onready var hammer = $YawAxis/Camera3D/Hammer


@export_category("Physics Settings")
@export var jumpImpulse : float = 3.5
@export var dashImpulse : float = 15
@export var gravity : float = -5.5
@export var groundAcceleration : float = 30.0
@export var groundSpeedLimit : float = 3.0
@export var airAcceleration : float = 500.0
@export var airSpeedLimit : float = 1.2
@export var groundFriction : float = 0.9

@export var mouseSensitivity : float = 0.1

var strafeDir : Vector3 = Vector3.ZERO
var strafeAccel : float = groundAcceleration
var speedLimit : float
var currentSpeed : float
var can_bounce : bool = false

var dashs : int = 2 : set = set_dashes
var init_vel : float = 0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Signals.emit_signal("time_started")
	pass # Replace with function body.

func _physics_process(delta):
	# Apply gravity, jumping, and ground friction to velocity
	velocity.y += gravity * delta
	
	if is_on_floor():
		dashs += 1
		if Input.is_action_pressed("move_jump"):
			velocity.y = jumpImpulse
		else:
			# If not doing a jump, apply fricktion
			velocity *= groundFriction
	
	
	
	strafeDir = get_strafe_dir()
	
	
	# Figure out which strafe force and speed limit applies
	var strafeAccel = groundAcceleration if is_on_floor() else airAcceleration
	var speedLimit = groundSpeedLimit if is_on_floor() else airSpeedLimit
	
	# Project current velocity onto the strafe direction, and compute a capped
	# acceleration such that *projected* speed will remain within the limit.
	currentSpeed = strafeDir.dot(velocity)
	var accel = strafeAccel * delta
	accel = max(0, min(accel, speedLimit - currentSpeed))
	
	bonk()
	dash()
	
	# Apply strafe acceleration to velocity and then integrate moton
	velocity += strafeDir * accel
	
	move_and_slide()


func bonk():
	# hammer
	if Input.is_action_just_pressed("mouse_left"):
		var mpos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mpos)
		var to = from + camera.project_ray_normal(mpos) * 2.2
		var space = get_world_3d().direct_space_state
		
		var ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.from = from
		ray_query.to = to
		ray_query.collide_with_areas = true
		
		var ray_result = space.intersect_ray(ray_query)
		
		if ray_result:
			if !hammer.can_attack:
				return
			hammer.bonk()
			var n = ray_result.normal
			if n.y != 0:
				var b = $YawAxis/Camera3D.get_global_transform().basis.z.project(n)
				b *= Vector3(5, 7.5, 5)
				velocity += b
			else:
				velocity = velocity.bounce(n)
				velocity.y = jumpImpulse
			dashs += 1
			Signals.emit_signal("bonked")

func dash() -> void:
	# dash 
	if Input.is_action_just_pressed("move_fast") and dashs > 0:
		init_vel = velocity.length()
	if Input.is_action_pressed("move_fast") and dashs > 0:
		velocity *= 0.9
	if Input.is_action_just_released("move_fast") and dashs > 0:
		dashs -= 1
		var strength = init_vel if init_vel > 17 else dashImpulse
		velocity = -strength * $YawAxis/Camera3D.get_global_transform().basis.z
		Signals.emit_signal("dashed")

func get_strafe_dir() -> Vector3:
	# Compute X/Z axis strafe vector from WASD inputs
	var basis = $YawAxis/Camera3D.get_global_transform().basis
	var dir : Vector3 = Vector3(0, 0, 0)
	
	if Input.is_action_pressed("move_forward"):
		dir -= basis.z
	if Input.is_action_pressed("move_backward"):
		dir += basis.z
	if Input.is_action_pressed("move_left"):
		dir -= basis.x
	if Input.is_action_pressed("move_right"):
		dir += basis.x
	
	dir.y = 0
	dir = dir.normalized()
	
	return dir

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$YawAxis.rotate_x(deg_to_rad(event.relative.y * mouseSensitivity * -1))
		self.rotate_y(deg_to_rad(event.relative.x * mouseSensitivity * -1))

		# Clamp yaw to [-89, 89] degrees so you can't flip over
		var yaw = $YawAxis.rotation_degrees.x
		$YawAxis.rotation_degrees.x = clamp(yaw, -89, 89)


func set_dashes(value):
	dashs = value
	dashs = clamp(dashs, 0, 2)
