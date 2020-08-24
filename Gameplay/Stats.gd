extends Position2D

class_name Stats
const floating_text = preload("res://Gameplay/FloatingText.tscn")

export(int) var max_health = 1 setget set_max_health
export(int) var max_speed = 1 setget set_max_speed
export(int) var damage = 1
export(int, 100) var crit_rate = 15
var health = max_health setget set_health
var speed = max_speed setget set_speed

signal no_health
signal took_damage(value)
signal health_changed(value)
signal speed_changed(value)
signal max_health_changed(value)
signal max_speed_changed(value)

func _enter_tree():
	set_health(max_health)
	set_speed(max_speed)

func set_max_health(value:int):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)
	
func set_max_speed(value:int):
	max_speed = value
	self.speed = min(speed, max_speed)
	emit_signal("max_speed_changed", max_speed)

func set_health(value:int):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
		
func set_speed(value:int):
	speed = value
	emit_signal("speed_changed", speed)
		
func determine_crit():
	randomize()
	return (randi() % 100 + 1) < crit_rate
		
func determine_damage(is_crit:bool):
	if damage == 0:
		return damage
	randomize()
	var damage_to_send = randi() % (ceil(damage * 0.5) as int) + ceil(damage * 0.75)
	if is_crit:
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
