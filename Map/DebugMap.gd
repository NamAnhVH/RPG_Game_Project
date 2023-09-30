extends Node

onready var characters = $Entities
onready var slime = $Entities/Slime
onready var nav_2d = $Navigation2D

func _ready():
	Globals.battle_arena = self

func _process(delta):
	if is_instance_valid(slime):
		var new_path
		if slime.state.get_state() == States.IDLE:
			new_path = nav_2d.get_simple_path(slime.global_position, slime.get_random_position())
		else:
			if is_instance_valid(slime.target):
				new_path = nav_2d.get_simple_path(slime.global_position, slime.target.global_position)
		slime.set_path(new_path)

