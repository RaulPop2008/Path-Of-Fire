extends Control

signal dialogue_finished

@onready var label: RichTextLabel =$Panel/RichTextLabel

var dialogue_lines: Array[String] = [
	"To skip the entire cutscene press ESC, to skip/move on with the dialogue press ENTER or SPACE",
	"As the last firebender left alive, you've been kidnapped, with the purpose of being a lab rat",
	"After many painful months you were promised freedom under one condition: clear the maze ahead and reach the fireplace",
	"It is also important to note that the this maze is filled with blind ghosts that are sensitive to light",
	"To navigate trought the maze you must use your powers in order to create light, not using your powers results in safety, but with loss of vision",
	"Good luck SUBJECT!",
	"!!!Note: this game does not have any saving, quitting will result in the restart of the game"
]
var current_line: int = 0
var is_typing: bool = false
var char_index: int = 0
var type_speed: float = 0.03

func _ready() -> void:
	start_line(current_line)

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
	if event.is_action_pressed("ui_cancel"):
		visible=false
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			skip_typing()
		else:
			advance_line()
		get_viewport().set_input_as_handled()

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
