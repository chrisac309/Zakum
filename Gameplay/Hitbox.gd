extends Area2D

var stats

func rotate_hitbox_towards(target:PhysicsBody2D):
	look_at(target.position)

func _on_Hitbox_area_entered(hurtbox):
	hurtbox.emit_signal("hit", stats.damage)
