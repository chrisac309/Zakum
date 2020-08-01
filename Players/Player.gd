extends KinematicBody2D

const ACCELERATION = 100
const MAX_SPEED = 100
const FRICTION = 25

enum CharacterState {MOVE, ATTACK, SPECIAL}
export(CharacterState) var state


var velocity = Vector2.ZERO

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	animationTree.active = true

	 # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
	match state:
		CharacterState.MOVE:
			move_state(delta)
			
		CharacterState.ATTACK:
			attack_state(delta)
			
		CharacterState.SPECIAL:
			special_state(delta)
			
func _physics_process(delta):
	velocity = move_and_slide(velocity)

func move_state(delta):
	var input_vector = Vector2.ZERO
	# Get and normalize our input
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationState.travel("Walk")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
		
	if Input.is_action_just_pressed("attack"):
		state = CharacterState.ATTACK

func attack_state(delta):
	animationState.travel("Attack")
	velocity = Vector2.ZERO
	
func on_attack_finished():
	state = CharacterState.MOVE
	
func special_state(delta):
	pass
