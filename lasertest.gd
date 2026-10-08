extends Node2D
@onready var component_laser: ComponentLaser = $ComponentLaser

func _ready() -> void:
	component_laser.startcharge()

func _process(delta: float) -> void:
	component_laser.rotate(0.5 * delta)
