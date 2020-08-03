extends Area2D

var collisions = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_EnemyDetector_area_entered(area):
	collisions.append(area)


func _on_EnemyDetector_area_exited(area):
	collisions.remove(area)
	
func detects_enemies():
	return collisions.size() > 0
	
func oldest_detection_area():
	return collisions.front()
