extends KinematicBody2D

# Considerations to keep in mind:
# Leafy does not take damage, it has a lifespan.
# It might be worth trying a hurtbox w/ health

signal die(body)

onready var target_movement = $TargetMovement
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var currentSprite = $Sprite
onready var attack_range = $RangeCombat/AttackRange
onready var hitbox = $RangeCombat/AttackRange/Hitbox
onready var stats = $RangeCombat/Stats

var spawned = false
var pursuing_enemy = false
var is_dead = false
var current_target : PhysicsBody2D

func _ready():
	stats.connect("no_health", self, "die")
	target_movement.connect("target_changed", self, "_on_TargetMovement_target_changed");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !is_dead:
		if spawned:
			if pursuing_enemy && attack_range.overlaps_body(current_target):
				hitbox.rotate_hitbox_towards(current_target)
				animationState.travel("Pollen")
			else:
				target_movement.follow(delta)
				if target_movement.velocity.length() > 0:
					animationState.travel("Run")
				else:
					animationState.travel("Idle")
		currentSprite.flip_h = target_movement.velocity.x > 0

func pursue_enemy():
	pursuing_enemy = true
	target_movement.shrink_target_zone()
	
func follow_stumpy():
	pursuing_enemy = false
	target_movement.reset_target_zone()
	
func die():
	is_dead = true
	emit_signal("die", self)
	animationState.travel("Die")
	
func _on_TargetMovement_target_changed(body: PhysicsBody2D):
	current_target = body
