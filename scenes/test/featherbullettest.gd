extends Node2D

const BCFEATHERBULLET = preload("uid://c5f1woqna2qsw")
@onready var marker_2d: Marker2D = $Marker2D

func _on_timer_timeout() -> void:
	var bullet = BCFEATHERBULLET.instantiate()
	bullet.position = marker_2d.position
	add_sibling(bullet)
	bullet.shoot(randf_range(-40, 40), randf_range(-5, -10))
