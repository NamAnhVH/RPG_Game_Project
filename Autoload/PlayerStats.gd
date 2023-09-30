extends Node

signal no_health()
signal new_health(health)

export(int) var max_health = 1000

onready var health = max_health setget set_health

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("new_health", health)
	if health <= 0:
		emit_signal("no_health")

