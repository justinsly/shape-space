extends Enemy
@onready var shoottimer: Timer = $Timer
@export var scenebullet: PackedScene
var shotbullets := 0

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", position.y + 100, 1)
	tween.tween_callback(startshooting)

func ascend() -> void:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:y", position.y - 200, 1)
	tween.tween_callback(self.queue_free)

func startshooting() -> void:
	shoottimer.start()

func _on_timer_timeout() -> void:
	shotbullets += 1
	var bullet = scenebullet.instantiate()
	bullet.position = position
	add_sibling(bullet)
	bullet.shoot(randf_range(-50, 50), randf_range(-19, -20))
	if shotbullets >= 26:
		shoottimer.stop()
		await get_tree().create_timer(0.5).timeout
		ascend()

func _on_die() -> void:
	explode(true)
