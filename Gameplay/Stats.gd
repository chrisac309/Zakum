extends Node

class_name Stats
const floating_text = preload("res://Gameplay/FloatingText.tscn")

@onready var parent : Marker2D = get_parent()
@onready var health_bar = $HealthBar

@export var max_health: int = 1
@export var max_speed: int = 1
@export var max_inertia: int = 1
@export var damage: int = 1
@export var crit_rate = 15 # (int, 100)

var health = max_health
var speed
var inertia

signal no_health
signal low_health
signal healed_beyond_low_health
signal took_damage(value)
signal health_changed(value)
signal speed_changed(value)
signal max_health_changed(value)
signal max_speed_changed(value)

func _ready():
	set_max_health(max_health)
	set_health(max_health)
	set_velocity(max_speed)
	set_inertia(max_inertia)

func set_max_health(value:int):
	max_health = value
	print("Parent: ", get_parent().name, "Grandparent: ", get_parent().get_parent().name)
	set_health(min(health, max_health))
	emit_signal("max_health_changed", max_health)
	health_bar.max_value = max_health
	
func set_max_speed(value:int):
	max_speed = value
	self.speed = min(speed, max_speed)
	emit_signal("max_speed_changed", max_speed)
	
func set_max_inertia(value:int):
	max_inertia = value
	self.inertia = min(inertia, max_inertia)

func set_health(value:int):
	health = value
	health_bar.value = max(0, health)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
	elif health <= max_health / 2:
		emit_signal("low_health")
		
func set_velocity(value:int):
	speed = value
	emit_signal("speed_changed", speed)
	
func set_inertia(value:int):
	inertia = value
		
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
	var damage_text : Marker2D = floating_text.instantiate()
	damage_text.amount = value
	damage_text.damage_type = 1 if receiving_crit else 0
	parent.add_child(damage_text)
	emit_signal("took_damage", value)
	set_health(health - value)
	
func heal(value:int):
	var heal = floating_text.instantiate()
	heal.amount = value
	heal.damage_type = 1
	set_health(health + heal)
	if health + heal >= max_health / 2:
		emit_signal("healed_beyond_low_health")
