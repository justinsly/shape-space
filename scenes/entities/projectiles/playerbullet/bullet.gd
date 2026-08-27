extends Area2D

var speed = 800

func _process(delta):
	position.y -= speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area.is_in_group("enemy") && !area.is_in_group("bullet"):
		area.take_damage(1, true)
		queue_free()
