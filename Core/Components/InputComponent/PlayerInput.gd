class_name PlayerInput extends InputSource



func process(delta: float) -> void:
	_process_move(delta)
	_process_input(delta)


func _process_move(_delta:float) -> void:
	var move_direction: float = Input.get_axis("Move_Left", "Move_Right")
	moved.emit(move_direction)


func _process_input(_delta:float) -> void:
	if Input.is_action_just_pressed("Grab"):
		grab_pressed.emit()
	if Input.is_action_just_pressed("Jump"):
		print_debug("Jump input detected")
		jump_pressed.emit()


func input(event: InputEvent) -> void:
	#TODO: DELETE after pause menu is added
	if event.is_action_pressed(&"ui_cancel"):
		_owner.get_tree().quit()
