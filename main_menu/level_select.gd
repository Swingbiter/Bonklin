extends Node2D

var lv_btn = preload("res://main_menu/level_button.tscn")
var main_menu_scene = "res://main_menu/main_menu.tscn"
@onready var v_box_container = $CanvasLayer/Control/ScrollContainer/VBoxContainer

var levels = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var files = DirAccess.get_files_at("res://scenes")
	for level in files:
		if level.split(".")[1] != "tscn":
			continue
		var btn = lv_btn.instantiate()
		btn.level_name = level.split(".")[0]
		btn.level_path = "res://scenes/" + level
		v_box_container.add_child(btn)


func _on_back_button_pressed():
	get_tree().change_scene_to_file(main_menu_scene)
	pass # Replace with function body.
