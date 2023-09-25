extends Node2D

onready var damage_area = $DamageArea
onready var animation = $AnimationPlayer

func _ready():
	animation.play("Attack")

func set_attacker(attacker):
	damage_area.attacker = attacker

func attack_animation_finished():
	queue_free()
