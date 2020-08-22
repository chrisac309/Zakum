extends Area2D

var stats

func rotate_hitbox_towards(target:KinematicBody2D):
	look_at(target.position)

func _on_Hitbox_area_entered(hurtbox:Area2D):
	print(hurtbox.get_parent().name)
	assert(hurtbox.has_user_signal("die"))
	hurtbox.emit_signal("hit", stats.damage)
		
