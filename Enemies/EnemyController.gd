extends Node

const Troll = preload("res://Enemies/Troll.tscn")

export(NodePath) var ZakumInstance: NodePath
export(int) var SpawnRatePer10 = 1

onready var ySort = get_parent()
