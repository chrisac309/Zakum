extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var stats = $Combat/Stats


# Called when the node enters the scene tree for the first time.
func _ready():
	stats.connect("no_health", self, "queue_free")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
