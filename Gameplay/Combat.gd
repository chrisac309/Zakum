extends Node

onready var stats : Stats = $Stats
onready var hitbox : Hitbox
onready var hurtbox : Hurtbox = $Hurtbox

func _ready():
	assert(hurtbox.get_child(0).shape != null)
	var found_hitbox = get_node_or_null("Hitbox")
	if found_hitbox == null:
		found_hitbox = get_node("AttackRange/Hitbox")
	hitbox = found_hitbox
	assert(hitbox.get_child(0).shape != null)

func hit_enemy(enemy:Hurtbox):
	var is_crit = stats.determine_crit()
	var damage_to_deal = stats.determine_damage(is_crit)
	enemy.emit_signal("hit", damage_to_deal, is_crit)
