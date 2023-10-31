extends OmniLight3D

@export var properties : Dictionary

func _ready():
	omni_range = 15.0
	light_indirect_energy = 16
	if "range" in properties:
		omni_range = float(properties["range"])
