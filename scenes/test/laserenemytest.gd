extends Node2D
@export var e: PackedScene
func _ready() -> void:
	var anne = e.instantiate()
	anne.initialize(randf_range(50, 758), 0)
	add_child(anne)


func _on_button_pressed() -> void:
	var anne = e.instantiate()
	anne.initialize(randf_range(50, 1024), 0)
	add_child(anne)
