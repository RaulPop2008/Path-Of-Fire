extends Label

@export var outline_width: int = 8

func _ready() -> void:
	var custom_font := load("res://fonts/JimNightshade-Regular.ttf") as Font
	add_theme_font_override("font", custom_font)
	add_theme_font_size_override("font_size", 42)

	add_theme_color_override("font_color", Color("ff9913ff"))
	add_theme_color_override("font_outline_color", Color.BLACK)
	add_theme_constant_override("outline_size", outline_width)
