extends CharacterBody2D

@export var movement_speed: float = 200.0
var state = "standing" # standing / searching / attacking
var aiCooldown = false

@onready var _navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var _enemy_animation: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	_navigation_agent.path_desired_distance = 4.0
	_navigation_agent.target_desired_distance = 4.0
	
func _process(delta: float) -> void:
	if velocity.length() == 0:
		_enemy_animation.stop()
		return
	
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0:
			_enemy_animation.play("walk_right")
		else:
			_enemy_animation.play("walk_left")
	else:
		if velocity.y > 0:
			_enemy_animation.play("walk_down")
		else:
			_enemy_animation.play("walk_up")
		

func _physics_process(delta: float):
	if (!aiCooldown):
		_ai_process.call_deferred()
	
	var player: Player = get_node("%Player")
	if (player == null): return
	_navigation_agent.target_position = player.position
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = _navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
	
func _ai_process():
	var player: Player = get_node("%Player")
	if (player == null):
		return
	var distance = position.distance_to(player.position)
	
	if (distance >= 100):
		movement_speed = 0
		state = "standing"
	elif (distance < 25 && state == "searching"):
		aiCooldown = true
		movement_speed = 0
		state = "standing"
		await get_tree().create_timer(0.5).timeout
		aiCooldown = false
		
		movement_speed = 200
		state = "attacking"
	elif (distance < 500 && state == "standing"):
		movement_speed = 50
		state = "searching"
