extends Area2D

onready var hitbox = $Hitbox

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(collision_layer == 0)
	assert(hitbox.collision_mask == collision_mask && collision_mask > 0)
