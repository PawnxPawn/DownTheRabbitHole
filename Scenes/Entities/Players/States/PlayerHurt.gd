extends State

func _init() -> void:
	state_name = &"Hurt"

func enter() -> void:
	var body := _owner as Player
	body.animation.play(&"Idle")
	_hurt_flash()


func _hurt_flash() -> void:
	var body := _owner as Player
	var sprite: AnimatedSprite2D = body.animation
	
	var tween: Tween = body.create_tween()
	tween.set_loops(3)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.1) 
	tween.tween_property(sprite, "modulate:a", 1.0, 0.1)
	tween.finished.connect(func(): transition_to(&"Idle")) 
