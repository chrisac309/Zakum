extends CanvasLayer

signal scene_changed()

@onready var animation_player = $AnimationPlayer

func change_scene_to_file(path, delay = 0.5):
	assert(get_tree().change_scene_to_packed(path) == OK)
