extends MarginContainer

const game_scene = preload("res://World/Scenes/Overworld.tscn")

func _on_Singleplayer_button_up():
	PlayerData.player_count = 1
	PlayerData.players.append(PlayerData.HunterName.Stumpy)
	SceneChanger.change_scene(game_scene)

func _on_Exit_Game_button_up():
	get_tree().quit()


func _on_Multiplayer_button_up():
	PlayerData.player_count = 2
	PlayerData.players.append(PlayerData.HunterName.Stumpy)
	PlayerData.players.append(PlayerData.HunterName.Stumpy)
	SceneChanger.change_scene(game_scene)
