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
func drop_item(body_name, body: KinematicBody2D):
	var item = preload("res://Item/Item.gd").new()
	var list_item_drop = JsonData.item_rate_drop_data[body_name]
	var random = int(rand_range(0, 101))
	for item_name in list_item_drop:
		var item_drop = list_item_drop[item_name]
		if random >= item_drop["MinRate"] and random <= item_drop["MaxRate"]:
			var item_stat: Dictionary
			var item_quantity = 1
			match JsonData.item_data[item_name]["ItemCategory"]:
				Items.WEAPON:
					var list_random_stat = JsonData.item_data[item_name]["RandomStat"]
					for stat_name in list_random_stat:
						var random_stat = int(rand_range(0, 101))
						var stat = list_random_stat[stat_name]
						if random_stat <= stat["Rate"]:
							var value = int(rand_range(stat["Stat"]["Min"], stat["Stat"]["Max"]))
							print(stat_name + " " + str(value))
							item_stat[stat_name] = value
				Items.CONSUMABLE:
					item_quantity = item_drop["Quantity"]
			item.set_item(item_name, item_stat, item_quantity)
			break
	var item_drop = preload("res://Item/ItemDrop.tscn").instance()
	item_drop.set_item_drop(item.item_name, item.item_stat, item.item_quantity)
	map.entities.add_child(item_drop)
	item_drop.drop_item(body)



