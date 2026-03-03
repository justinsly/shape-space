extends Enemy

func _process(delta):
	position.y += speed * delta

func _on_knock_timer_timeout():
	set_process(true)

func _on_damage_taken(_dmg_amount, _oldhealth):
	if health <= 0:
		explode(true)


func _on_area_entered(area: Area2D):
	if area.is_in_group("player"):
		take_knockback()
		set_process(false)
