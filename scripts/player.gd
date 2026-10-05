extends CharacterBody2D

const SPEED = 120

var walk_up:bool=false
var walk_down:bool=false
var walk_left:bool=false
var walk_right:bool=false

var torch_lit:bool=false
var facing_direction:int=1
var can_move:bool=true
var current_animation:String
var new_animation:String
var vision_mask:Node
var is_paused:bool=false
var is_disabled:bool=false

func _ready():
	vision_mask = get_tree().get_first_node_in_group("vision_mask")
	if vision_mask:
		vision_mask.set_torch_lit(torch_lit)

func _physics_process(delta: float):
	if is_paused==false:
		if is_disabled==true:
			$Area2D/CollisionShape2D.disabled=true
		actions()
		movement()
		animation(delta)
	else:
		velocity=Vector2.ZERO
		$AnimatedSprite2D.play("idle_"+str(facing_direction))
	move_and_slide()

func actions():
	if Input.is_action_just_pressed("light_up"):
		torch_lit=!torch_lit
		$Area2D/CollisionShape2D.disabled=!torch_lit
		$Area2D4/CollisionShape2D.disabled=!torch_lit
		if vision_mask:
			vision_mask.set_torch_lit(torch_lit)

func movement():
	if can_move==false:
		return
	if Input.is_action_pressed("move_up") and not Input.is_action_pressed("move_down"):
		facing_direction=-1
		velocity.y=-SPEED
		walk_up=true
		walk_down=false
	elif Input.is_action_pressed("move_down") and not Input.is_action_pressed("move_up"):
		facing_direction=1
		velocity.y=SPEED
		walk_down=true
		walk_up=false
	else:
		velocity.y=0
		walk_up=false
		walk_down=false
	if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		facing_direction=-2
		velocity.x=-SPEED
		walk_left=true
		walk_right=false
	elif Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		facing_direction=2
		velocity.x=SPEED
		walk_right=true
		walk_left=false
	else:
		velocity.x=0
		walk_right=false
		walk_left=false

func animation(delta):
	current_animation="idle_"+str(facing_direction)
	if walk_up==true:
		current_animation="walk_up"
	if walk_down==true:
		current_animation="walk_down"
	if walk_left==true:
		current_animation="walk_left"
	if walk_right==true:
		current_animation="walk_right"
	if current_animation!=new_animation:
		new_animation=current_animation
		$AnimatedSprite2D.play(new_animation)

func _on_pause_ui_pause_accepted(has_paused: bool) -> void:
	$Area2D/CollisionShape2D.disabled=has_paused
	is_paused=has_paused

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	is_disabled=true
