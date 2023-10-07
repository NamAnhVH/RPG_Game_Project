extends Node2D

const ITEM = preload("res://Item/Item.gd")

onready var name_label = $InformationItem/Name
onready var stat_label = $InformationItem/Stat
onready var description_label = $InformationItem/Description

func set_information_item(item: ITEM):
	name_label.text = item.item_name
	
	description_label.text = item.item_description
	
	var stat_string: String
	match item.item_category:
		"Consumable":
			if item.item_add_health:
				stat_string += "+ " + String(item.item_add_health) + " HEALTH\n"
			if item.item_add_energy:
				stat_string += "+ " + String(item.item_add_energy) + " ENERGY\n"
		"Weapon":
			if item.item_atk:
				stat_string += "+ " + String(item.item_atk) + " ATK\n"
			if item.item_crit_rate:
				stat_string += "+ " + String(item.item_crit_rate) + " CRIT RATE\n"
			if item.item_crit_damage:
				stat_string += "+ " + String(item.item_crit_damage) + " CRIT DAMAGE\n"
		"Cloth":
			if item.item_def:
				stat_string += "+ " + String(item.item_def) + " DEF\n"
	
	stat_label.text = stat_string

