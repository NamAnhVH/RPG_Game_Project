extends Node

signal no_health()

export var max_health = 8.0

onready var health = max_health setget set_health

func set_health(value):
	health = clamp(value, 0, max_health)
	if health <= 0:
		emit_signal("no_health")
