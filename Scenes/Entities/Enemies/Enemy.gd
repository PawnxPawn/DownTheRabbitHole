class_name Enemy extends Entity


enum EnemyType {
	BlueFlower,
	BluePuff,
	OrangeFlower,
	OrangePuff,
	PinkFlower,
	PinkPuff,
	PurpleFlower,
	PurplePuff,
	CardClub,
	CardDiamond,
	CardHeart,
	CardSpade,
}

enum States_Type {
	PATROL,
	TEA_TOSS
}


@onready var _handler: ComponentHandler = %ComponentHandler
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var directional_timer: Timer = $"DirectionalTimer"
@onready var projectile_spawner: ProjectileSpawner = $ProjectileSpawner


@export var enemy_type: EnemyType
@export var set_state: States_Type
@export var patrol_direction_time: float = 2.0
@export var direction: float = 1.0
@export_range(-1.0, 1.0, 2.0) var facing_direction: float = 1.0

var move:MoveComponent
var gravity:GravityComponent


func _ready() -> void:
	if int(enemy_type) >= 8:
		scale = Vector2(2.0,2.0)
	_connect_signals()
	_change_direction()
	if set_state == States_Type.PATROL:
		_set_up_timer()
		move = _handler.get_component(MoveComponent)
		move.speed = 80
	elif set_state == States_Type.TEA_TOSS:
		var enemy_type_string: String = EnemyType.keys()[enemy_type]
		var animation_name: String = "%s_Patrol" % enemy_type_string
		animation.animation = animation_name
		animation.frame = 0
		projectile_spawner.should_repeat = true
		projectile_spawner.repeat_time = 2.0
	gravity = _handler.get_component(GravityComponent)
	if gravity:
		_handler.set_active(GravityComponent, true)


func _connect_signals() -> void:
	directional_timer.timeout.connect(_on_patrol_end)



func _set_up_timer() -> void:
	var enemy_type_string: String = EnemyType.keys()[enemy_type]
	var animation_name: String = "%s_Patrol" % enemy_type_string 
	animation.play(animation_name)
	directional_timer.start(patrol_direction_time)
	


func _physics_process(_delta: float) -> void:
	if move:
		move._on_moved(direction)


func _on_patrol_end() -> void:
	if directional_timer.wait_time != patrol_direction_time:
		directional_timer.wait_time = patrol_direction_time
	facing_direction = direction
	_change_direction()
	direction = -direction


func _change_direction() -> void:
	if facing_direction <= -0.1:
		animation.flip_h = true
		if projectile_spawner.position.x < 0.1:
			projectile_spawner.position.x = -projectile_spawner.position.x 
			projectile_spawner.projectile_direction = Vector2.LEFT
	elif facing_direction >= 0.1:
		animation.flip_h = false
		if projectile_spawner.position.x > -0.1:
			projectile_spawner.position.x = -projectile_spawner.position.x
			projectile_spawner.projectile_direction = Vector2.RIGHT
	
