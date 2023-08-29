extends Node2D

onready var characters = $Entities

func _ready():
	Globals.battle_arena = self
