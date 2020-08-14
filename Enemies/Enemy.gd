extends KinematicBody2D

# Considerations to keep in mind:
# Leafy does not take damage, it has a lifespan.
# It might be worth trying a hurtbox w/ health

onready var target_movement = $TargetMovement
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var currentSprite = $Sprite
onready var hitbox = $Hitbox
onready var rangeDetector = $RangeDetector

var initial_target
var available_targets = []
var pursuing_player = false
var is_dead = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_dead:
		animationState.travel("Die")
	else:
		target_movement.follow(delta)
		if pursuing_player && target_movement.is_near_target:
			hitbox.rotate_hitbox_towards(target_movement.get_target())
			animationState.travel("Attack")
		else:
			animationState.travel("Run")
	currentSprite.flip_h = target_movement.velocity.x < 0
	
func assign_initial_target(target:KinematicBody2D):
	initial_target = target
	target_movement.set_target(initial_target)

func _on_RangeDetector_body_entered(body):
	available_targets.append(body)
	
	# Note that this means the first target will always be priority
	if target_movement.get_target() == initial_target:
		target_movement.set_target(body)
		pursuing_player = true

func _on_RangeDetector_body_exited(body):
	# Remove the target from the list
	available_targets.erase(body)
	
	# Get the next target, if one exists
	if !available_targets.empty():
		var nextTarget = available_targets.front()
		target_movement.set_target(nextTarget)
	else:
		# Pursue the base again
		target_movement.set_target(initial_target)
		pursuing_player = false
