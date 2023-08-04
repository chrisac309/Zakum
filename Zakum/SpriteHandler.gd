extends Marker2D

@onready var full_health_sprite : Sprite2D = $FullHealthSprite
@onready var low_health_sprite : Sprite2D = $LowHealthSprite

func _ready():
	_to_full_health_sprite()

func on_health_high() -> void:
	_to_full_health_sprite()

func on_health_low() -> void:
	_to_low_health_sprite()
	
func _to_full_health_sprite() -> void:
	full_health_sprite.visible = true
	low_health_sprite.visible = false

func _to_low_health_sprite() -> void:
	low_health_sprite.visible = true
	full_health_sprite.visible = false
