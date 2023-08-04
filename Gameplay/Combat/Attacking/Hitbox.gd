class_name Hitbox
extends Area2D

signal attack(enemy)

@onready var collisionShape = $CollisionShape2D

func _ready():
	assert(collisionShape != null)
	assert(collision_layer == 0)
	assert(collision_mask > 0)

func rotate_hitbox_towards(target:PhysicsBody2D):
	look_at(target.position)

func _on_Hitbox_area_entered(hurtbox:Hurtbox):
	emit_signal("attack", hurtbox)
