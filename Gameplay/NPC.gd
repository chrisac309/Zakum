extends RigidBody2D

class_name NPC

signal die(body)

enum State {
	SPAWNING,
	MOVE,
	ATTACK,
	DIE
}

onready var target_movement : TargetMovement = $TargetMovement
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var currentSprite = $Sprite
onready var attack_range = $RangeCombat/AttackRange
onready var hitbox = $RangeCombat/AttackRange/Hitbox
onready var stats = $RangeCombat/Stats

export(State) var current_state

func _ready():
	stats.connect("no_health", self, "die")
	stats.connect("speed_changed", target_movement, "_change_speed")
	target_movement.speed = stats.max_speed	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	var current_target = target_movement.get_target_or_null()
	# Note that DIE and SPAWNING states do not need to happen on a per frame basis
	match current_state:
		State.MOVE:
			move_state(current_target, state)
		State.ATTACK:
			attack_state(current_target, state)

func move_state(target:PhysicsBody2D, _state:Physics2DDirectBodyState):
	if is_instance_valid(target) && attack_range.overlaps_body(target):
		current_state = State.ATTACK
		print(name, ": ATTACK")
	else:
		var velocity = target_movement.follow()
		_determine_direction(velocity)
		if velocity.length() > 0:
			animationState.travel("Run")
		else:
			animationState.travel("Idle")
	
func attack_state(target:PhysicsBody2D, state:Physics2DDirectBodyState):
	if !is_instance_valid(target) || !attack_range.overlaps_body(target):
		current_state = State.MOVE
		print(name, ": MOVE")
	state.linear_velocity = Vector2.ZERO
	hitbox.rotate_hitbox_towards(target)
	animationState.travel("Attack")
	_determine_direction(target_movement.direction_to_target)

func die():
	current_state = State.DIE
	emit_signal("die", self)
	animationState.travel("Die")
	
func _finished_spawning():
	current_state = State.MOVE
		
func _determine_direction(vel : Vector2):
	if vel.x > 0:
		currentSprite.flip_h = false
	elif vel.x < 0:
		currentSprite.flip_h = true

