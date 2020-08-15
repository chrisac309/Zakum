extends Area2D

var collisions = []
export var seeking_mask = 0

func _ready():
	set_collision_mask_bit(seeking_mask, true)

func detects_enemies():
	return collisions.size() > 0
	
func oldest_detection_body():
	return collisions.front()

func _on_RangeDetector_body_entered(body):
	collisions.append(body)

func _on_RangeDetector_body_exited(body):
	collisions.erase(body)
