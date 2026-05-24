class_name SceneLoader

enum Scenes {
	MAIN_MENU,
	LEVEL_ONE,
	LEVEL_TWO,
	LEVEL_THREE
}

const _PRELOADED_SCENES = {
	Scenes.MAIN_MENU: preload("uid://dpr8yeruxbl0h"),
	Scenes.LEVEL_ONE: preload("uid://w7rthkqnxb3w"),
	Scenes.LEVEL_TWO: preload("uid://b0i643fc0mtxx"),
	Scenes.LEVEL_THREE: preload("uid://0x1cq8hkktby"),
}


var scene_manager: Node

var is_transitioning: bool = false
var current_scene:Scenes
var _loaded_scenes:Dictionary = {}


func load_scene(scene:Scenes) -> void:
	if not scene_manager:
		push_error("SceneLoader: %s can't load because SceneManager is not set.")
		return
	
	is_transitioning = true
	_swap_scene(scene)
	
	is_transitioning = false



func _swap_scene(scene: Scenes) -> void:
	
	_clean_up()
	
	var instance = _PRELOADED_SCENES[scene].instantiate()
	scene_manager.add_child(instance)
	_loaded_scenes[scene] = instance
	current_scene = scene


func _clean_up() -> void:
	if not _loaded_scenes.is_empty():
		for key in _loaded_scenes:
			_loaded_scenes[key].queue_free()
		_loaded_scenes.clear()

func _scene_manager_check() -> bool:
	if not scene_manager:
		push_error("SceneLoader: Can't load new scenes because scene_manager is not set.")
		return false
	return true
