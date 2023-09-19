extends Character
class_name BattleCharacter

enum Factions {ALLY, ENEMY}

signal died()

const KNOCKBACK_VELOCITY = 200

onready var attack_cooldown = $Timers/AttackCooldown
onready var hitbox = $Hitbox
onready var state = $StateMachine

export var max_health = 8.0
export (Factions) var faction = 0
export var knockback_modifier = 1.0
export var move_weight = 0.2

var target_ref setget set_target, get_target

onready var health = max_health setget set_health

func set_health(value):
	health = clamp(value, 0, max_health)
	if health <= 0:
		die()

func die():
	emit_signal("died")

func _ready():
	yield() #Them khoang thoi gian de khoi tao Globals
	Globals.battle_arena.add_character(self)

func _on_Hitbox_damaged(amount, knockback_strength, damage_source, attacker):
	set_health(health - amount)
	if damage_source != null:
		knockback(knockback_strength, damage_source.global_position)
	damage_animation.play("Damage")
	if hitbox.immunity_duration != 0:
		damage_animation.queue("Invulnerability")

func _on_Hitbox_immunity_ended():
	damage_animation.play("RESET")

func set_target(value):
	if value is WeakRef:
		target_ref = value
	else:
		target_ref = weakref(value)

func get_target():
	var target = null
	if target_ref != null:
		target = target_ref.get_ref()

func knockback(knockback_strength, source_position):
	var normal = (global_position - source_position).normalized()
	if knockback_modifier != 0:
		velocity = knockback_strength * normal * KNOCKBACK_VELOCITY

func get_move_weight():
	return move_weight

