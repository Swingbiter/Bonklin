extends CanvasLayer

@onready var label_speed = $Control/Label_Speed
@onready var label_time = $Control/Label_Time
@onready var texture_progress_bar = $Control/TextureProgressBar
@onready var label_dashs = $Control/Label_Dashs


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	label_speed.text = str(floor(get_parent().velocity.length_squared()))
	texture_progress_bar.value = get_parent().dashs
	label_dashs.text = str(get_parent().dashs)
	label_time.text = TimeKeeper.get_current_time()
