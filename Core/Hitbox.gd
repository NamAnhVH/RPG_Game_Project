extends Area2D

signal damaged(amount, knockback_strength, damage_source, attacker)
signal immunity_started()
signal immunity_ended()

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
			damage(area.damage_amount, area.knockback_strength, area, area.attacker)
			area.on_hit(self)

func damage(amount, knockback_strength, damage_source, attacker):
	emit_signal("damaged", amount, knockback_strength, damage_source, attacker)
	if immunity_duration > 0:
		immunity_timmer.start(immunity_duration) #Bat dau thoi gian bat tu

func _on_ImmunityTimer_timeout():
	emit_signal("immunity_ended")
