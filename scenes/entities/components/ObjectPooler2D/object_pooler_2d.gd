extends Node2D
class_name ObjectPooler2D
## it pools objects

@export var PooledScene: PackedScene ## the scene to pool
var _object_pool: Array

## disables the selected object's processing and hides it
func add_to_pool(object: Node2D):
	_object_pool.push_back(object)
	object.set_process(false)
	object.set_physics_process(false)
	object.hide()

## enables an object from the pool and removes it from the said pool,
## and returns the object.[br]
## if the pool is empty, then it instantiates a new object
func spawn_from_pool() -> Node2D:
	var object: Node2D
	if _object_pool.is_empty():
		object = PooledScene.instantiate()
	else:
		object = _object_pool[0]
		_object_pool.pop_back()
		object.set_process(true)
		object.set_physics_process(true)
		object.show()
	return object
