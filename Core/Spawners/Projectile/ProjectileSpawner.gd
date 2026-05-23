class_name ProjectileSpawner extends Marker2D

@export var projectile: PackedScene = null
@export var should_repeat: bool = false
@export var repeat_time: float = 1.0

var _timer: Timer = null


func _ready() -> void:
	if not should_repeat: return
	
	_timer = Timer.new()
	add_child(_timer)
	_timer.one_shot = false
	_timer.start(repeat_time)
	_timer.timeout.connect(_on_timeout)


func _fire_projectile() -> void:
	var instance:Node = projectile.instantiate()
	add_child(instance)


func _on_timeout() -> void:
	_fire_projectile()
