extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
var player: Node2D

@export var radius_lit:float=0.33
@export var radius_unlit:float=0.15
@export var transition_speed:float=4.0

var is_free:bool=false
var current_radius:float=0.22
var target_radius:float=0.22

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	current_radius = radius_lit
	target_radius = radius_lit
	color_rect.material.set_shader_parameter("radius", current_radius)

func _process(delta: float) -> void:
	if is_free==true:
		return
	if player == null:
		return
	var viewport_size = get_viewport().get_visible_rect().size
	var screen_pos = player.get_global_transform_with_canvas().origin
	var uv_pos = screen_pos / viewport_size
	color_rect.material.set_shader_parameter("player_screen_pos", uv_pos)
	current_radius = lerp(current_radius, target_radius, transition_speed * delta)
	color_rect.material.set_shader_parameter("radius", current_radius)

func set_torch_lit(lit: bool) -> void:
	target_radius = radius_lit if lit else radius_unlit

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	is_free=true
