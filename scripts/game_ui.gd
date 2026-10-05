extends Control

@onready var main_panel:Control=$MainMenu
@onready var options_panel:Control=$OptionsMenu
@onready var controls_panel:Control=$ControlsMenu
@onready var credits_panel:Control=$CreditsMenu

@onready var main_song:AudioStreamWAV=preload("res://songs/I deffinetly came.wav")

func _ready() -> void:
	var player:=AudioStreamPlayer.new()
	player.stream=main_song
	add_child(player)
	player.play()
	player.finished.connect(player.play)
	$MainMenu/VBoxContainer/Button.pressed.connect(on_start_pressed)
	$MainMenu/VBoxContainer/Button2.pressed.connect(on_options_pressed)
	$MainMenu/VBoxContainer/Button5.pressed.connect(on_controls_pressed)
	$MainMenu/VBoxContainer/Button3.pressed.connect(on_credits_pressed)
	$MainMenu/VBoxContainer/Button4.pressed.connect(on_quit_pressed)

	$OptionsMenu/VBoxContainer/Button.pressed.connect(on_go_back_main_pressed)
	$ControlsMenu/VBoxContainer/Button.pressed.connect(on_go_back_main_pressed)
	$CreditsMenu/MarginContainer/VBoxContainer/Button.pressed.connect(on_go_back_main_pressed)

func show_panel(panel:Control):
	for screen in [main_panel,options_panel,controls_panel,credits_panel]:
		screen.visible=(screen==panel)

func on_go_back_main_pressed():
	show_panel(main_panel)

func on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func on_options_pressed():
	show_panel(options_panel)

func on_controls_pressed():
	show_panel(controls_panel)

func on_credits_pressed():
	show_panel(credits_panel)

func on_quit_pressed():
	get_tree().quit()
