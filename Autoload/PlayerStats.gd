extends Node

signal no_health()

export(int) var max_health = 10

onready var health = max_health setget set_health

func set_health(value):
	health = clamp(value, 0, max_health)
	if health <= 0:
		emit_signal("no_health")

