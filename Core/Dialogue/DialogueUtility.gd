class_name DialogueUtility extends Node

static var _balloon
static var _participating_entities = {}

static var COMMON_DIALOGUE_PATHS: Dictionary[String, String] = {
	"WELCOME": "res://Core/Dialogue/welcome.dialogue"
}


static func _on_dialogue_manager_dialogue_ended():
	_balloon = null
	_participating_entities.clear()


static func start_dialogue(path: String, entity: Node):
	assert(path, "Expected a valid path, but received: '" + path + "'.")
	assert(entity, "Expected a character node.")
	
	var dialog_res = load(path)
	var balloon = DialogueManager.show_dialogue_balloon(dialog_res)
	_balloon = balloon
	
	# Add listener when dialog reaches the end
	DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)
	
	# Set size scale
	balloon.scale = Vector2(0.3, 0.3)
	_place_dialogue_ballon_above_entity(entity)


static func _place_dialogue_ballon_above_entity(entity: Node):
	if _balloon:
		var balloon_child_node = _balloon.get_node("Balloon")
		var screen_pos = entity.get_global_transform_with_canvas().get_origin()
		balloon_child_node.global_position = screen_pos + Vector2(250, -50)


static func swap_speakers(entity_name: String):
	assert(entity_name, "Expected a valid entity_name")
	
	var entity = _participating_entities.get(entity_name)
	if entity:
		_place_dialogue_ballon_above_entity(entity)
	
