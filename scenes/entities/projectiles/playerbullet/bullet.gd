extends Area2D

var speed = 800

func _process(delta):
	position.y -= speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


# TODO: change up this code to account for possible future enemies with extra health and enemies that doesnt explode on the spot
func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.explode()
		area.queue_free()
		playervars.score += 1
		queue_free()
