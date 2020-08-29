extends Node

export(int) var spawn_rate_per_10 = 1
export(NodePath) var main_target_path: NodePath
export(PackedScene) var enemy_to_spawn

onready var ySort = get_parent()
onready var timer = $Timer
onready var main_target = get_node(main_target_path)

export var SPAWNING_RANGE = 75
var current_wait_time: int

func _ready():
	if spawn_rate_per_10 > 0:
		current_wait_time = 10 / spawn_rate_per_10
		start_spawning()
	
func start_spawning():
	timer.start(current_wait_time)
	
func stop_spawning():
	timer.stop()
	
func spawn_enemy():
	var troll : Enemy = enemy_to_spawn.instance()
	randomize()
	troll.position = self.position + Vector2(randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2, randf() * SPAWNING_RANGE - SPAWNING_RANGE / 2)
	ySort.add_child(troll)
	troll.target_movement.add_target(main_target)
	
func _on_Timer_timeout():
	spawn_enemy()
	

