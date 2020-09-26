extends Node2D

const stumpy = preload("res://Players/Stumpy/Stumpy.tscn")
const singleplayer_camera = preload("res://Gameplay/Cameras/Singleplayer/Camera2D.tscn")
const splitscreen_camera = preload("res://Gameplay/Cameras/Splitscreen/Cameras.tscn")

var ySort : YSort

func spawn_players():
	var players = PlayerData.player_count
	ySort = get_parent()
	if players == 1:
		# Do not use splitscreen, spawn a character with a child camera
		var player1 = _instance_character(PlayerData.players[0])
		player1.name = 'Player1'
		ySort.add_child(player1)
		var cam = singleplayer_camera.instance()
		player1.add_child(cam)
	elif players == 2:
		var player1 = _instance_character(PlayerData.players[0])
		player1.name = 'Player1'
		ySort.add_child(player1, true)
		var player2 = _instance_character(PlayerData.players[1])
		player2.name = 'Player2'
		ySort.add_child(player2, true)
		var cam = splitscreen_camera.instance()
		ySort.add_child(cam)
	else:
		print("This isn't possible")
		
func _instance_character(hunter: int):
	var hunter_instance : Player
	match hunter:
		PlayerData.HunterName.Stumpy:
			print('Spawning Stumpy')
			hunter_instance = stumpy.instance()
		_:
			print('Spawning other')
			hunter_instance = stumpy.instance()
	hunter_instance.position = self.position + Vector2(randf() * 10 - 10 / 2, randf() * 10 - 10 / 2)
	hunter_instance.connect("die", self, "player_died")
	return hunter_instance
	
func player_died(hunter : Player):
	print('Dedz')
