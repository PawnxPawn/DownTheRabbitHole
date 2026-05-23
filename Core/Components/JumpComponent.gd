class_name JumpComponent extends Component

signal jump_ended

var jump_speed: float = 350.0

func _on_jump() -> void:
	if _owner is CharacterBody2D:
		_jump_action()


func _jump_action() -> void:
	print_debug("Jump action activated")
	var body := _owner as CharacterBody2D
	if not body: return
	
	body.velocity.y -= jump_speed
	body.move_and_slide()
	

func physics_process(_delta: float) -> void:
	var body := _owner as CharacterBody2D
	if body.velocity.y >= 0:
		print_debug("Jump ended")
		jump_ended.emit()

func integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	# For RigidBody only
	pass
