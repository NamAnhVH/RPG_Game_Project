extends KinematicBody2D
class_name Character

onready var animation_character = $Animation/AnimationCharacter
onready var animation_tree = $Animation/AnimationTree
onready var damage_animation = $Animation/DamageAnimation
onready var animation_state = animation_tree.get("parameters/playback")
onready var body = $Body

export var move_speed_unit := 5.0

var velocity := Vector2()

func _ready():
	animation_tree.active = true
