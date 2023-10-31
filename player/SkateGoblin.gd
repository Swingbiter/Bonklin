extends CharacterBody3D

@export var mouseSensitivity : float = 0.1

@export_category("Physics Settings")
@export var jumpImpulse : float = 3.5
@export var dashImpulse : float = 15
@export var gravity : float = -5.5
@export var groundAcceleration : float = 300.0
@export var groundSpeedLimit : float = 2.5
@export var airAcceleration : float = 500.0
@export var airSpeedLimit : float = 1.2
@export var groundFriction : float = 0.9

var strafeDir : Vector3 = Vector3.ZERO
var strafeAccel : float = groundAcceleration
var speedLimit : float
var currentSpeed : float

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Signals.emit_signal("time_started")
	pass # Replace with function body.

func _physics_process(delta):
	# Apply gravity, jumping, and ground friction to velocity
	velocity.y += gravity * delta
	
	if is_on_floor():
		if Input.is_action_pressed("move_jump"):
#			velocity.y = jumpImpulse
			velocity.y = 0
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
	
	
	# Apply strafe acceleration to velocity and then integrate moton
	velocity += strafeDir * accel
	
	move_and_slide()

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
