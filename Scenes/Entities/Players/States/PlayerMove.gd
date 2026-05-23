extends State

func _init() -> void:
	state_name = &"Move"

func enter() -> void:
	_connect_components()


func exit() -> void:
	_disconnect_components()


#Signals
func _not_moving() -> void:
	transition_to(&"Idle")


#Helpers
func _connect_components() -> void:
	var input:InputSource = _handler.get_component(InputSource)
	var movement:MoveComponent = _handler.get_component(MoveComponent)
	var gravity: GravityComponent = _handler.get_component(GravityComponent)
	
	if gravity:
		_handler.set_active(GravityComponent, true)
	
	if input:
		_handler.set_active(InputSource, true)
	
	if movement:
		_handler.set_active(MoveComponent, true)
		input.moved.connect(movement._on_moved)
		movement.velocity_zeroed.connect(_not_moving)
	

func _disconnect_components() -> void:
	var input:InputSource = _handler.get_component(InputSource)
	if input:
		_handler.set_active(InputSource, false)
	
	var movement:MoveComponent = _handler.get_component(MoveComponent)
	if movement:
		_handler.set_active(MoveComponent, false)
		input.moved.disconnect(movement._on_moved)
		movement.velocity_zeroed.disconnect(_not_moving)
	
	var gravity: GravityComponent = _handler.get_component(GravityComponent)
	if gravity:
		_handler.set_active(GravityComponent, false)
	
