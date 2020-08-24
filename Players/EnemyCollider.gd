extends Area2D

signal enemy_colliding
signal enemy_left

func _on_EnemyCollider_body_entered(body):
	emit_signal("enemy_colliding")

func _on_EnemyCollider_body_exited(body):
	emit_signal("enemy_left")
