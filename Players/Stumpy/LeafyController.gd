extends Node

const LeafyScene = preload("res://Players/Leafy/Leafy.tscn")

export var SPAWNING_RANGE = 75
export var MAX_LEAFY = 10

onready var parent = get_parent()
onready var ySort = parent.get_parent()

var spawnedLeafy = []

func spawn_leafy():
	if spawnedLeafy.size() < MAX_LEAFY:
		var leafy = LeafyScene.instance()
		leafy.position = parent.position + Vector2(randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2, randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2)
		ySort.add_child(leafy)
		leafy.target_movement.set_target(parent)
		spawnedLeafy.append(leafy)

func set_leafy_targets(targetNode:KinematicBody2D):
	for leafy in spawnedLeafy:
		leafy.target_movement.set_target(targetNode)

func _on_EnemyDetector_body_entered(body):
	set_leafy_targets(body)

func _on_EnemyDetector_body_exited(body):
	set_leafy_targets(parent)
