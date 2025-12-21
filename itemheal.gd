extends Area2D

var speed = 65

func _ready():
	$AnimatedSprite2D.play("default")

func _process(delta):
	position.y += speed * delta

func _on_area_entered(area):
	if area.is_in_group("plritem"):
		if playervars.health < 3:
			playervars.health += 1
			area.get_parent().heal.emit()
		queue_free()


func _on_timer_timeout():
	speed = 210
