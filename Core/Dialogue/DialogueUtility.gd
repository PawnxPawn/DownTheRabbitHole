class_name DialogueUtility extends Node

static var _balloon
static var _participating_entities: Dictionary[String, Player] = {}
static var _callbacks: Array[Callable] = []

# Add dialog paths here for quick access 
static var COMMON_DIALOGUE_PATHS: Dictionary[String, String] = {
	# example dialog
	"WELCOME": "res://Core/Dialogue/DialogueScripts/welcome.dialogue",
	
	# Game dialog files
	"LEVEL_ONE_BEGIN": "res://Core/Dialogue/DialogueScripts/level_one_begin.dialogue",
	"LEVEL_ONE_END": "res://Core/Dialogue/DialogueScripts/level_one_end.dialogue",
	"LEVEL_TWO_BEGIN": "res://Core/Dialogue/DialogueScripts/level_one_begin.dialogue",
	"LEVEL_TWO_END": "res://Core/Dialogue/DialogueScripts/level_one_end.dialogue",
	"LEVEL_THREE_BEGIN": "res://Core/Dialogue/DialogueScripts/level_one_begin.dialogue",
	"LEVEL_THREE_END": "res://Core/Dialogue/DialogueScripts/level_one_end.dialogue",
}

# Executes when script ends
static func _on_dialogue_manager_dialogue_ended(_arg):
	_change_player_state_from_talk_to_idle()
	_execute_callbacks()
	
	_balloon = null
	_participating_entities.clear()
	_callbacks.clear()
	DialogueManager.dialogue_ended.disconnect(_on_dialogue_manager_dialogue_ended)


static func _execute_callbacks():
	for callback in _callbacks:
		callback.call()

static func _change_player_state_to_talk():
	var player: Player = _participating_entities.get("player")
	if player and player._sm.current_state.state_name != &"Talk":
		print_debug("Changed player state to Talk")
		player._sm.current_state.transition_to(&"Talk")

static func _change_player_state_from_talk_to_idle():
	#for participant_key in _participating_entities:
		#var participant = _participating_entities.get(participant_key)
		#if participant and participant
			
	# Change the state from Talk to Idle
	var player: Player = _participating_entities.get("player")
	if player and player._sm.current_state.state_name == &"Talk":
		print_debug("Changed player state from Talk to Idle")
		player._sm.current_state.transition_to(&"Idle")


# Register a participant so that it can be accessed by entity_key
# in scripts for swap actions, etc.
static func register_participant(entity_key: String, entity: Player):
	if not _participating_entities.get(entity_key):
		_participating_entities.set(entity_key, entity)


static func register_callback(callback):
	_callbacks.push_back(callback)


# Use this to start a dialog by passing the dialog script path
# If an entity is passed, the dialogue balloon is positioned above the entity
# Otherwise, the global dialogue balloon is used
static func start_dialogue(path: String, entity: Node = null):
	assert(path, "Expected a valid path, but received: '" + path + "'.")
	var dialog_res = load(path)
	
	if entity:
		print_debug("Entity passed. Initializing dialog above entity.")
		var balloon = DialogueManager.show_dialogue_balloon(dialog_res)
		_balloon = balloon
		
		# Set size scale
		balloon.scale = Vector2(0.3, 0.3)
		_place_dialogue_ballon_above_entity(entity)
	else:
		print_debug("No entity passed. Initializing global dialog.")
		var balloon_scene = load("res://Core/Dialogue/DialogueBalloon/global_balloon.tscn")
		DialogueManager.show_dialogue_balloon_scene(balloon_scene,
			dialog_res
		)
	
	# Change the player's state to Talk
	_change_player_state_to_talk()
		
	# Add listener when dialog reaches the end
	DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)


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
	
