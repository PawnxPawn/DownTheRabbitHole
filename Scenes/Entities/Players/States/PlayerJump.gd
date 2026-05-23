extends State

func _init() -> void:
	state_name = &"Jump"

func enter() -> void:
	print_debug("PlayerJump.enter")
	_connect_components()


func exit() -> void:
	print_debug("PlayerJump.exit")
	_disconnect_components()


#Signals
func _not_jumping() -> void:
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
		print_debug("Set jump component active")
		_handler.set_active(JumpComponent, true)
		jump._on_jump()
	

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
