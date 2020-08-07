extends Area2D

export var damage = 1

func rotate_hitbox_towards(target:KinematicBody2D):
	look_at(target.position)
