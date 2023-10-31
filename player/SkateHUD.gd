extends CanvasLayer

@onready var lbl_speed = $Control/lbl_speed


func _physics_process(delta):
	lbl_speed.text = str(floor(get_parent().velocity.length_squared()))
	pass
