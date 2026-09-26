extends Node2D

const BCFEATHERBULLET = preload("uid://c5f1woqna2qsw")
@onready var marker_2d: Marker2D = $Marker2D
@onready var label: Label = $Label

func _on_timer_timeout() -> void:
	var bullet = BCFEATHERBULLET.instantiate()
	bullet.position = marker_2d.position
	add_sibling(bullet)
	bullet.shoot(randf_range(-35, 35), randf_range(-5, -10))

func _on_button_pressed() -> void:
	Engine.max_fps = 45

func _on_button_2_pressed() -> void:
	Engine.max_fps = 60

func _process(_delta: float) -> void:
	label.text = str(Engine.get_frames_per_second())

func _on_button_3_pressed() -> void:
	Engine.max_fps = 30
