extends Node

const LeafyScene = preload("res://Players/Leafy/Leafy.tscn")

export var SPAWNING_RANGE = 75
export var MAX_LEAFY = 10

onready var parent = get_parent()
onready var ySort = parent.get_parent()

var spawnedLeafy = []
var targets = []

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

func assign_leafy_target(leafy):
	var earliestTarget = targets.front()
	if earliestTarget != null:
		set_single_leafy_target(leafy, earliestTarget)
	else:
		set_single_leafy_target(leafy, parent)

func _on_EnemyDetector_body_entered(body):
	targets.append(body)
	reassign_leafys_targeting_body(parent)

func _on_EnemyDetector_body_exited(body):
	targets.erase(body)
	reassign_leafys_targeting_body(body)
	
