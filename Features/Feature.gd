extends StaticBody2D
class_name Feature

onready var hitbox = $Hitbox

export var max_health := 1.0

onready var health = max_health setget set_health

func set_health(value):
	health = clamp(value, 0, max_health)
	if health <= 0:
		destroyed()

func destroyed():
	var grass_destroy_effect = load("res://Effects/GrassEffect.tscn").instance()
	var world = get_tree().current_scene
	world.add_child(grass_destroy_effect)
	grass_destroy_effect.global_position = global_position
	queue_free()

func _on_Hitbox_feature_damaged():
	set_health(health - 1)
	
