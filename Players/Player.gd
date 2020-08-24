extends KinematicBody2D

#const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

signal die(player)

enum {
	MOVE,
	ATTACK,
	SPECIAL
}

var state = MOVE
var speed = 0
var velocity = Vector2.ZERO

onready var stats : Stats = $Combat/Stats
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var enemyCollider = $EnemyCollider
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	stats.connect("no_health", self, "die")
	stats.connect("speed_changed", self, "change_speed")
	enemyCollider.connect("enemy_colliding", self, "add_colliding_enemy")
	enemyCollider.connect("enemy_left", self, "remove_colliding_enemy")
	speed = stats.max_speed
	animationTree.active = true

func _physics_process(delta):
	if state == MOVE:
		move_state(delta)
	elif state == SPECIAL:
		special_state()
	elif state == ATTACK:
		attack_state()	
		
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	velocity = determine_velocity(input_vector)
	var _col = move_and_collide(velocity * delta)
	
	if Input.is_action_just_pressed("special"):
		state = SPECIAL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
func determine_velocity(input_vector) -> Vector2:
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Special/blend_position", input_vector)
		animationState.travel("Walk")
		return velocity.move_toward(input_vector * speed, 10)
	else:
		animationState.travel("Idle")
		return velocity.move_toward(Vector2.ZERO, 10)

func special_state():
	velocity = Vector2.ZERO
	animationState.travel("Special")
	if Input.is_action_just_released("special"):
		state = MOVE

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_animation_finished():
	state = MOVE
	
func change_speed(value:int):
	speed = value
	
func die():
	emit_signal("die", self)
	queue_free()
