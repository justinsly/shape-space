extends Node2D
@export var e: PackedScene
func _ready() -> void:
	var anne = e.instantiate()
	anne.initialize(350, 0)
	add_child(anne)
