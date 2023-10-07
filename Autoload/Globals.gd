extends Node

const UNIT_SIZE = 24

var player = null
var level = null
var time = 0
var map = null

func _ready():
	pass

func _process(delta):
	time += delta

func drop_item_from_enemy(body: KinematicBody2D):
	var item = preload("res://Item/ItemDrop.tscn").instance()
	match randi() % 3:
		0:
			item.set_item_drop("Stone Sword", [])
		1:
			item.set_item_drop("Iron Sword", [])
		2:
			item.set_item_drop("Apple", [], 5)
	map.entities.add_child(item)
	item.drop_item(body)

func drop_item_from_player(item_drop):
	var item = preload("res://Item/ItemDrop.tscn").instance()
	item.set_item_drop(item_drop.item_name, [], item_drop.item_quantity)
	map.entities.add_child(item)
	item.drop_item(player)


