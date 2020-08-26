extends StaticBody2D

onready var stats = $Combat/Stats

# Called when the node enters the scene tree for the first time.
func _ready():
	stats.connect("no_health", self, "die")

func die():
	get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
