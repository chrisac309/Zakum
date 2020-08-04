extends KinematicBody2D

onready var target_movement = $TargetMovement
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var currentSprite = $Sprite
onready var enemyDetector = $EnemyDetector

var spawned = false
var pursuing_enemy = false
export var is_dead = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if spawned:
		target_movement.follow(delta)
		if not pursuing_enemy:
			if target_movement.velocity.length() > 0:
				animationState.travel("Run")
			else:
				animationState.travel("Idle")
		elif target_movement.is_near_target:
			animationState.travel("Pollen")
	currentSprite.flip_h = target_movement.velocity.x > 0
	
func pursue_enemy():
	pursuing_enemy = true
	target_movement.shrink_target_zone()
	
func follow_stumpy():
	pursuing_enemy = false
	target_movement.reset_target_zone()

func _on_Lifespan_timeout():
	animationState.travel("Die")
