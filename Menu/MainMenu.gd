extends MarginContainer

const character_select_scene = preload("res://Menu/CharacterSelect/CharacterSelect.tscn")

func _on_MainMenu_gui_input(event):
	if event is InputEventScreenTouch:
		SceneChanger.change_scene_to_file(character_select_scene)
		print("Going to the next scene")
