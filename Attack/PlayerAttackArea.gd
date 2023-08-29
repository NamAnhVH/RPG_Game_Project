extends Node2D

onready var damage_area = $DamageArea

func set_attacker(attacker):
	damage_area.attacker = attacker

func _on_ExistTimer_timeout():
	queue_free()
