extends Area2D

var speed = 250

func _process(delta):
	position.y += speed * delta

func initialize(startposx: float, startposy: float):
	position.x = startposx
	position.y = startposy


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("player"):
		print("i touched player")
		var delta = get_process_delta_time() 
		$KnockTimer.start()
		set_process(false)
		while $KnockTimer.time_left > 0:
			position.y -= 150 * delta
			await get_tree().create_timer(0.01 * delta).timeout

func _on_knock_timer_timeout():
	set_process(true)
