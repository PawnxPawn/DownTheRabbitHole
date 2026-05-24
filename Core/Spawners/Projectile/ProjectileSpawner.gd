class_name ProjectileSpawner extends Marker2D

signal repeat_turned_on

@export var projectile: PackedScene = null
@export var should_repeat: bool = false:
	set(value):
		should_repeat = value
		repeat_turned_on.emit()
@export var repeat_time: float = 1.0
@export var projectile_direction: Vector2 = Vector2.RIGHT

var _timer: Timer = null


func _ready() -> void:
	repeat_turned_on.connect(_set_up_timer)
	if not should_repeat: return
	_set_up_timer()

func _set_up_timer() -> void:
	if _timer: return
	
	_timer = Timer.new()
	add_child(_timer)
	_timer.one_shot = false
	_timer.start(repeat_time)
	_timer.timeout.connect(_on_timeout)


func _fire_projectile() -> void:
	var instance:Projectile = projectile.instantiate()
	instance.direction = projectile_direction
	instance.global_position = global_position
	if Services.scene_loader.scene_manager:
		Services.scene_loader.scene_manager.add_child(instance)
	else:
		add_child(instance)


func _on_timeout() -> void:
	_fire_projectile()
