extends Control

signal pause_accepted(has_paused:bool)

@onready var pause_panel:Control=$PauseMenu
@onready var options_panel:Control=$OptionsMenu

var is_paused:bool=false

func _ready() -> void:
	$OptionsMenu/VBoxContainer/Button.pressed.connect(on_go_back_pause_pressed)
	
	$PauseMenu/VBoxContainer/Button.pressed.connect(on_resume_pressed)
	$PauseMenu/VBoxContainer/Button2.pressed.connect(on_options_pressed)
	$PauseMenu/VBoxContainer/Button3.pressed.connect(on_quit_pressed)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and is_paused==false:
		pause_accepted.emit(true)
		is_paused=true
		$PauseMenu.visible=true
		$PauseMenu/VBoxContainer/Button.grab_focus()

func show_panel(panel:Control):
	for screen in [pause_panel,options_panel] :
		screen.visible=(screen==panel)

func on_go_back_pause_pressed():
	$PauseMenu/VBoxContainer/Button.grab_focus()
	show_panel(pause_panel)

func on_resume_pressed():
	pause_accepted.emit(false)
	is_paused=false
	$PauseMenu.visible=false

func on_options_pressed():
	$OptionsMenu/VBoxContainer/Button.grab_focus()
	show_panel(options_panel)

func on_quit_pressed():
	$PauseMenu.visible=false
	get_tree().change_scene_to_file("res://scenes/game_ui.tscn")
