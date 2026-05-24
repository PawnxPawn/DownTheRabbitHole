extends State

func _init() -> void:
	state_name = &"Win"

func enter() -> void:
	var body := _owner as Player
	body.animation.play(&"Curtsy")
