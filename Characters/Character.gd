extends KinematicBody2D
class_name Character

onready var idle_animation = $Animation/IdleAnimation
onready var idle_animation_tree = $Animation/IdleAnimationTree
onready var idle_animation_state = idle_animation_tree.get("parameters/playback")

export var move_speed_unit := 5.0

var velocity := Vector2()

func _ready():
	idle_animation_tree.active = true
