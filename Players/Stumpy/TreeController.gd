extends Node

const LeafyTreeScene = preload("res://Players/Stumpy/LeafyTree.tscn")

export var SPAWNING_RANGE = 75
export var MAX_TREE = 3

onready var parent = get_parent()
onready var ySort = parent.get_parent()

var spawnedTrees = []

func spawn_tree():
	if spawnedTrees.size() < MAX_TREE:
		var leafyTree = LeafyTreeScene.instance()
		leafyTree.position = parent.position + Vector2(randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2, randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2)
		ySort.add_child(leafyTree)
		spawnedTrees.append(leafyTree)
