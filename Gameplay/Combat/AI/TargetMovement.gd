extends Node
class_name TargetMovement

signal target_changed(body)

# Targets
var initial_target : PhysicsBody2D
var current_target : PhysicsBody2D setget set_target
var available_targets = []
var _has_anchor = false

# Movement
var velocity : Vector2
var move_direction : Vector2
var direction_to_target : Vector2
var speed : int setget _change_speed

enum TargetType {
	FIRST,
	LAST,
	NEAR,
	FAR
}

export (TargetType) var TARGET_TYPE = TargetType.FIRST
export var TARGET_DISTANCE_MIN = 20
export var TARGET_DISTANCE_MAX = 25
export var ANCHOR_DISTANCE_MIN = 0
export var ANCHOR_DISTANCE_MAX = 25

onready var parent : RigidBody2D = get_parent()
onready var initial_follow_min = TARGET_DISTANCE_MIN
onready var initial_follow_max = TARGET_DISTANCE_MAX

func set_initial_target(target : PhysicsBody2D, is_anchor : bool):
	set_target(target)
	_has_anchor = is_anchor

func follow() -> Vector2:
	if is_away_from_anchor():
		return _travel_to_target(initial_target, ANCHOR_DISTANCE_MIN, ANCHOR_DISTANCE_MAX)
	else:
		return _travel_to_target(current_target, TARGET_DISTANCE_MIN, TARGET_DISTANCE_MAX)

func is_away_from_anchor() -> bool:
	if _has_anchor:
		var distToAnchor = parent.global_position.distance_to(initial_target.global_position)
		return distToAnchor < ANCHOR_DISTANCE_MIN || distToAnchor > ANCHOR_DISTANCE_MAX
	return false
	
func set_target(targetToFollow:PhysicsBody2D):
	current_target = targetToFollow
	if initial_target == null:
		initial_target = targetToFollow
	emit_signal("target_changed", current_target)

func add_target(new_target:PhysicsBody2D):
	available_targets.append(new_target)
	if !new_target.is_connected("die", self, "remove_target"):
		new_target.connect("die", self, "remove_target")
	
	if current_target == initial_target || TARGET_TYPE == TargetType.LAST:
		set_target(new_target)

func remove_target(body:PhysicsBody2D):
	# Remove the target from the list
	if available_targets.has(body):
		available_targets.erase(body)
		if current_target == body:
			_find_next_target()
	
func _travel_to_target(target:PhysicsBody2D, min_distance:int, max_distance:int) -> Vector2:
	var distToTarget = parent.global_position.distance_to(target.global_position)
	direction_to_target = parent.global_position.direction_to(target.global_position)
	
	if distToTarget > max_distance:
		# Move closer to the target
		move_direction = direction_to_target
	elif distToTarget < min_distance:
		# Move away from the target
		move_direction = -direction_to_target
	else:
		# Decelerate
		move_direction = Vector2.ZERO

	velocity = velocity.move_toward(move_direction * speed, 10)
	parent.linear_velocity = velocity
		
	return velocity
	
# Assigns the passed leafy to a new target depending on targeting type
func _find_next_target():
	var newTarget
	match TARGET_TYPE:
		TargetType.FIRST:
			if !available_targets.empty():
				newTarget = available_targets.front()
		TargetType.LAST:
			if !available_targets.empty():
				newTarget = available_targets.back()
		TargetType.NEAR:
			newTarget = _get_closest_target()
		TargetType.FAR:
			newTarget = _get_farthest_target()

	if newTarget != null:
		set_target(newTarget)
	else:	
		set_target(initial_target)

func _get_farthest_target():
	var farthest_enemy = null
	var max_distance = -1
	var distance_node = initial_target if _has_anchor else parent

	for enemy in available_targets:
		var distance = distance_node.global_position.distance_squared_to(enemy.global_position)
		if distance > max_distance:
			max_distance = distance
			farthest_enemy = enemy

	return farthest_enemy
	
func _get_closest_target():
	var closest_enemy = null
	var min_distance = INF
	var distance_node = initial_target if _has_anchor else parent

	for enemy in available_targets:
		var distance = distance_node.global_position.distance_squared_to(enemy.global_position)
		if distance < min_distance:
			min_distance = distance
			closest_enemy = enemy

	return closest_enemy
	
func _change_speed(value:int):
	speed = value
