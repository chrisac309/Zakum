extends KinematicBody2D

onready var target_movement = $TargetMovement
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var currentSprite = $Sprite
onready var rangeDetector = $RangeDetector
onready var attack_range = $AttackRange
onready var hitbox = $AttackRange/Hitbox

var initial_target : KinematicBody2D
var current_target : KinematicBody2D
var available_targets = []
var is_dead = false
var attack_target = false

func _ready():
	target_movement.connect("target_changed", self, "_on_TargetMovement_target_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_dead:
		animationState.travel("Die")
	elif attack_range.overlaps_body(current_target):
		hitbox.rotate_hitbox_towards(current_target)
		animationState.travel("Attack")
	else:
		target_movement.follow(delta)
		animationState.travel("Run")
	currentSprite.flip_h = position.x > current_target.position.x
	
func assign_initial_target(target:KinematicBody2D):
	initial_target = target
	target_movement.set_target(initial_target)

func _on_RangeDetector_body_entered(body):
	available_targets.append(body)
	
	# Note that this means the first target will always be priority
	if current_target == initial_target:
		target_movement.set_target(body)

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


func _on_AttackRange_body_entered(body: KinematicBody2D):
	if (body == current_target):
		attack_target = true
	
func _on_TargetMovement_target_changed(body: KinematicBody2D):
	current_target = body
	print("Current target updated!")
