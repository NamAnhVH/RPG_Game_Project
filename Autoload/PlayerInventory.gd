extends Node

signal active_item_updated

const SLOT = preload("res://Inventory/Slot.gd")
const ITEM = preload("res://Item/Item.gd")

const NUM_INVENTORY_SLOTS = 40
const NUM_HOTBAR_SLOTS = 8

var inventory = {
	0: ["Iron Sword", 1],
	1: ["Stone Sword", 1],
	3: ["Apple", 97]
}

var hotbar = {
	0: ["Iron Sword", 1],
	1: ["Stone Sword", 1],
	3: ["Apple", 97]
}

var equips = {
	2: ["Farmer Shirt", 1],
	5: ["Farmer Pants", 1]
}

var active_item_slot = 0

func add_item(item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				item_quantity = item_quantity - able_to_add
	
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			update_slot_visual(i, inventory[i][0], inventory[i][1])
			return

func update_slot_visual(slot_index, item_name, new_quantity):
	var slot = get_tree().root.get_node("/root/" + Globals.map.name + "/UserInterface/Inventory/Inventory/InventorySlots/Slot" + str(slot_index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)

func add_item_to_empty_slot(item: ITEM, slot: SLOT):
	match slot.SlotType:
		SLOT.SlotType.HOTBAR:
			hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
		SLOT.SlotType.INVENTORY:
			inventory[slot.slot_index] = [item.item_name, item.item_quantity]
		_:
			equips[slot.slot_index] = [item.item_name, item.item_quantity]

func remove_item(slot: SLOT):
	match slot.SlotType:
		SLOT.SlotType.HOTBAR:
			hotbar.erase(slot.slot_index)
		SLOT.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)
		_:
			equips.erase(slot.slot_index)

func add_item_quantity(slot: SLOT, value):
	match slot.SlotType:
		SLOT.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] += value
		SLOT.SlotType.INVENTORY:
			inventory[slot.slot_index][1] += value
		_:
			equips[slot.slot_index][1] += value

func active_item_scroll_up():
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated")

func active_item_scroll_down():
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	emit_signal("active_item_updated")
