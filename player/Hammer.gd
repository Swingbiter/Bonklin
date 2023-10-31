extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player = $AudioStreamPlayer

@export var attack_rate : float = 0.2

var attack_timer : Timer
var can_attack : bool = true 

# Called when the node enters the scene tree for the first time.
func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_rate
	attack_timer.connect("timeout", finish_attack)
	attack_timer.one_shot = true
	add_child(attack_timer)
	
	
	pass # Replace with function body.

func finish_attack():
	can_attack = true
	audio_stream_player.play()

func bonk():
	if !can_attack:
		return
	
	can_attack = false           
	animation_player.stop()
	animation_player.play("bonk")
	attack_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
