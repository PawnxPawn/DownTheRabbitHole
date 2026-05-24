extends Node2D

@onready var rose_bushs: Node = $RoseBushs
@onready var win_area: Area2D = $WinArea

var total_bushes: int = 0
var completed_bushs: int = 0

var are_bushes_completed: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for bush in rose_bushs.get_children():
		bush.finished.connect(_completed_bush)
	total_bushes = rose_bushs.get_child_count()


func _completed_bush() -> void:
	completed_bushs += 1
	if completed_bushs == total_bushes:
		are_bushes_completed = true
		win_area.bushes_completed = are_bushes_completed
