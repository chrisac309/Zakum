extends MarginContainer

const character_select_scene = preload("res://Menu/CharacterSelect/CharacterSelect.tscn")

func _on_Singleplayer_button_up():
	PlayerData.player_count = 1
	SceneChanger.change_scene(character_select_scene)

func _on_Multiplayer_button_up():
	PlayerData.player_count = 2
	SceneChanger.change_scene(character_select_scene)

func _on_Exit_Game_button_up():
	get_tree().quit()
