extends Node

const LeafyScene = preload("res://Players/Leafy.tscn")

export var SPAWNING_RANGE = 75
export var MAX_LEAFY = 10

onready var parent = get_parent()

var spawnedLeafy = []

func spawn_leafy():
	if spawnedLeafy.size() < MAX_LEAFY:
		var leafy = LeafyScene.instance()
		leafy.position = parent.position + Vector2(randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2, randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2)
		get_parent().get_parent().add_child(leafy)
		leafy.target_movement.set_target(parent)
		spawnedLeafy.append(leafy)

func set_leafy_targets(targetNode:KinematicBody2D):
	for leafy in spawnedLeafy:
		leafy.target_movement.set_target(targetNode)
