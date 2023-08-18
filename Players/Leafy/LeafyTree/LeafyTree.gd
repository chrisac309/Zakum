extends StaticBody2D

@onready var leafyController = $LeafyController
@onready var stats = $Combat/Stats
signal die(player)

func _ready():
	stats.connect("no_health", dead)

func _on_Timer_timeout():
	leafyController.spawn_leafy()

func dead():
	emit_signal("die", self)
	queue_free()
