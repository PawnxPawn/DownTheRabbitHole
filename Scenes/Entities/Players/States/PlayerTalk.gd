extends State


func _init():
	state_name = &"Talk"

func enter() -> void:
	print_debug("Talk")
	_connect_components()


func exit() -> void:
	_disconnect_components()

func _connect_components() -> void:
	var input: InputSource = _handler.get_component(InputSource)
	var movement: MoveComponent = _handler.get_component(MoveComponent)
	var jump: JumpComponent = _handler.get_component(JumpComponent)
	var gravity: GravityComponent = _handler.get_component(GravityComponent)
	
	if input:
		_handler.set_active(InputSource, false)
		
	if movement:
		_handler.set_active(MoveComponent, false)
	
	if jump:
		_handler.set_active(JumpComponent, false)
	
	if gravity:
		_handler.set_active(GravityComponent, true)
	

func _disconnect_components():
	pass
