extends StaticBody2D

onready var leafyController = $LeafyController
onready var stats = $Stats
onready var hurtbox = $Hurtbox

signal die(player)

func _ready():
	hurtbox.connect("hit", stats, "take_damage")

func _on_Timer_timeout():
	leafyController.spawn_leafy()

func die():
	emit_signal("die", self)
