extends MarginContainer

@onready var volume_slider: HSlider = $VBoxContainer/HBoxContainer/HSlider
@onready var fullscreen_menu: MenuButton = $VBoxContainer/HBoxContainer2/MenuButton
@onready var resolution_menu: MenuButton = $VBoxContainer/HBoxContainer3/MenuButton

const SETTINGS_PATH := "user://settings.cfg"

var resolutions: Array[Vector2i] = [
	Vector2i(1280, 720),Vector2i(1366, 768),
	Vector2i(1600, 900),Vector2i(1920, 1080),
	Vector2i(1920, 1200),Vector2i(2048, 1152),
	Vector2i(2560, 1080),Vector2i(2560, 1440),
	Vector2i(3440, 1440),Vector2i(3840, 2160),
]

var _current_fullscreen_id: int = 0
var _current_resolution_id: int = 0

func _ready() -> void:
	volume_slider.min_value = 0.0
	volume_slider.max_value = 1.0
	volume_slider.step = 0.05
	volume_slider.value_changed.connect(_on_volume_changed)

	fullscreen_menu.get_popup().id_pressed.connect(_on_fullscreen_selected)

	var res_popup := resolution_menu.get_popup()
	res_popup.clear()
	for i in resolutions.size():
		var res = resolutions[i]
		res_popup.add_item("%d x %d" % [res.x, res.y], i)
	res_popup.id_pressed.connect(_on_resolution_selected)

	_style_menu_button(fullscreen_menu)
	_style_menu_button(resolution_menu)
	_style_slider()

	load_settings()

func _style_menu_button(menu_button: MenuButton) -> void:
	var maroon = Color("ff9913ff")
	menu_button.add_theme_color_override("font_color", maroon)
	menu_button.add_theme_color_override("font_hover_color", Color(1.0, 0.0, 0.0, 1.0))
	menu_button.add_theme_color_override("font_pressed_color", Color(1.0, 0.0, 0.0, 1.0))
	menu_button.add_theme_color_override("font_hover_pressed_color", Color(1.0, 0.0, 0.0, 1.0))
	menu_button.add_theme_color_override("font_focus_color", maroon)

	var popup := menu_button.get_popup()
	popup.add_theme_color_override("font_color", maroon)
	popup.add_theme_color_override("font_hover_color", Color.BLACK)

	var bg_style := StyleBoxFlat.new()
	bg_style.bg_color = Color.BLACK
	popup.add_theme_stylebox_override("panel", bg_style)

	var hover_style := StyleBoxFlat.new()
	hover_style.bg_color = Color("ff9913ff")
	popup.add_theme_stylebox_override("hover", hover_style)

func _style_slider() -> void:
	var track_style := StyleBoxFlat.new()
	track_style.bg_color = Color.BLACK
	track_style.content_margin_top = 6
	track_style.content_margin_bottom = 6
	volume_slider.add_theme_stylebox_override("slider", track_style)

	var fill_style := StyleBoxFlat.new()
	fill_style.bg_color = Color("ff9913ff")
	fill_style.content_margin_top = 6
	fill_style.content_margin_bottom = 6
	volume_slider.add_theme_stylebox_override("grabber_area", fill_style)
	volume_slider.add_theme_stylebox_override("grabber_area_highlight", fill_style)

	var square_size := 20
	var img := Image.create(square_size, square_size, false, Image.FORMAT_RGBA8)
	img.fill(Color(1.0, 0.0, 0.0, 1.0))
	var square_texture := ImageTexture.create_from_image(img)
	volume_slider.add_theme_icon_override("grabber", square_texture)
	volume_slider.add_theme_icon_override("grabber_highlight", square_texture)
	volume_slider.add_theme_icon_override("grabber_disabled", square_texture)

func _on_volume_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)
	save_settings()

func _on_fullscreen_selected(id: int) -> void:
	_current_fullscreen_id = id
	match id:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			fullscreen_menu.text = "OFF"
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen_menu.text = "ON"
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			fullscreen_menu.text = "Borderless"
	save_settings()

func _on_resolution_selected(id: int) -> void:
	_current_resolution_id = id
	var res = resolutions[id]
	DisplayServer.window_set_size(res)
	resolution_menu.text = "%d x %d" % [res.x, res.y]
	save_settings()

func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "volume", volume_slider.value)
	config.set_value("display", "fullscreen_id", _current_fullscreen_id)
	config.set_value("display", "resolution_id", _current_resolution_id)
	config.save(SETTINGS_PATH)

func load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load(SETTINGS_PATH)
	if err != OK:
		volume_slider.value = 1.0
		_on_volume_changed(1.0)
		resolution_menu.text = "%d x %d" % [resolutions[0].x, resolutions[0].y]
		return

	var volume: float = config.get_value("audio", "volume", 1.0)
	volume_slider.value = volume
	_on_volume_changed(volume)

	var fullscreen_id: int = config.get_value("display", "fullscreen_id", 0)
	_on_fullscreen_selected(fullscreen_id)

	var resolution_id: int = config.get_value("display", "resolution_id", 0)
	_on_resolution_selected(resolution_id)
