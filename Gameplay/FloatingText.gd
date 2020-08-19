extends Position2D

onready var label = $Label
onready var tween = $Tween

var amount : int
var damage_type : int


enum DamageType {
	Damage,
	Heal
}

# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_text(str(amount))
	match damage_type:
		DamageType.Damage:
			label.set("custom_colors/font_color", Color.red)
		DamageType.Heal:
			label.set("custom_colors/font_color", Color.green)
			
	tween.interpolate_property(self, "scale", scale, Vector2(1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
	tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Tween_tween_all_completed():
	self.queue_free()
