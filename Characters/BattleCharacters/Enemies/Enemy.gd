extends "res://Characters/BattleCharacters/AI.gd"

onready var state = $StateMachine

func _ready():
	state.add_state("IDLE")
	state.add_state("DETECTING")
	state.add_state("ATTACKING")
	state.set_state("IDLE")

func _on_ActiveArea_body_entered(intruder):
	if intruder is PlayableCharacter && state.get_state() == "IDLE":
		state.set_state("DETECTING")


func _on_ActiveArea_body_exited(intruder):
	if intruder is PlayableCharacter && state.get_state() == "DETECTING":
		state.set_state("IDLE")

func _on_AttackArea_body_entered(intruder):
	if intruder is PlayableCharacter && state.get_state() == "DETECTING":
		pass
