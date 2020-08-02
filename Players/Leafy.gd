extends KinematicBody2D

var target = null
var velocity = Vector2.ZERO

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var MAX_SPEED = 50
var ACCELERATION = 300

## Called when the node enters the scene tree for the first time.
#func _ready():
#	target = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction = global_position.direction_to(target.global_position)
	velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func set_target(targetToFollow):
	target = targetToFollow
	
func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
