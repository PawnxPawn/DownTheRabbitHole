#TODO: Add multiline printing
@tool
class_name TextToPng extends Control

enum AlignmentType {
	LEFT,
	CENTER,
	RIGHT
}

@export var alphabet_scene:PackedScene = preload("uid://dujnx5rlqblmx")

@export_multiline() var text: String = "Hello World":
	set(value):
		text = value
		_string_to_png()

@export var font_size: int = 32:
	set(value):
		font_size = value
		_string_to_png()

@export var seperation: int:
	set(value):
		seperation = value
		_string_to_png()

@export var alignment: AlignmentType:
	set(value):
		alignment = value
		_string_to_png()


var _text_frame_indexs: Array[int]
var _default_seperation: int = -7
var _current_hbox:HBoxContainer
var _vbox: VBoxContainer
var _hboxes: Array[HBoxContainer]

func _ready() -> void:
	_string_to_png()


func _string_to_png() -> void:
	_set_alphabet_to_frame_index()
	_add_hbox()
	_add_letters()


func _set_alphabet_to_frame_index() -> void:
	_text_frame_indexs.clear()
	for c in text:
		_text_frame_indexs.append(AlphabetToFrame._get_character_frame_index(c))
	


func _add_hbox() -> void:
	if _vbox:
		_vbox.queue_free()
	_hboxes.clear()
	
	_vbox = VBoxContainer.new()
	add_child(_vbox)
	
	
	_new_hbox_line()


func _new_hbox_line() -> void:
	var text_line: HBoxContainer = HBoxContainer.new()
	var separation_total: int = _default_seperation + seperation
	var size_percentage = font_size/100.0
	var new_size:Vector2 = Vector2(size_percentage, size_percentage)
	
	_vbox.scale = new_size
	text_line.name = "Line"
	text_line.add_theme_constant_override("separation", separation_total)
	
	match alignment:
		AlignmentType.LEFT:
			text_line.alignment = BoxContainer.ALIGNMENT_BEGIN
		AlignmentType.CENTER:
			text_line.alignment = BoxContainer.ALIGNMENT_CENTER
		AlignmentType.RIGHT:
			text_line.alignment = BoxContainer.ALIGNMENT_END
	
	_vbox.add_child(text_line)
	_current_hbox = text_line


func _add_letters() -> void:
	for c in text:
		if c == "\n":
			_new_hbox_line()
			continue
		var frame_index = AlphabetToFrame._get_character_frame_index(c)
		_letter_to_frame(frame_index, c)


func _letter_to_frame(letter_index:int, letter:String = "") -> void:
	var letter_sprite_frame: TextureSpriteFrames = alphabet_scene.instantiate()

	letter_sprite_frame.frame_index = letter_index
	letter_sprite_frame.name = letter + " Letter"
	_current_hbox.add_child(letter_sprite_frame)
