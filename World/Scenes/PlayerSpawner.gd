extends Node2D

const stumpy = preload("res://Players/Stumpy/Stumpy.tscn")
const camera = preload("res://Gameplay/Cameras/Singleplayer/Camera2D.tscn")

var ySort : Node2D

func spawn_players():
	var players = PlayerData.player_count
	ySort = get_parent()
	for n in players:
		print('Instantiating player ' + str(n + 1))
		var currentPlayer = _instance_character(PlayerData.players[n])
		currentPlayer.name = 'Player ' + str(n)
		ySort.add_child(currentPlayer)
		var cam = camera.instantiate()
		cam.zoom = Vector2(2,2)
		currentPlayer.add_child(cam)
		
func _instance_character(hunter: int):
	var hunter_instance : Player
	match hunter:
		PlayerData.HunterName.Stumpy:
			print('Spawning Stumpy')
			hunter_instance = stumpy.instantiate()
		_:
			print('Spawning other')
			hunter_instance = stumpy.instantiate()
	hunter_instance.position = self.position + Vector2(randf() * 10 - 10 / 2, randf() * 10 - 10 / 2)
	hunter_instance.connect("die", player_died)
	return hunter_instance
	
func player_died(hunter : Player):
	print('Dedz')
