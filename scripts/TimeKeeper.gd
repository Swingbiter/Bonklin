extends Node

var results_scene = "res://main_menu/Results.tscn"

var start_time : float = 0
var end_time : float = 0

var bonks : int = 0
var dashs : int = 0
var level : String = ""
var level_path = ""

func _ready():
	Signals.time_started.connect(start_run)
	Signals.time_finished.connect(end_run)
	Signals.got_killed.connect(restart_run)
	Signals.bonked.connect(bonked)
	Signals.dashed.connect(dashed)
	pass

func start_run() -> void:
	start_time = Time.get_ticks_msec()
	level_path = get_tree().current_scene.scene_file_path
	bonks = 0
	dashs = 0

func end_run() -> void:
	end_time = Time.get_ticks_msec()
	level = get_tree().current_scene.name
	get_tree().change_scene_to_file(results_scene)
	

func restart_run() -> void:
	start_time = Time.get_ticks_msec()
	get_tree().reload_current_scene()

func get_current_time() -> String:
	return get_time_string(start_time, Time.get_ticks_msec())

func get_time_string(start: float, end: float) -> String:
	var elapsed = end - start
	var secs = elapsed / 1000.0
	
	return str(snappedf(secs, 0.01))

func get_final_time() -> String:
	return get_time_string(start_time, end_time)
	

func bonked() -> void:
	bonks += 1

func dashed() -> void:
	dashs += 1
