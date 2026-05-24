extends Area2D


@export var dialogue_trigger: StringName = &""

func _ready() -> void:
	body_entered.connect(_on_body_enter)


func _on_body_enter(body:Node) -> void:
	if  not body is Player: return
	var player := body as Player
	
	player.win(dialogue_trigger)
