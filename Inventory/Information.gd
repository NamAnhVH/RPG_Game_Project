extends Node2D

onready var name_label = $InformationItem/Name
onready var stat_label = $InformationItem/Stat
onready var description_label = $InformationItem/Description

func set_information_item(item: Item):
	name_label.text = item.item_name
	
	description_label.text = item.item_description
	
	var stat_string: String
	match item.item_category:
		Items.CONSUMABLE:
			if item.item_stat.has(Items.RESTORE_HEALTH):
				stat_string += "+ " + String(item.item_stat[Items.RESTORE_HEALTH]) + " HEALTH\n"
			if item.item_stat.has(Items.RESTORE_ENERGY):
				stat_string += "+ " + String(item.item_stat[Items.RESTORE_ENERGY]) + " ENERGY\n"
		Items.WEAPON:
			if item.item_stat.has(Items.ATK):
				stat_string += "+ " + String(item.item_stat[Items.ATK]) + " ATK\n"
			if item.item_stat.has(Items.CRIT_RATE):
				stat_string += "+ " + String(item.item_stat[Items.CRIT_RATE]) + "% CRIT RATE\n"
			if item.item_stat.has(Items.CRIT_DAMAGE):
				stat_string += "+ " + String(item.item_stat[Items.CRIT_DAMAGE]) + "% CRIT DAMAGE\n"
		#"Cloth"
	
	stat_label.text = stat_string

