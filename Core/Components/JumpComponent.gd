class_name JumpComponent extends Component

signal jump_ended

var _jump_speed: float = 350.0
var _is_midair: bool = false

func _on_jump() -> void:
	if _owner is CharacterBody2D:
		_jump_action()


func _jump_action() -> void:
	print_debug("Jump action activated")
	var body := _owner as CharacterBody2D
	if not body: return
	if _is_midair: return
	
	_is_midair = true
	body.velocity.y -= _jump_speed
	body.move_and_slide()
	
	var audio_manager = AudioManager.AUDIO_MANAGER_INSTANCE
	if audio_manager:
		audio_manager.play_sound(
			AudioManager.AudioType.TEMPORARY,
			AudioManager.COMMON_SOUND_PATHS.JUMP_SOUND_EFFECT
		)
	

func physics_process(_delta: float) -> void:
	var body := _owner as CharacterBody2D
	if body.velocity.y >= 0:
		#print_debug("Jump ended")
		jump_ended.emit()


func integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	# For RigidBody only
	pass


func set_is_midair(is_midair: bool):
	_is_midair = is_midair
