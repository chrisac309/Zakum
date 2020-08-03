extends KinematicBody2D

onready var target_movement = $TargetMovement
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var currentSprite = $Sprite

export var spawned = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if spawned:
		target_movement.follow(delta)
		if target_movement.velocity.length() > 0:
			animationState.travel("Run")
			currentSprite.flip_h = target_movement.velocity.x > 0
		else:
			animationState.travel("Idle")
