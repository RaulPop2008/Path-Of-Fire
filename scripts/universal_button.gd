extends Button

@export var outline_width:int=12

func _ready() -> void:
	add_theme_color_override("font_outline_color", Color.BLACK)
	add_theme_constant_override("outline_size", outline_width)
	var empty_style := StyleBoxEmpty.new()
	add_theme_stylebox_override("normal", empty_style)
	add_theme_stylebox_override("hover", empty_style)
	add_theme_stylebox_override("pressed", empty_style)
	add_theme_stylebox_override("focus", empty_style)
	add_theme_stylebox_override("disabled", empty_style)

	add_theme_color_override("font_color", Color("ff9913ff"))
	add_theme_color_override("font_hover_color", Color(1.0, 0.0, 0.0, 1.0))
	add_theme_color_override("font_pressed_color", Color(1.0, 0.0, 0.0, 1.0))
	add_theme_color_override("font_focus_color", Color("ff9913ff"))
	
	var custom_font := load("res://fonts/JimNightshade-Regular.ttf") as Font
	add_theme_font_override("font", custom_font)
	add_theme_font_size_override("font_size", 36)
