extends Node

var target = null
var velocity = Vector2.ZERO
var direction = Vector2.ZERO

onready var parent = get_parent()

export var MAX_SPEED = 80
export var ACCELERATION = 50
export var FOLLOW_DISTANCE_MIN = 20
export var FOLLOW_DISTANCE_MAX = 25

func follow(delta):
	if target != null:
		var distToTarget = parent.global_position.distance_to(target.global_position)
		
		if distToTarget > FOLLOW_DISTANCE_MAX:
			# Move closer to the target
			direction = parent.global_position.direction_to(target.global_position)
		elif distToTarget < FOLLOW_DISTANCE_MIN:
			# Move away from the target
			direction = target.global_position.direction_to(parent.global_position)
		else:
			# Decelerate
			direction = Vector2.ZERO

		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
		parent.move_and_slide(velocity)

func set_target(targetToFollow:KinematicBody2D):
	target = targetToFollow
