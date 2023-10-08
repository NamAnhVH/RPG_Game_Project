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

# Sua lai item (item_drop => item)
func drop_item(item: Item, body: KinematicBody2D):
	var item_drop = preload("res://Item/ItemDrop.tscn").instance()
	item_drop.set_item_drop(item.item_name, item.item_stat, item.item_quantity)
	map.entities.add_child(item_drop)
	item_drop.drop_item(body)



