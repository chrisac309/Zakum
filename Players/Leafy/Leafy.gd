extends KinematicBody2D

# Considerations to keep in mind:
# Leafy does not take damage, it has a lifespan.
# It might be worth trying a hurtbox w/ health

onready var target_movement = $TargetMovement
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var currentSprite = $Sprite
onready var enemyDetector = $EnemyDetector
onready var hitbox = $Hitbox

var spawned = false
var pursuing_enemy = false
var is_dead = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_dead:
		animationState.travel("Die")
	elif spawned:
		target_movement.follow(delta)
		if not pursuing_enemy:
			if target_movement.velocity.length() > 0:
				animationState.travel("Run")
			else:
				animationState.travel("Idle")
		elif target_movement.is_near_target:
			hitbox.rotate_hitbox_towards(target_movement.get_target())
			animationState.travel("Pollen")
	currentSprite.flip_h = target_movement.velocity.x > 0
	
func pursue_enemy():
	pursuing_enemy = true
	target_movement.shrink_target_zone()
	
func follow_stumpy():
	pursuing_enemy = false
	target_movement.reset_target_zone()
