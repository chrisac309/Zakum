extends StaticBody2D

onready var leafyController = $LeafyController

signal die(player)

func _on_Timer_timeout():
	leafyController.spawn_leafy()

func die():
	emit_signal("die", self)
