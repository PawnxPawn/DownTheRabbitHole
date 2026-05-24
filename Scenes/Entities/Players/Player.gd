class_name Player extends Entity

@onready var _sm: StateMachine = %StateMachine
@onready var _handler: ComponentHandler = %ComponentHandler
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Hitbox = $Hitbox
@onready var pickup_component: PickupComponent = $PickupComponent


@onready var health_progress_bar: TextureProgressBar = $CanvasLayer/HealthProgressBar
@onready var time_to_text: TextToPng = $CanvasLayer/TimeToText
@onready var time_to_text_shadow: TextToPng = $CanvasLayer/TimeToText/TimeToTextShadow


@export var starting_health_time: float = 120.0
@onready var timer: Timer = $Timer
@onready var iframe_timer: Timer = $IframeTimer
@onready var cake: Timer = $Cake
@onready var cookie: Timer = $Cookie
@onready var drink: Timer = $Drink


var health: HealthComponent
var damage_loss_multiplyier: float = 1.0

func _ready() -> void:
	_set_sm()
	_connect_signals()
	health_progress_bar.value = 100.0
	
	DialogueUtility.register_participant("player", self)
	DialogueUtility.start_dialogue(
		DialogueUtility.COMMON_DIALOGUE_PATHS["WELCOME"],
		self
	)


func _set_sm() -> void:
	_sm.init(_handler)



func _connect_signals() -> void:
	var input: InputSource = _handler.get_component(InputSource)
	if input:
		input.moved.connect(_on_moved)
	
	health = _handler.get_component(HealthComponent)
	if health:
		health.hp_changed.connect(_on_health_changed)
		health.died.connect(_die)
		health.max_health = starting_health_time
		health.hp = starting_health_time
	
	hitbox.damaged.connect(_take_damage.bind(-3.0 / damage_loss_multiplyier, false))
	
	timer.timeout.connect(_take_damage.bind(-1.0 / damage_loss_multiplyier))
	pickup_component.item_pickuped.connect(_on_item_pickuped)
	cake.timeout.connect(_powerup_timeout.bind(&"CAKE"))
	cookie.timeout.connect(_powerup_timeout.bind(&"COOKIE"))
	drink.timeout.connect(_powerup_timeout.bind(&"DRINK"))


func _on_moved(direction:float) -> void:
	if direction <= -0.1:
		animation.flip_h = true
	elif direction >= 0.1:
		animation.flip_h = false


func _on_health_changed() -> void:
	var current_percentage = (health.hp/health.max_health) * 100.0
	health_progress_bar.value = current_percentage
	var minutes:int = int(health.hp / 60)
	var seconds: int = int(health.hp) % 60
	var current_time_left = "%d M %d S" % [minutes, seconds]
	time_to_text.text = current_time_left
	time_to_text_shadow.text = time_to_text.text


func _take_damage(amount: float, is_time_damage:bool = true) -> void:
	if is_time_damage:
		health.hp += amount
	else:
		if iframe_timer.is_stopped():
			iframe_timer.start()
			health.hp += amount
			_sm.change_state(&"Hurt")

func _die() -> void:
	pass

func _on_item_pickuped(item:StringName) -> void:
	
	if not cake.is_stopped() or not drink.is_stopped() or not cookie.is_stopped(): return
	match item:
		&"CAKE":
			scale += Vector2(.25, .25)
			damage_loss_multiplyier = 2.0
			cake.start()
			return
		&"COOKIE":
			cookie.start()
			return
		&"DRINK":
			scale -= Vector2(.25, .25)
			var move: MoveComponent = _handler.get_component(MoveComponent)
			move.speed += 10
			drink.start()
			return


func _powerup_timeout(powerup: StringName) -> void:
	match powerup:
		&"CAKE":
			scale -= Vector2(.25, .25)
			damage_loss_multiplyier = 1.0
			return
		&"COOKIE":
			return
		&"DRINK":
			scale += Vector2(.25, .25)
			var move: MoveComponent = _handler.get_component(MoveComponent)
			move.speed -= 10
			return
