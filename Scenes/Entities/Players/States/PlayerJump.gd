extends State

func _init() -> void:
	state_name = &"Jump"

func enter() -> void:
	_connect_components()


func exit() -> void:
	_disconnect_components()


#Signals
func _not_jumping() -> void:
	print("Transition to idle")
	#transition_to(&"Falling")
	transition_to(&"Idle")


#Helpers
func _connect_components() -> void:
	var input: InputSource = _handler.get_component(InputSource)
	var movement: MoveComponent = _handler.get_component(MoveComponent)
	var jump: JumpComponent = _handler.get_component(JumpComponent)
	var gravity: GravityComponent = _handler.get_component(GravityComponent)
	
	if gravity:
		_handler.set_active(GravityComponent, true)
	
	if input:
		_handler.set_active(InputSource, true)
	
	if movement:
		_handler.set_active(MoveComponent, true)
		input.moved.connect(movement._on_moved)
	
	if jump:
		_handler.set_active(JumpComponent, true)
		input.jump_pressed.connect(jump._on_jump)
		jump.jump_ended.connect(_not_jumping)
		
	

func _disconnect_components() -> void:
	var input:InputSource = _handler.get_component(InputSource)
	if input:
		_handler.set_active(InputSource, false)
	
	var jump: JumpComponent = _handler.get_component(JumpComponent)
	if jump:
		_handler.set_active(JumpComponent, false)
		input.jump_pressed.disconnect(jump._on_jump)
		jump.jump_ended.disconnect(_not_jumping)
	
	var gravity: GravityComponent = _handler.get_component(GravityComponent)
	if gravity:
		_handler.set_active(GravityComponent, false)
