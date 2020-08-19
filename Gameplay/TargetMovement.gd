extends Node

signal target_changed(body)

var target setget set_target
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var is_near_target = false

onready var parent = get_parent()

export var MAX_SPEED = 100
export var ACCELERATION = 10
export var FOLLOW_DISTANCE_MIN = 20
export var FOLLOW_DISTANCE_MAX = 25

onready var initial_follow_min = FOLLOW_DISTANCE_MIN
onready var initial_follow_max = FOLLOW_DISTANCE_MAX


func follow(_delta):
	if target != null:
		var distToTarget = parent.global_position.distance_to(target.global_position)
		
		if distToTarget > FOLLOW_DISTANCE_MAX:
			# Move closer to the target
			direction = parent.global_position.direction_to(target.global_position)
			is_near_target = false
		elif distToTarget < FOLLOW_DISTANCE_MIN:
			# Move away from the target
			direction = target.global_position.direction_to(parent.global_position)
			is_near_target = false
		else:
			# Decelerate
			is_near_target = true
			direction = Vector2.ZERO

		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
		parent.move_and_slide(velocity)

func set_target(targetToFollow:KinematicBody2D):
	target = targetToFollow
	emit_signal("target_changed", target)

func shrink_target_zone():
	FOLLOW_DISTANCE_MIN = FOLLOW_DISTANCE_MIN / 2
	FOLLOW_DISTANCE_MAX = FOLLOW_DISTANCE_MAX / 2

func reset_target_zone():
	FOLLOW_DISTANCE_MIN = initial_follow_min
	FOLLOW_DISTANCE_MAX = initial_follow_max
	
func expand_target_zone():
	FOLLOW_DISTANCE_MIN = FOLLOW_DISTANCE_MIN * 2
	FOLLOW_DISTANCE_MAX = FOLLOW_DISTANCE_MAX * 2
