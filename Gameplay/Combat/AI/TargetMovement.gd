extends Node

signal target_changed(body)

var target : PhysicsBody2D setget set_target
var velocity = Vector2.ZERO
var move_direction = Vector2.ZERO
var direction_to_target = Vector2.ZERO
var is_near_target = false
var speed : int

export var FOLLOW_DISTANCE_MIN = 20
export var FOLLOW_DISTANCE_MAX = 25

onready var parent : RigidBody2D = get_parent()
onready var initial_follow_min = FOLLOW_DISTANCE_MIN
onready var initial_follow_max = FOLLOW_DISTANCE_MAX

func follow():
	if target != null:
		var distToTarget = parent.global_position.distance_to(target.global_position)
		direction_to_target = parent.global_position.direction_to(target.global_position)
		
		if distToTarget > FOLLOW_DISTANCE_MAX:
			# Move closer to the target
			move_direction = direction_to_target
			is_near_target = false
		elif distToTarget < FOLLOW_DISTANCE_MIN:
			# Move away from the target
			move_direction = -direction_to_target
			is_near_target = false
		else:
			# Decelerate
			is_near_target = true
			move_direction = Vector2.ZERO

		velocity = velocity.move_toward(move_direction * speed, 10)
		parent.linear_velocity = velocity

func target_is_in_range() -> bool:
	var distToTarget = parent.global_position.distance_to(target.global_position)
	return distToTarget < FOLLOW_DISTANCE_MAX && distToTarget > FOLLOW_DISTANCE_MIN

func set_target(targetToFollow:PhysicsBody2D):
	target = targetToFollow
	emit_signal("target_changed", target)

func change_speed(value:int):
	speed = value

func shrink_target_zone():
	FOLLOW_DISTANCE_MIN = FOLLOW_DISTANCE_MIN / 2
	FOLLOW_DISTANCE_MAX = FOLLOW_DISTANCE_MAX / 2

func reset_target_zone():
	FOLLOW_DISTANCE_MIN = initial_follow_min
	FOLLOW_DISTANCE_MAX = initial_follow_max
	
func expand_target_zone():
	FOLLOW_DISTANCE_MIN = FOLLOW_DISTANCE_MIN * 2
	FOLLOW_DISTANCE_MAX = FOLLOW_DISTANCE_MAX * 2
