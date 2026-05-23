extends Node2D

@onready var _handler: ComponentHandler = $ComponentHandler

var _move: MoveComponent
var direction: Vector2 = Vector2.LEFT


func _ready() -> void:
	_move = _handler.get_component(MoveComponent)
	_move.speed = 200.0


func _physics_process(_delta: float) -> void:
	_move.move(direction)
