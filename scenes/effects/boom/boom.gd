extends Sprite2D

func act(speed: float = 1.0):
	$boomanimate.play("boom", -1, speed)
	#print("playing boom")


func _on_boomanimate_animation_finished(anim_name):
	if anim_name == "boom":
		#print("boom gone")
		queue_free()
