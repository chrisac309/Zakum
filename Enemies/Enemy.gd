extends RigidBody2D

signal die(enemy)

onready var target_movement = $TargetMovement
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var currentSprite = $Sprite
onready var attack_range = $RangeCombat/AttackRange
onready var hitbox = $RangeCombat/AttackRange/Hitbox
onready var hurtbox = $RangeCombat/Hurtbox
onready var stats = $RangeCombat/Stats

var initial_target : PhysicsBody2D
var current_target : PhysicsBody2D
var available_targets = []
var is_dead = false

func _ready():
	target_movement.connect("target_changed", self, "_on_TargetMovement_target_changed")
	stats.connect("no_health", self, "die")
	stats.connect("speed_changed", target_movement, "change_speed")
	target_movement.speed = stats.max_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	if !is_dead:
		if attack_range.overlaps_body(current_target):
			hitbox.rotate_hitbox_towards(current_target)
			animationState.travel("Attack")
		else:
			target_movement.follow()
			animationState.travel("Run")
		currentSprite.flip_h = position.x > current_target.position.x

func assign_initial_target(target:PhysicsBody2D):
	initial_target = target
	set_target(target)
	
func set_target(new_target:PhysicsBody2D):
	target_movement.set_target(new_target)

func find_next_target():
	# Get the next target, if one exists
	if !available_targets.empty():
		var nextTarget = available_targets.front()
		target_movement.set_target(nextTarget)
	else:
		# Pursue the base again
		target_movement.set_target(initial_target)
	
func die():
	emit_signal("die", self)
	is_dead = true
	animationState.travel("Die")

func add_available_target(new_target:PhysicsBody2D):
	available_targets.append(new_target)
	if !new_target.is_connected("die", self, "remove_target"):
		new_target.connect("die", self, "remove_target")
	
	# Note that this means the first target will always be priority
	if current_target == initial_target:
		set_target(new_target)

func remove_target(body:PhysicsBody2D):
	# Remove the target from the list
	if available_targets.has(body):
		available_targets.erase(body)
		if current_target == body:
			find_next_target()

func _on_TargetMovement_target_changed(body: PhysicsBody2D):
	current_target = body
