extends Area2D

var collisions = []

func _on_EnemyDetector_body_entered(body:KinematicBody2D):
	collisions.append(body)

func _on_EnemyDetector_body_exited(body:KinematicBody2D):
	collisions.erase(body)
	
func detects_enemies():
	return collisions.size() > 0
	
func oldest_detection_body():
	return collisions.front()
