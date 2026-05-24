class_name Player extends Entity

@onready var _sm: StateMachine = %StateMachine
@onready var _handler: ComponentHandler = %ComponentHandler
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	_set_sm()
	_connect_signals()
	
	
	DialogueUtility.start_dialogue(
		DialogueUtility.COMMON_DIALOGUE_PATHS["WELCOME"],
		self
	)


func _set_sm() -> void:
	_sm.init(_handler)



func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	_handler.integrate_forces(state)


func _connect_signals() -> void:
	var input: InputSource = _handler.get_component(InputSource)
	if input:
		input.moved.connect(_on_moved)


func _on_moved(direction:float) -> void:
	if direction <= -0.1:
		animation.flip_h = true
	elif direction >= 0.1:
		animation.flip_h = false
