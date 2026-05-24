class_name Projectile extends Node2D

@onready var _handler: ComponentHandler = $ComponentHandler
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var wait_timer: Timer = $WaitTimer
@onready var hurt_box: HurtBox = $HurtBox

var _move: MoveComponent
var direction: Vector2 = Vector2.LEFT


func _ready() -> void:
	_move = _handler.get_component(MoveComponent)
	_move.speed = 200.0
	visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exit)
	visible_on_screen_notifier_2d.screen_entered.connect(_on_screen_enter)
	hurt_box.hurt_triggered.connect(_on_hurt_triggered)
	wait_timer.timeout.connect(_on_timeout)


func _physics_process(_delta: float) -> void:
	_move.move(direction)


func _on_screen_exit() -> void:
	wait_timer.start()


func _on_screen_enter() -> void:
	if wait_timer.is_stopped(): return
	wait_timer.stop()


func _on_timeout() -> void:
	call_deferred(&"queue_free")


func _on_hurt_triggered() -> void:
	call_deferred("queue_free")
