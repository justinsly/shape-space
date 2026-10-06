extends Window
@onready var enemykills: Label = $enemykills
@onready var bulletsfired: Label = $bulletsfired
@onready var timesdied: Label = $timesdied
func _ready() -> void:
	if true:
		queue_free()

func _process(_delta: float) -> void:
	enemykills.text = "enmykill: %s" % str(playervars.enemiesdefeated)
	bulletsfired.text = "bltfired: %s" % str(playervars.bulletsfired)
	timesdied.text = "timesdied: %s" % str(playervars.timesdied)


func _on_close_requested() -> void:
	queue_free()
