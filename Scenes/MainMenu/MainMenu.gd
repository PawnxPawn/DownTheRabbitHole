extends Control

@onready var buttons: VBoxContainer = %Buttons
@onready var title: VBoxContainer = %Title
@onready var texture_sprite_frames: TextureSpriteFrames = $TextureSpriteFrames

@export var fps: float = 2.5
var _frame: int = 0
var _elapsed:float = 0.0

func _ready() -> void:
	Services.game_state.change_game_state(GameState.GameStates.MAIN_MENU)
	_connect_signals()


func _process(delta: float) -> void:
	_elapsed += delta
	if _elapsed >= 1.0 / fps:
		_elapsed = 0.0
		_frame = (_frame + 1) % texture_sprite_frames.sprite_frames.get_frame_count("default")
		texture_sprite_frames.texture = texture_sprite_frames.sprite_frames.get_frame_texture("default", _frame)


func _connect_signals() -> void:
	for button in buttons.get_children():
		if not button is Button and not button is TextureButton: continue
		button.button_up.connect(_on_button_pressed.bind(button))
	
	Services.ui.ui_hidden.connect(_on_ui_hidden)


func _on_button_pressed(button: Node) -> void:
	match button.name:
		&"NewGame":
			_new_game()
		&"Options":
			title.visible = false
			Services.ui.show_ui(UI.Uis.GAME_SETTINGS)
		&"Exit":
			get_tree().quit()


func _new_game() ->void:
	Services.game_state.change_game_state(GameState.GameStates.PLAYING)
	Services.scene_loader.load_scene(SceneLoader.Scenes.LEVEL_ONE)


func _on_ui_hidden(ui:UI.Uis) -> void:
	match ui:
		UI.Uis.GAME_SETTINGS:
			title.visible = true


func _disconnect_external_signals() -> void:
	Services.ui.ui_hidden.disconnect(_on_ui_hidden) 

func _exit_tree() -> void:
	_disconnect_external_signals()
