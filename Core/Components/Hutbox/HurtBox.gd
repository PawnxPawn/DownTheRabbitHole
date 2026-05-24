class_name HurtBox extends Area2D

signal hurt_triggered

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area:Node2D) -> void:
	if not area is Hitbox: return
	var hitbox := area as Hitbox
	hitbox.hit_triggere()
	hurt_triggered.emit()
