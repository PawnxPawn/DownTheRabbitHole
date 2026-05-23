extends State

func _init() -> void:
	state_name = &"Idle"

func enter() -> void:
	_connect_components()


func exit() -> void:
	_disconnect_components()


#Signals
func _on_moved(direction:float) -> void:
	if not direction: return
	transition_to(&"Move")
	

func _on_jump() -> void:
	print_debug("Transition to jump state")
	transition_to(&"Jump") # Transition to jump state


#Helpers
func _connect_components() -> void:
	var input:InputSource = _handler.get_component(InputSource)
	var gravity:GravityComponent = _handler.get_component(GravityComponent)
	
	
	if input:
		_handler.set_active(InputSource, true)
		input.moved.connect(_on_moved)
		input.jump_pressed.connect(_on_jump) # Connect jump signal to _on_jump method
		
	
	if gravity:
		_handler.set_active(GravityComponent, true)
	

func _disconnect_components() -> void:
	var input:InputSource = _handler.get_component(InputSource)
	if input:
		_handler.set_active(InputSource, false)
		input.moved.disconnect(_on_moved)
		input.jump_pressed.disconnect(_on_jump)
	
	var gravity:GravityComponent = _handler.get_component(GravityComponent)
	if gravity:
		_handler.set_active(GravityComponent, false)
