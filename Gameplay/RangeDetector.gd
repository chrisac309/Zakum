extends Area2D

func detects_enemies():
	return !get_overlapping_bodies().empty()
