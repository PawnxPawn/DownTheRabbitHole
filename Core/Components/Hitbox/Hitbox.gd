class_name Hitbox extends Area2D

signal damaged

func hit_triggere() -> void:
	print("Ouch")
	damaged.emit()
