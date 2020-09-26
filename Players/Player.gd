extends KinematicBody2D

class_name Player
#const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

signal die(player)

enum {
	MOVE,
	ATTACK,
	SPECIAL
}

var state = MOVE
var hunter_type = PlayerData.HunterName.Stumpy
var velocity = Vector2.ZERO
var inertia = 10

onready var stats : Stats = $Combat/Stats
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	stats.connect("no_health", self, "die")
	animationTree.active = true

func _physics_process(_delta):
	match state:
		MOVE:
			move_state()
		SPECIAL:
			special_state()
		ATTACK:
			attack_state()
		
func move_state():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	velocity = determine_velocity(input_vector)
	# All of the optional values are the default, except infinite inertia
	var _linear_velocity = move_and_slide(velocity, Vector2.ZERO, false, 4, 0.785398, false)
	push_enemies()
	
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
		return velocity.move_toward(input_vector * stats.speed, 10)
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

func push_enemies():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("Enemy"):
			collision.collider.apply_central_impulse(-collision.normal * stats.inertia)
	
func die():
	emit_signal("die", self)
	queue_free()
