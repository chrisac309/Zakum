extends MarginContainer

const game_scene = preload("res://World/Scenes/Overworld.tscn")

func _on_Singleplayer_button_up():
	SceneChanger.change_scene(game_scene)

func _on_Exit_Game_button_up():
	get_tree().quit()
