extends Node
class_name TargetMovement

signal target_changed(body)

enum TargetType {
	FIRST,
	LAST,
	NEAR,
	FAR
}

# Targets
var _current_target : PhysicsBody2D: get = get_target_or_null, set = _set_target
var _available_targets = []
@export var TARGET_TYPE: TargetType = TargetType.FIRST
@export var TARGET_DISTANCE_MIN = 20
@export var TARGET_DISTANCE_MAX = 25

# Locked target
var _locked_target : PhysicsBody2D
var _has_target_lock = false
var _lock_until_in_range = false

# Leader
var _leader : PhysicsBody2D
var _has_leader = false
var _leader_follow_min : int
var _leader_follow_preferred_max : int
var _leader_follow_max : int

# Movement
var velocity : Vector2
var move_direction : Vector2
var direction_to_target : Vector2
var speed : int: set = _change_speed

@onready var parent : RigidBody2D = get_parent()

# Acts as an override for targetting a specific unit
# If lock_until_in_range is true, this will override until the target is in distance range 
func lock_follow(target:PhysicsBody2D, lock_until_in_range: bool):
	_has_target_lock = true
	if !_available_targets.has(target):
		add_target(target)
	_locked_target = target
	_lock_until_in_range = lock_until_in_range
	
func unlock_follow():
	_has_target_lock = false
	_find_next_target()

# Follow priority is as follows:
# 1) Locked target
# 2) Leader, if too far
# 3) Current target, if a target exists
# 4) Leader, if no targets
func follow() -> Vector2:
	_find_next_target()
	if _has_target_lock:
		return _travel_to_target(_locked_target, TARGET_DISTANCE_MIN, TARGET_DISTANCE_MAX)
	elif _has_leader && is_instance_valid(_leader) && _is_far_from_leader():
		return _travel_to_target(_leader, _leader_follow_min, _leader_follow_max)
	elif is_instance_valid(_current_target):
		
		return _travel_to_target(_current_target, TARGET_DISTANCE_MIN, TARGET_DISTANCE_MAX)
	elif is_instance_valid(_leader):
		return _travel_to_target(_leader, _leader_follow_min, _leader_follow_preferred_max)
	else:
		return Vector2.ZERO
	
func set_leader(leader:PhysicsBody2D, leader_min_follow, leader_preferred_max_follow, leader_max_follow, available_targets) -> void:
	_leader = leader
	_leader_follow_min = leader_min_follow
	_leader_follow_preferred_max = leader_preferred_max_follow
	_leader_follow_max = leader_max_follow
	_has_leader = true
	_available_targets = available_targets

func get_target_or_null() -> PhysicsBody2D:
	return _current_target if !_has_target_lock else _locked_target

func add_target(new_target:PhysicsBody2D):
	_available_targets.append(new_target)
	
	if TARGET_TYPE == TargetType.LAST || _available_targets.size() == 1:
		_set_target(new_target)

func remove_target(body:PhysicsBody2D):
	# Remove the target from the list
	if _available_targets.has(body):
		_available_targets.erase(body)
		if _current_target == body:
			_find_next_target()
	
func _set_target(targetToFollow:PhysicsBody2D):
	_current_target = targetToFollow
	emit_signal("target_changed", _current_target)
	
func _travel_to_target(target:PhysicsBody2D, follow_distance_min:int, follow_distance_max:int) -> Vector2:
	var distToTarget = parent.global_position.distance_to(target.global_position)
	direction_to_target = parent.global_position.direction_to(target.global_position)

	if distToTarget > follow_distance_max:
		# Move closer to the target
		move_direction = direction_to_target
	elif distToTarget < follow_distance_min:
		# Move away from the target
		move_direction = -direction_to_target
	else:
		# Decelerate
		move_direction = Vector2.ZERO
		if _has_target_lock && _lock_until_in_range:
			# Done being locked into one target
			unlock_follow()

	velocity = velocity.move_toward(move_direction * speed, 10)
	parent.linear_velocity = velocity
		
	return velocity
	
# Finds the next target based on the targetting type
func _find_next_target():
	var newTarget
	match TARGET_TYPE:
		TargetType.FIRST:
			if !_available_targets.is_empty():
				newTarget =_available_targets.front()
		TargetType.LAST:
			if !_available_targets.is_empty():
				newTarget =_available_targets.back()
		TargetType.NEAR:
			newTarget = _get_closest_target()
		TargetType.FAR:
			newTarget = _get_farthest_target()

	_set_target(newTarget)
		
func _is_far_from_leader() -> bool:
	return parent.global_position.distance_to(_leader.global_position) > _leader_follow_max

func _get_farthest_target():
	var farthest_enemy = null
	var max_distance = -1
	
	var targets_to_track = _available_targets
	var distance_node = parent

	for enemy in targets_to_track:
		var distance = distance_node.global_position.distance_squared_to(enemy.global_position)
		if distance > max_distance:
			max_distance = distance
			farthest_enemy = enemy

	return farthest_enemy
	
func _get_closest_target():
	var closest_enemy = null
	var min_distance = INF
	
	var distance_node = parent

	for enemy in _available_targets:
		var distance = parent.global_position.distance_squared_to(enemy.global_position)
		if distance < min_distance:
			min_distance = distance
			closest_enemy = enemy

	return closest_enemy
	
func _change_speed(value:int):
	speed = value
