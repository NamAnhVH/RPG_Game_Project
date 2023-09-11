extends KinematicBody2D
class_name Character

onready var animation_player = $Animation/AnimationPlayer
onready var animation_tree = $Animation/AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.active = true

export var move_speed_unit := 8.0

var velocity := Vector2()
