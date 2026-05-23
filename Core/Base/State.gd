class_name State extends RefCounted

var state_name:StringName = &""

var _sm: StateMachine
var _owner: Node


var _handler: ComponentHandler


func _setup(sm: StateMachine, parent: Node, handler: ComponentHandler) -> void:
	_sm = sm
	_owner = parent
	_handler = handler
func enter() -> void:
	pass


func exit() -> void:
	pass


#func process_input(_event: InputEvent) -> void:
	#pass


func process_frame(_delta: float) -> void:
	pass


func process_physics(_delta: float) -> void:
	pass


func transition_to(name: StringName) -> void:
	_sm.change_state(name)
