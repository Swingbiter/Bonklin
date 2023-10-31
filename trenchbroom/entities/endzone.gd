extends Area3D

@export var properties : Dictionary

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if "player" in body.get_groups():
		Signals.emit_signal("time_finished")
