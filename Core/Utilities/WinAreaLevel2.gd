extends Area2D


@export var dialogue_trigger: StringName = &""

var bushes_completed = false

func _ready() -> void:
	body_entered.connect(_on_body_enter)


func _on_body_enter(body:Node) -> void:
	print("Win1")
	if  not body is Player: return
	var player := body as Player
	print("Win2")
	if bushes_completed:
		print("Win3")
		player.win()
