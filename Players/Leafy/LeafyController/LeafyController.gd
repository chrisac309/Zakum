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

func _ready():
	parent.connect("die", self, "parent_died")

func _process(_delta):
	update_targets()

# Nearest and farthest need updated on a per-frame basis
func update_targets():
	var newTarget
	if TARGETING_TYPE == NEAR:
		newTarget = get_closest_target()
		if newTarget != previousClosest:
			reassign_leafys_targeting_body(previousClosest)
			previousClosest = newTarget
	elif TARGETING_TYPE == FAR:
		newTarget = get_farthest_target()
		if newTarget != previousFarthest:
			reassign_leafys_targeting_body(previousFarthest)
			previousFarthest = newTarget

func spawn_leafy():
	if spawnedLeafy.size() < MAX_LEAFY:
		var leafy : Leafy = LeafyScene.instance()
		leafy.position = parent.position + Vector2(randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2, randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2)
		leafy.connect("die", self, "leafy_died")
		ySort.add_child(leafy)
		assign_leafy_target(leafy)
		spawnedLeafy.append(leafy)

func set_leafy_targets(targetNode:PhysicsBody2D):
	for leafy in spawnedLeafy:
		set_single_leafy_target(leafy, targetNode)
			
func set_single_leafy_target(leafy, targetNode:PhysicsBody2D):
	leafy.target_movement.set_target(targetNode)
		
# If any leafy were targeting this KinematicBody2D, reassign them to other targets
func reassign_leafys_targeting_body(body):
	for leafy in spawnedLeafy:
		if leafy.current_target == body:
			assign_leafy_target(leafy)

# Assigns the passed leafy to a new target depending on targeting type
func assign_leafy_target(leafy):
	var newTarget
	match TARGETING_TYPE:
		FIRST:
			if !targets.empty():
				newTarget = targets.front()
		LAST:
			if !targets.empty():
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

func remove_leafy_target(body):
	if targets.has(body):
		targets.erase(body)
		reassign_leafys_targeting_body(body)

func add_leafy_target(new_target):
	targets.append(new_target)
	if !new_target.is_connected("die", self, "remove_leafy_target"):
		new_target.connect("die", self, "remove_leafy_target")
	reassign_leafys_targeting_body(parent)
	if TARGETING_TYPE == LAST:
		set_leafy_targets(new_target)

func leafy_died(leafy):
	spawnedLeafy.erase(leafy)
	
func parent_died(_parent):
	for leafy in spawnedLeafy:
		leafy.die()
