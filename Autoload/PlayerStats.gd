extends Node

signal no_health()
signal new_health(health)

const MAX = 999999

var max_health = 20 setget set_max_health, get_max_health
var max_energy = 20 setget set_max_energy, get_max_energy
var atk = 2 setget set_atk, get_atk
var def = 2 setget set_def, get_def
var crit_rate = 2 setget set_crit_rate, get_crit_rate
var crit_damage = 2 setget set_crit_damage, get_crit_damage
var attack_speed = 0.5 setget set_attack_speed, get_attack_speed
var knockback = 3 setget set_knockback, get_knockback

onready var health = max_health setget set_health, get_health

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("new_health", health)
	if health <= 0:
		emit_signal("no_health")

func get_health():
	return health

func set_max_health(value):
	max_health = clamp(value, 0, MAX)

func get_max_health():
	return max_health

func set_max_energy(value):
	max_energy = clamp(value, 0, MAX)

func get_max_energy():
	return max_energy

func set_atk(value):
	atk = clamp(value, 0, MAX)

func get_atk():
	return atk

func set_def(value):
	def = clamp(value, 0, MAX)

func get_def():
	return def

func set_crit_rate(value):
	crit_rate = clamp(value, 0, MAX)

func get_crit_rate():
	return crit_rate

func set_crit_damage(value):
	crit_damage = clamp(value, 0, MAX)

func get_crit_damage():
	return crit_damage

func set_attack_speed(value):
	attack_speed = clamp(value, 0.2, 5)

func get_attack_speed():
	return attack_speed

func set_knockback(value):
	knockback = clamp(value, 0.5, 10)

func get_knockback():
	return knockback
