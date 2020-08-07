extends "./Enemy.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	target_movement.follow(delta)

func _on_RangeDetector_body_entered(body):
	target_movement.set_target(body)
