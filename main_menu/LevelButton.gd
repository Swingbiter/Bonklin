extends Button

var level_path : String
var level_name : String

# Called when the node enters the scene tree for the first time.
func _ready():
	text = level_name
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	get_tree().change_scene_to_file(level_path)
	pass # Replace with function body.
