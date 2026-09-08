extends Area2D
## this bullet scene has its own primitive physics built into it
## why? HELL IF I KNOW
## gonna let that be a question for future me

var fallaccel = 40
var curspeed := Vector2.ZERO
var maxfallspeed := 50.0

func shoot(speedx: float = 0, speedy: float = -20) -> void:
	curspeed = Vector2(speedx, speedy)


func _process(delta: float) -> void:
	curspeed.y += fallaccel * delta
	if curspeed.y > maxfallspeed:
		curspeed.y = maxfallspeed
	if curspeed.x > 0:
		curspeed.x -= 0.5
	elif curspeed.x < 0:
		curspeed.x += 0.5
	position += curspeed * 0.5
