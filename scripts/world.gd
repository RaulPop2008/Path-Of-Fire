extends Node2D

const FADE_DURATION = 1.5

func _on_dialogue_end_dialogue_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/game_ui.tscn")

func _on_dialogue_death_dialogue_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/game_ui.tscn")

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	$StaticBody2D/CollisionShape2D17.disabled=false
	$CanvasLayer/ColorRect.visible=false
	_crossfade_to($AudioStreamPlayer2)

func _on_area_2d_3_area_entered(area: Area2D) -> void:
	$AudioStreamPlayer.volume_db=0.0
	$AudioStreamPlayer.play()

func _crossfade_to(new_player: AudioStreamPlayer) -> void:
	var tween = create_tween()
	tween.tween_property($AudioStreamPlayer, "volume_db", -60.0, FADE_DURATION)
	tween.finished.connect(func(): $AudioStreamPlayer.stop())
	new_player.volume_db = -40.0
	new_player.play()
	var tween2 = create_tween()
	tween2.tween_property(new_player, "volume_db", 0.0, FADE_DURATION)
