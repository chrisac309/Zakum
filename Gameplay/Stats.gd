class_name Stats
extends Node

const floating_text = preload("res://Gameplay/FloatingText.tscn")

export(int) var max_health = 1 setget set_max_health
export(int) var damage = 1
export(int, 100) var crit_rate = 15
var health = max_health setget set_health

signal no_health
signal took_damage(value)
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
		
func determine_crit():
	randomize()
	return (randi() % 100 + 1) < crit_rate
		
func determine_damage(is_crit:bool):
	randomize()
	var damage_to_send = randi() % (ceil(damage * 0.5) as int) + ceil(damage * 0.75)
	if is_crit:
		print("Critical!")
		damage_to_send *= 1.5
	return damage_to_send
		
func take_damage(value:int, receiving_crit:bool):
	var damage_text : Position2D = floating_text.instance()
	damage_text.amount = value
	damage_text.damage_type = 1 if receiving_crit else 0
	add_child(damage_text)
	emit_signal("took_damage", value)
	set_health(health - value)
	
func heal(value:int):
	var heal = floating_text.instance()
	heal.amount = value
	heal.damage_type = 1

func _ready():
	self.health = max_health
