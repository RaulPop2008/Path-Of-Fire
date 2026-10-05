extends Control

signal dialogue_finished

@onready var main_song:AudioStreamMP3=preload("res://songs/zapsplat_horror_demon_monster_evil_scream_screech_114117.mp3")
@onready var label: RichTextLabel =$Panel/RichTextLabel

var dialogue_lines: Array[String] = [
	"You Died!, a ghost found you.",
	"Try to remain hidden rather than visible",
	"PRO TIP: you can walk trough ghosts when hidden",
	"Good Luck SUBJECT!",
]
var current_line: int = 0
var is_typing: bool = false
var char_index: int = 0
var type_speed: float = 0.03
var can_type:bool=false

func _ready() -> void:
	can_type=false
	visible=false

func start_line(index: int) -> void:
	label.text = dialogue_lines[index]
	label.visible_ratio = 0.0
	char_index = 0
	is_typing = true
	_type_text()

func _type_text() -> void:
	while is_typing and char_index <= dialogue_lines[current_line].length():
		label.visible_ratio = float(char_index) / dialogue_lines[current_line].length()
		char_index += 1
		await get_tree().create_timer(type_speed).timeout
	is_typing = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and can_type==true:
		visible=false
		get_tree().change_scene_to_file("res://scenes/game_ui.tscn")
	if event.is_action_pressed("ui_accept") and can_type==true:
		if is_typing:
			skip_typing()
		else:
			advance_line()

func skip_typing() -> void:
	is_typing = false
	label.visible_ratio = 1.0

func end_dialogue() -> void:
	dialogue_finished.emit()
	queue_free()

func advance_line() -> void:
	current_line += 1
	if current_line < dialogue_lines.size():
		start_line(current_line)
	else:
		end_dialogue()

func _on_area_2d_4_area_entered(area: Area2D) -> void:
	var player:=AudioStreamPlayer.new()
	player.stream=main_song
	add_child(player)
	player.play()
	start_line(current_line)
	can_type=true
	visible=true
