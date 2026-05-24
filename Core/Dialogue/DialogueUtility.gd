class_name DialogueUtility extends Node


static var _balloon
static var _participating_entities = {}

# Add dialog paths here for quick access 
static var COMMON_DIALOGUE_PATHS: Dictionary[String, String] = {
	# example dialog
	"WELCOME": "res://Core/Dialogue/DialogueScripts/welcome.dialogue"
}

# Executes when script ends
static func _on_dialogue_manager_dialogue_ended(_arg):
	_balloon = null
	_participating_entities.clear()
	DialogueManager.dialogue_ended.disconnect(_on_dialogue_manager_dialogue_ended)

# Register a participant so that it can be accessed by entity_key
# in scripts for swap actions, etc.
static func register_participant(entity_key: String, entity: Node):
	if not _participating_entities.get(entity_key):
		_participating_entities.set(entity_key, entity)


# Use this to start a dialog by passing the dialog script path
# The entity is used to position the dialog box at the start
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
		
		balloon_child_node.global_position = entity.get_viewport() \
		.get_canvas_transform() * entity.global_position \
		+ Vector2(310, -50)
		
		print_debug(screen_pos)
		print_debug(balloon_child_node.global_position)
		


# Used in dialogue scripts to switch dialog bubble locations by key
# Entities must be registered for key to be present in _participating_entities
static func swap_speakers(entity_name: String):
	assert(entity_name, "Expected a valid entity_name")
	
	var entity = _participating_entities.get(entity_name)
	if entity:
		_place_dialogue_ballon_above_entity(entity)
	
