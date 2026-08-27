extends Area2D

#=============================#
#							  #
#     WORK IN PROGRESS!!!!    #
#							  #
#=============================#



var fallaccel = 400
var curspeed := Vector2.ZERO

func shoot(speedx: float = 0, speedy: float = -550) -> void:
	curspeed.x = speedx
	curspeed.y = speedy


func _process(delta: float) -> void:
	pass
