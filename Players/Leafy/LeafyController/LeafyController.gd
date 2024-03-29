extends Node

const LeafyScene = preload("res://Players/Leafy/Leafy.tscn")

signal target_added(target)
signal target_removed(target)

export var SPAWNING_RANGE = 75
export var MAX_LEAFY = 3
export var LEAFY_FOLLOW_MIN = 30
export var LEAFY_FOLLOW_MAX = 50

onready var parent : PhysicsBody2D = get_parent()
onready var ySort = parent.get_parent()

var spawnedLeafy = []
var available_targets = []
var max_range = 100 #This needs changed if Stumpy's range changes

func _ready():
	parent.connect("die", self, "parent_died")

func spawn_leafy():
	if spawnedLeafy.size() < MAX_LEAFY:
		var leafy : NPC = LeafyScene.instance()
		leafy.position = parent.position + Vector2(randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2, randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2)
		leafy.connect("die", self, "leafy_died")
		ySort.add_child(leafy)
		leafy.target_movement.set_leader(parent, LEAFY_FOLLOW_MIN, LEAFY_FOLLOW_MAX, max_range)
		leafy.target_movement._available_targets  = available_targets.duplicate()
		connect("target_added", leafy.target_movement, "add_target")
		connect("target_removed", leafy.target_movement, "remove_target")
		spawnedLeafy.append(leafy)

func leafy_died(leafy):
	spawnedLeafy.erase(leafy)
	
func parent_died(_parent):
	for leafy in spawnedLeafy:
		leafy.die()
		
func add_available_target(body: PhysicsBody2D):
	print("Adding ", body.name, " to leafy targets.")
	if !available_targets.has(body):
		available_targets.append(body)
		if !body.is_connected("die", self, "remove_available_target"):
			body.connect("die", self, "remove_available_target")
		emit_signal("target_added", body)

func remove_available_target(body: PhysicsBody2D):
	if available_targets.has(body):
		available_targets.erase(body)
		emit_signal("target_removed", body)
