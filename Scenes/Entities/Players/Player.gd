extends Entity

@onready var _sm: StateMachine = %StateMachine
@onready var _handler: ComponentHandler = %ComponentHandler
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	_set_sm()


func _set_sm() -> void:
	_sm.init(_handler)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	_handler.integrate_forces(state)
