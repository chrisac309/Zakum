extends StaticBody2D

@onready var stats = $Combat/Stats
@onready var sprite_handler = $SpriteHandler

# Called when the node enters the scene tree for the first time.
func _ready():
	stats.connect("no_health", Callable(self, "die"))
	stats.connect("low_health", Callable(sprite_handler, "on_health_low"))
	stats.connect("healed_beyond_low_health", Callable(sprite_handler, "on_health_high"))

func die():
	get_tree().reload_current_scene()
