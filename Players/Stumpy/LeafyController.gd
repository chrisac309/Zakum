extends Node

const LeafyScene = preload("res://Players/Leafy/Leafy.tscn")

export var SPAWNING_RANGE = 75
export var MAX_LEAFY = 10

onready var parent = get_parent()
onready var ySort = parent.get_parent()

var spawnedLeafy = []
var targets = []
var previousClosest
var previousFarthest

enum {
	FIRST,
	LAST,
	NEAR,
	FAR
}

export var TARGETING_TYPE = FIRST

func _process(delta):
	update_targets()

# Nearest and farthest need updated on a per-frame basis
func update_targets():
	var newTarget
	if TARGETING_TYPE == NEAR:
		newTarget = get_closest_target()
		if newTarget != null && newTarget != previousClosest:
			reassign_leafys_targeting_body(previousClosest)
			previousClosest = newTarget
	elif TARGETING_TYPE == FAR:
		newTarget = get_farthest_target()
		if newTarget != null && newTarget != previousFarthest:
			reassign_leafys_targeting_body(previousFarthest)
			previousFarthest = newTarget

func spawn_leafy():
	if spawnedLeafy.size() < MAX_LEAFY:
		var leafy = LeafyScene.instance()
		leafy.position = parent.position + Vector2(randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2, randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2)
		ySort.add_child(leafy)
		assign_leafy_target(leafy)
		spawnedLeafy.append(leafy)

func set_leafy_targets(targetNode:KinematicBody2D):
	for leafy in spawnedLeafy:
		set_single_leafy_target(leafy, targetNode)
			
func set_single_leafy_target(leafy, targetNode:KinematicBody2D):
	leafy.target_movement.set_target(targetNode)
	if targetNode.is_in_group("Enemy"):
		leafy.pursue_enemy()
	else:
		leafy.follow_stumpy()
		
# If any leafy were targeting this KinematicBody2D, reassign them to other targets
func reassign_leafys_targeting_body(body):
	for leafy in spawnedLeafy:
		if leafy.target_movement.get_target() == body:
			assign_leafy_target(leafy)

# Assigns the passed leafy to a new target depending on targeting type
func assign_leafy_target(leafy):
	var newTarget
	match TARGETING_TYPE:
		FIRST:
			newTarget = targets.front()
		LAST:
			newTarget = targets.back()
		NEAR:
			newTarget = get_closest_target()
		FAR:
			newTarget = get_farthest_target()

	if newTarget != null:
		set_single_leafy_target(leafy, newTarget)
	else:
		set_single_leafy_target(leafy, parent)

func get_farthest_target():
	var farthest_enemy = null
	var max_distance = -1

	for enemy in targets:
		var distance = parent.global_position.distance_squared_to(enemy.global_position)
		if distance > max_distance:
			max_distance = distance
			farthest_enemy = enemy

	return farthest_enemy
	
func get_closest_target():
	var closest_enemy = null
	var min_distance = INF

	for enemy in targets:
		var distance = parent.global_position.distance_squared_to(enemy.global_position)
		if distance < min_distance:
			min_distance = distance
			closest_enemy = enemy

	return closest_enemy

func _on_RangeDetector_body_entered(body):
	targets.append(body)
	reassign_leafys_targeting_body(parent)
	if TARGETING_TYPE == LAST:
		set_leafy_targets(body)

func _on_RangeDetector_body_exited(body):
	targets.erase(body)
	reassign_leafys_targeting_body(body)
