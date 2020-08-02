extends KinematicBody2D

#const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
const LeafyScene = preload("res://Players/Leafy.tscn")

export var ACCELERATION = 10
export var MAX_SPEED = 80
export var FRICTION = 1
export var SPAWNING_RANGE = 75


enum {
	MOVE,
	ATTACK,
	SPECIAL
}

var state = MOVE
var velocity = Vector2.ZERO
var stats = PlayerStats
var spawnedLeafy = []

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hitbox = $PlayerHitbox
onready var hurtbox = $Hurtbox

func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	hitbox.knockback_vector = Vector2.DOWN

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		SPECIAL:
			special_state()
		ATTACK:
			attack_state()
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		hitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Special/blend_position", input_vector)
		animationState.travel("Walk")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
	else:
		animationState.travel("Idle")
		velocity
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	move(delta)
	
	if Input.is_action_just_pressed("special"):
		state = SPECIAL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func special_state():
	velocity = Vector2.ZERO
	animationState.travel("Special")

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move(delta):
	move_and_collide(velocity * delta)

func special_animation_finished():
	state = MOVE

func attack_animation_finished():
	state = MOVE
	
func spawn_leafy():
	var leafy = LeafyScene.instance()
	leafy.position = position + Vector2(randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2, randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2)
	leafy.set_target(self)
	get_parent().add_child(leafy)
	spawnedLeafy.append(leafy)

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
#	var playerHurtSound = PlayerHurtSound.instance()
#	get_tree().current_scene.add_child(playerHurtSound)
#
#func _on_Hurtbox_invincibility_started():
#	blinkAnimationPlayer.play("Start")
#
#func _on_Hurtbox_invincibility_ended():
#	blinkAnimationPlayer.play("Stop")
