extends KinematicBody2D

onready var leafyController = $LeafyController

func _on_Timer_timeout():
	leafyController.spawn_leafy()
