extends Position2D

const expected_scale = Vector2(0.75, 0.75)

onready var label = $Label
onready var tween = $Tween

var amount : int
var damage_type : int
var velocity : Vector2

enum DamageType {
	Damage,
	Crit,
	Heal
}

# Called when the node enters the scene tree for the first time.
func _ready():
	global_scale = expected_scale
	label.set_text(str(amount))
	match damage_type:
		DamageType.Damage:
			label.set("custom_colors/font_color", Color.red)
		DamageType.Crit:
			label.set("custom_colors/font_color", Color.blue)
		DamageType.Heal:
			label.set("custom_colors/font_color", Color.green)
			
	randomize()
	var side_movement = randi() % 61 - 30
	velocity = Vector2(side_movement, 50)
			
	tween.interpolate_property(self, "global_scale", global_scale, Vector2(1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, "global_scale", Vector2(1, 1), Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
	tween.start()

func _physics_process(delta):
	position -= velocity * delta

func _on_Tween_tween_all_completed():
	self.queue_free()
