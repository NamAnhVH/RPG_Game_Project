extends Area2D

signal damaged(amount, knockback_strength, damage_source, attacker)
signal immunity_started()
signal immunity_ended()
signal feature_damaged()

const HIT_EFFECT = preload("res://Effects/HitEffect.tscn")

onready var immunity_timmer = $ImmunityTimer
onready var parent = get_parent()

export var immunity_duration := 0.0

var exceptions = []

func add_exception(node: Node2D): # Them node vao danh sach exception va tu xoa khoi danh sach neu doi tuong bi pha huy
	if node != null:
		exceptions.append(node)
		node.connect("tree_exiting", self, "remove_exception", [node])

func remove_exception(node: Node2D):
	if node in exceptions:
		exceptions.erase(node)

func _on_Hitbox_area_entered(area):
	if area in exceptions || !immunity_timmer.is_stopped():
		return
	
	if area is DamageArea:
		if !(self in area.exceptions):
			if parent is BattleCharacter:
				damage(area.damage_amount, area.knockback_strength, area, area.attacker)
				area.on_hit(self)
				var effect = HIT_EFFECT.instance()
				var main = get_tree().current_scene
				main.add_child(effect)
				effect.global_position = global_position
			else:
				emit_signal("feature_damaged")
			

func damage(amount, knockback_strength, damage_source, attacker):
	emit_signal("damaged", amount, knockback_strength, damage_source, attacker)
	if immunity_duration > 0:
		immunity_timmer.start(immunity_duration) #Bat dau thoi gian bat tu

func _on_ImmunityTimer_timeout():
	emit_signal("immunity_ended")
