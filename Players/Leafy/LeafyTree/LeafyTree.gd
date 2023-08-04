extends StaticBody2D

@onready var leafyController = $LeafyController
@onready var stats = $Combat/Stats
signal die(player)

func _ready():
	stats.connect("no_health", Callable(self, "die"))

func _on_Timer_timeout():
	leafyController.spawn_leafy()

func die():
	emit_signal("die", self)
	queue_free()
