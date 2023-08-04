extends Node

const LeafyTreeScene = preload("res://Players/Leafy/LeafyTree/LeafyTree.tscn")

@export var SPAWNING_RANGE = 30
@export var MAX_TREE = 3

@onready var parent = get_parent()
@onready var ySort = parent.get_parent()

var spawnedTrees = []

func _ready():
	parent.connect("die", Callable(self, "parent_died"))

func spawn_tree():
	if spawnedTrees.size() < MAX_TREE:
		var leafyTree = LeafyTreeScene.instantiate()
		leafyTree.position = parent.position + Vector2(0,SPAWNING_RANGE)
		leafyTree.connect("die", Callable(self, "tree_died"))
		ySort.add_child(leafyTree)
		spawnedTrees.append(leafyTree)
		
func tree_died(tree):
	spawnedTrees.erase(tree)
	
func parent_died(_parent):
	for tree in spawnedTrees:
		tree.die()
