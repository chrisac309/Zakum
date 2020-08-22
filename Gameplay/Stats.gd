extends Node

const floating_text = preload("res://Gameplay/FloatingText.tscn")

export(int) var max_health = 1 setget set_max_health
export(int) var damage = 1
var health = max_health setget set_health

onready var root = get_parent()

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value:int):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value:int):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
		
func take_damage(value:int):
	var damage_text : Position2D = floating_text.instance()
	damage_text.amount = value
	damage_text.damage_type = 0
	root.add_child(damage_text)
	
	set_health(health - value)
	
func heal(value:int):
	var heal = floating_text.instance()
	heal.amount = value
	heal.damage_type = 1

func _ready():
	self.health = max_health
