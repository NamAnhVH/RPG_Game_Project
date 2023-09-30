extends Character
class_name BattleCharacter

enum Factions {ALLY, ENEMY}

signal lose_health(amount)

const KNOCKBACK_VELOCITY = 200

onready var attack_cooldown = $Timers/AttackCooldown
onready var hitbox = $Hitbox
onready var state = $StateMachine

export (Factions) var faction = 0
export(bool) var knockback_modifier = true
export var move_weight = 0.2 setget set_move_weight, get_move_weight

var target_ref setget set_target, get_target

func _ready():
	yield() #Them khoang thoi gian de khoi tao Globals
	Globals.battle_arena.add_character(self)

func knockback(knockback_strength, source_position: Vector2):
	var normal = (global_position - source_position).normalized()
	if knockback_modifier:
		velocity = knockback_strength * normal * KNOCKBACK_VELOCITY

func _on_Hitbox_damaged(amount, knockback_strength, damage_source: Area2D, attacker):
	emit_signal("lose_health", amount)
	if damage_source != null:
		knockback(knockback_strength, damage_source.global_position)
	damage_animation.play("Damage")

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

func set_move_weight(value):
	move_weight = value

func get_move_weight():
	return move_weight
