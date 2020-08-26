extends RigidBody2D

class_name Leafy

# Considerations to keep in mind:
# Leafy does not take damage, it has a lifespan.
# It might be worth trying a hurtbox w/ health

signal die(body)

enum State {
	SPAWNING,
	MOVE,
	ATTACK,
	DIE
}

onready var target_movement = $TargetMovement
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var currentSprite = $Sprite
onready var attack_range = $RangeCombat/AttackRange
onready var hitbox = $RangeCombat/AttackRange/Hitbox
onready var stats = $RangeCombat/Stats

export var current_state = State.SPAWNING

var current_target : PhysicsBody2D

func _ready():
	stats.connect("no_health", self, "die")
	stats.connect("speed_changed", target_movement, "change_speed")
	target_movement.connect("target_changed", self, "_on_TargetMovement_target_changed");
	target_movement.speed = stats.max_speed	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(_state):
	# Note that DIE and SPAWNING states do not need to happen on a per frame basis
	match current_state:
		State.MOVE:
			move_state()
		State.ATTACK:
			attack_state()

func move_state():
	if target_movement.target_is_in_range() && attack_range.overlaps_body(current_target):
		current_state = State.ATTACK
	else:
		var velocity = target_movement.follow()
		determine_direction(velocity)
		if velocity.length() > 0:
			animationState.travel("Run")
		else:
			animationState.travel("Idle")
	
func attack_state():
	hitbox.rotate_hitbox_towards(current_target)
	animationState.travel("Attack")
	determine_direction(target_movement.direction_to_target)
	
func die():
	current_state = State.DIE
	emit_signal("die", self)
	animationState.travel("Die")
	
func _on_TargetMovement_target_changed(body: PhysicsBody2D):
	current_target = body
	
func finished_spawning():
	current_state = State.MOVE

func finished_attack():
	if !(target_movement.target_is_in_range() && attack_range.overlaps_body(current_target)):
		current_state = State.MOVE
		
func determine_direction(vel : Vector2):
	if vel.x > 0:
		currentSprite.flip_h = true
	elif vel.x < 0:
		currentSprite.flip_h = false
