extends Area2D

var shootspeed := 0
var movedir = Vector2.UP.rotated(rotation)

func _process(delta: float) -> void:
	position += movedir * shootspeed * delta

func shoot(speed: int = 500):
	shootspeed = speed
	movedir = Vector2.UP.rotated(rotation)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
