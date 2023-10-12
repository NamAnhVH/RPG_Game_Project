extends Node2D

onready var entities = $Entities
onready var characters = $Entities/Characters
onready var enemies = $Entities/Characters/Enemies.get_children()
onready var nav_2d = $Navigation2D
onready var player = $Entities/Characters/PlayableCharacter
onready var camera = $Camera2D

var top_position = Vector2()
var bottom_position = Vector2()

func _ready():
	Globals.map = self
	Globals.player = player

func _process(_delta):
	# fix for each enemy
	for i in enemies.size():
		if is_instance_valid(enemies[i]):
			var new_path
			if enemies[i].state.get_state() == States.IDLE:
				new_path = nav_2d.get_simple_path(enemies[i].global_position, enemies[i].get_random_position())
			else:
				if is_instance_valid(enemies[i].target):
					new_path = nav_2d.get_simple_path(enemies[i].global_position, enemies[i].target.global_position)
			enemies[i].set_path(new_path)
	

