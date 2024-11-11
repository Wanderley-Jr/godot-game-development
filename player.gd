extends CharacterBody2D
class_name Player

signal hit

@export var movement_speed = 400
var screen_size: Vector2

@onready var _player_animation: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		_player_animation.play("walk_left")
	elif Input.is_action_pressed("move_right"):
		_player_animation.play("walk_right")
	elif Input.is_action_pressed("move_up"):
		_player_animation.play("walk_up")
	elif Input.is_action_pressed("move_down"):
		_player_animation.play("walk_down")
	else:
		_player_animation.stop()

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x += -1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		velocity.y += -1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * movement_speed
		move_and_slide()
