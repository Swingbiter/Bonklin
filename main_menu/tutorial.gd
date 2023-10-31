extends Node2D

var main_menu_scene = "res://main_menu/main_menu.tscn"

func _on_button_pressed():
	get_tree().change_scene_to_file(main_menu_scene)
	pass # Replace with function body.
