extends AnimatedSprite2D

signal finished

enum RoseBushs{
	BIG_ROSEBUSH,
	SMALL_ROSEBUSH,
}

@export var rose_bush_type: RoseBushs

var player_in_area: bool = false
var completed: bool = false

var _time_in_area: float  = 0.0
var _max_time: float = 0.0

var big_rose_time = 4.0
var small_rose_time = 2.0


func _ready() -> void:
	match rose_bush_type:
		RoseBushs.BIG_ROSEBUSH:
			_max_time = big_rose_time
			animation = &"RosesOne"
		RoseBushs.SMALL_ROSEBUSH:
			_max_time = small_rose_time
			animation = &"RosesTwo"


func _process(delta: float) -> void:
	if not player_in_area or completed: return

	_time_in_area = min(_time_in_area + delta, _max_time)
	
	print(_time_in_area)
	var frames_count: int = sprite_frames.get_frame_count(animation)
	var progress: float = _time_in_area / _max_time
	var frame_index = clamp(int(progress * (frames_count -1)),0, frames_count - 1)
	frame = frame_index
	
	completed = _time_in_area == _max_time
	if completed:
		finished.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_area = false
