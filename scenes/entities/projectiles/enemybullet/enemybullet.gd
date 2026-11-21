extends Area2D

signal offscreen
var shootspeed := 0
var movedir = Vector2.UP.rotated(rotation)
@export var free_when_offscreen := true 

func _process(delta: float) -> void:
	position += movedir * shootspeed * delta

func shoot(speed: int = 500):
	shootspeed = speed
	movedir = Vector2.UP.rotated(rotation)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	offscreen.emit(self)
	if free_when_offscreen:
		queue_free()
