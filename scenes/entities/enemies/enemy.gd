extends Area2D
class_name Enemy
## The enemy class... used to create enemies
##
## comes with properties that should be useful for quickly making basic enemies.[br]
## [b]note:[/b] to make this class properly interact with the player and their projectiles, make sure to set the enemy's collision layer to 3 and set the mask to 2

signal damage_taken(dmg_amount: int, oldhealth: int) ## emitted by [method Enemy.take_damage]. [param dmg_amount] is the amount of damage that was dealt, [param oldhealth] is the health before the damage was dealt
signal knockback_taken ## emitted by [method Enemy.take_knockback]

@export var max_health: int = 1 ## the starting health for the enemy
@export var speed: int = 250 ## do i need to write a description for this
@export var score: int = 1 ## seriously
@export var bounce_on_hit: bool ## determines if the enemy should move backward a little bit upon hitting the player
@export var drop_heal_item_on_death: bool ## determines if the enemy should drop the healing item upon being destroyed
@export var bounce_on_damage: bool ## determines if the enemy should move backward upon taking damage
@export var boom_speed_mult: float = 1.5 ## the multiplier to apply to the explosion effect's speed
@export_group("nodes")
@export var knock_timer: Timer ## the knock timer, that knock timer, the timer used specifically to tell how long should a knockback go, that timer
@export_group("Preloaded Scenes")
@export var sceneboom: PackedScene ## explosion effect scene
@export var sceneheal: PackedScene ## the healing item scene to be dropped
var health := 1

func _ready():
	health = max_health

## normally should be run by whatever is handling the spawning of the enemies, repositions the enemy to the given [param startposx] and [param startposy] coordinates
func initialize(startposx: float, startposy: float):
	position.x = startposx
	position.y = startposy

## emits [signal Enemy.damage_taken] and passes the [code]dmg[/code]
## argument to the said signal when called.[br]
## intended to be used by other scenes interacting with this enemy
func take_damage(dmg: int = 1, override_damage_bounce = bounce_on_damage):
	var oldhealth = health
	health -= dmg
	if override_damage_bounce:
		take_knockback()
	damage_taken.emit(dmg, oldhealth)


## activates [member Enemy.knock_timer] and causes the enemy to go backward for the duration of the timer every 0.01 * [param delta] seconds if [member Enemy.bounce_on_hit] is true (the distance per step in pixels depends on [param pixels_per_step] * delta)[br]
## [br][b]note:[/b] [param delta] is only calculated once when this function is called, but i dont think that should be a problem[br]
## [b]double note:[/b] make sure to temporarily disable whatever could be moving the enemy forward, since it would cause the enemy to resist the knockback
func take_knockback(pixels_per_step: float = 200):
	if !bounce_on_hit:
		return
	var delta = get_process_delta_time() 
	knockback_taken.emit()
	knock_timer.start()
	while knock_timer.time_left > 0:
		if !get_tree().paused:
			position.y -= pixels_per_step * delta
		await get_tree().create_timer(0.01 * delta).timeout

## spawns [member Enemy.sceneboom] at the enemy position, drops the heal item if [param dropstuff] and [member Enemy.drop_heal_item_on_death] is true, adds [param score] to the player's score, and then deletes itself
func explode(dropstuff: bool = true, overridescore: int = score):
	var boom = sceneboom.instantiate()
	boom.position = position
	add_sibling(boom)
	boom.act(boom_speed_mult)
	if drop_heal_item_on_death and playervars.health < 3 and dropstuff:
		# if the player's health is not full, roll a chance to drop a healing item
		if randf_range(0, 12) <= 4:
			var healitem = sceneheal.instantiate()
			healitem.position = position
			call_deferred("add_sibling", healitem)
	playervars.score += overridescore
	queue_free()
