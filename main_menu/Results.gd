extends Node2D

@onready var lbl_level = $CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer/lbl_level
@onready var lbl_time = $CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer4/lbl_time
@onready var lbl_bonk = $CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer2/lbl_bonk
@onready var lbl_dash = $CanvasLayer/Control/PanelContainer/VBoxContainer/HBoxContainer3/lbl_dash


var main_menu = "res://main_menu/main_menu.tscn"

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	update_text()

func update_text() -> void:
	lbl_level.text = TimeKeeper.level
	lbl_time.text = TimeKeeper.get_final_time()
	lbl_bonk.text = str(TimeKeeper.bonks)
	lbl_dash.text = str(TimeKeeper.dashs)


func _on_btn_main_menu_pressed():
	get_tree().change_scene_to_file(main_menu)
	pass # Replace with function body.


func _on_btn_retry_pressed():
	get_tree().change_scene_to_file(TimeKeeper.level_path)
	pass # Replace with function body.
