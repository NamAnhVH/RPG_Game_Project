extends Node2D

onready var entities = $Entities
onready var characters = $Entities/Characters
onready var enemies = $Entities/Characters/Enemies
onready var nav_2d = $Navigation2D
onready var player = $Entities/Characters/PlayableCharacter

func _ready():
	Globals.map = self
	Globals.player = player

func _process(delta):
	# fix for every enemy
	var slimes = enemies.get_children()
	for i in slimes.size():
		if is_instance_valid(slimes[i]):
			var new_path
			if slimes[i].state.get_state() == States.IDLE:
				new_path = nav_2d.get_simple_path(slimes[i].global_position, slimes[i].get_random_position())
			else:
				if is_instance_valid(slimes[i].target):
					new_path = nav_2d.get_simple_path(slimes[i].global_position, slimes[i].target.global_position)
			slimes[i].set_path(new_path)

