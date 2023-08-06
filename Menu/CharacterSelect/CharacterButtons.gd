extends Button


@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D


func _focus_entered():
	animated_sprite.play()


func _focus_exited():
	animated_sprite.stop()
