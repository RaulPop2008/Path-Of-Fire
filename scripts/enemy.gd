extends CharacterBody2D

const SPEED=45
const ARRIVE_THRESHOLD=6

var current_animation:String
var new_animation:String
var is_chasing:bool=false
var player:Node2D=null
var facing_direction:int=1

@onready var starting_position=global_position

func _physics_process(delta: float) -> void:
	animation()
	if abs(velocity.y)>abs(velocity.x):
		if velocity.y>0:
			facing_direction=1
		else:
			facing_direction=-1
	else:
		if velocity.x>0:
			facing_direction=2
		else:
			facing_direction=-2
	if is_chasing==true and player:
		var direction=(player.global_position-global_position).normalized()
		velocity=direction*SPEED
	else:
		var direction=starting_position-global_position
		if direction.length()>ARRIVE_THRESHOLD:
			velocity=direction.normalized()*SPEED
		else:
			velocity=Vector2.ZERO
			global_position=starting_position
	move_and_slide()

func animation():
	current_animation="idle_"+str(facing_direction)
	if current_animation!=new_animation:
		new_animation=current_animation
		$AnimatedSprite2D.play(new_animation)

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	player=area.get_parent()
	is_chasing=true

func _on_area_2d_2_area_exited(area: Area2D) -> void:
	is_chasing=false
