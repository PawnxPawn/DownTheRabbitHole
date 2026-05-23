extends State

func _init() -> void:
	state_name = &"Move"

func enter() -> void:
	_connect_components()
	var body := _owner as Player
	if body:
		body.animation.play(&"Walk")


func exit() -> void:
	_disconnect_components()


#Signals
func _not_moving() -> void:
	transition_to(&"Idle")


func _jump_pressed() -> void:
	transition_to(&"Jump")


#Helpers
func _connect_components() -> void:
	var input:InputSource = _handler.get_component(InputSource)
	#var jump: JumpComponent = _handler.get_component(JumpComponent)
	var movement:MoveComponent = _handler.get_component(MoveComponent)
	var gravity: GravityComponent = _handler.get_component(GravityComponent)
	
	if gravity:
		_handler.set_active(GravityComponent, true)
	
	if input:
		_handler.set_active(InputSource, true)
		input.jump_pressed.connect(_jump_pressed)
	
	#if jump:
		#_handler.set_active(JumpComponent, true)
		#input.jump_pressed.connect(jump._on_jump)
	
	if movement:
		print_debug("Set move component active")
		_handler.set_active(MoveComponent, true)
		input.moved.connect(movement._on_moved)
		movement.velocity_zeroed.connect(_not_moving)
	

func _disconnect_components() -> void:
	var input:InputSource = _handler.get_component(InputSource)
	if input:
		_handler.set_active(InputSource, false)
		input.jump_pressed.disconnect(_jump_pressed)
	
	var movement:MoveComponent = _handler.get_component(MoveComponent)
	if movement:
		_handler.set_active(MoveComponent, false)
		input.moved.disconnect(movement._on_moved)
		movement.velocity_zeroed.disconnect(_not_moving)
	
	var gravity: GravityComponent = _handler.get_component(GravityComponent)
	if gravity:
		_handler.set_active(GravityComponent, false)
	
