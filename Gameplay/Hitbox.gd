class_name Hitbox
extends Area2D

signal attack(enemy)

func rotate_hitbox_towards(target:PhysicsBody2D):
	look_at(target.position)

func _on_Hitbox_area_entered(hurtbox:Hurtbox):
	emit_signal("attack", hurtbox)
