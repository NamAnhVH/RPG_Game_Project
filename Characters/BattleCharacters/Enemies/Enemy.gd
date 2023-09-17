extends "res://Characters/BattleCharacters/AI.gd"
class_name Enemy

signal enter_idle_state()

func _ready():
	state.add_state("IDLE")
	state.add_state("DETECTING")
	state.add_state("ATTACKING")
	state.add_state("PRE_ATTACK")
	state.set_state("IDLE")

func _on_ActiveArea_body_entered(intruder):
	if intruder is PlayableCharacter && state.get_state() == "IDLE":
		state.set_state("DETECTING")

func _on_ActiveArea_body_exited(intruder):
	if intruder is PlayableCharacter && state.get_state() == "DETECTING":
		state.set_state("IDLE")
		emit_signal("enter_idle_state")

func _on_AttackArea_body_entered(intruder):
	if intruder is PlayableCharacter && state.get_state() == "DETECTING":
		state.set_state("ATTACKING")

func _on_AttackArea_body_exited(intruder):
	if intruder is PlayableCharacter && state.get_state() == "ATTACKING":
		state.set_state("DETECTING")
