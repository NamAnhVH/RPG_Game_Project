extends Node2D

onready var name_label = $InformationItem/Name
onready var stat_label = $InformationItem/Stat
onready var description_label = $InformationItem/Description

func set_information_item(item: Item):
	name_label.text = item.item_name
	
	description_label.text = item.item_description
	
	var stat_string: String
	var count = 1
	var trash = false
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
				var crit_rate = item.item_stat[Items.CRIT_RATE]
				if crit_rate > 0:
					stat_string += "+ " + String(crit_rate) + "% CRIT RATE\n"
					count += 1
				else:
					stat_string += "- " + String(-crit_rate) + "% CRIT RATE\n"
					trash = true
			if item.item_stat.has(Items.CRIT_DAMAGE):
				var crit_damage = item.item_stat[Items.CRIT_DAMAGE]
				if crit_damage > 0:
					stat_string += "+ " + String(crit_damage) + "% CRIT DAMAGE\n"
					count += 1
				else:
					stat_string += "- " + String(-crit_damage) + "% CRIT DAMAGE\n"
					trash = true
		#"Cloth"
	if trash:
		name_label.set("custom_colors/font_color", Color8(179,33,33))
	else:
		match count:
			1: name_label.set("custom_colors/font_color", Color8(255,255,255))
			2: name_label.set("custom_colors/font_color", Color8(55,228,20))
			3: name_label.set("custom_colors/font_color", Color8(20,200,255))
	stat_label.text = stat_string

