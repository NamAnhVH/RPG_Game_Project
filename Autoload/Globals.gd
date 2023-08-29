extends Node

const UNIT_SIZE = 24

var player = null
var level = null
var time = 0
var battle_arena = null

func _ready():
	pass

func _process(delta):
	time += delta
