extends Node

signal active_item_updated

const INVENTORY = "Inventory"
const HOTBAR = "Hotbar"
const EQUIPS = "Equips"

const SLOT = preload("res://Inventory/Slot.gd")
const ITEM = preload("res://Item/Item.gd")

const NUM_INVENTORY_SLOTS = 40
const NUM_HOTBAR_SLOTS = 8

var inventory
var hotbar
var equips

func _ready():
	inventory = JsonData.player_inventory_data[INVENTORY]
	hotbar = JsonData.player_inventory_data[HOTBAR]
	equips = JsonData.player_inventory_data[EQUIPS]
	

var active_item_slot = 0

func add_item(item_name, item_stat, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name][Items.STACK_SIZE])
			var able_to_add = stack_size - inventory[item][2]
			if able_to_add >= item_quantity:
				inventory[item][2] += item_quantity
				JsonData.update_inventory(INVENTORY, inventory)
				update_slot_visual(item, inventory[item][0], item_stat, inventory[item][2])
				return
			else:
				inventory[item][2] += able_to_add
				update_slot_visual(item, inventory[item][0], item_stat, inventory[item][2])
				JsonData.update_inventory(INVENTORY, inventory)
				item_quantity = item_quantity - able_to_add
	
	for i in range(NUM_INVENTORY_SLOTS):
		var index = str(i)
		if inventory.has(index) == false:
			inventory[index] = [item_name, item_stat, item_quantity]
			JsonData.update_inventory(INVENTORY, inventory)
			update_slot_visual(i, inventory[index][0], item_stat, inventory[index][2])
			return

func update_slot_visual(slot_index, item_name, item_stat, new_quantity):
	var index = int(slot_index)
	var slot = get_tree().root.get_node("/root/" + Globals.map.name + "/UserInterface/Inventory/Inventory/InventorySlots/Slot" + str(index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, item_stat, new_quantity)
	else:
		slot.initialize_item(item_name, item_stat, new_quantity)

# Fix save_game()

func add_item_to_empty_slot(item: ITEM, slot: SLOT):
	var slot_index = str(slot.slot_index)
	match slot.slot_type:
		SLOT.SlotType.HOTBAR:
			hotbar[slot_index] = [item.item_name, item.item_stat, item.item_quantity]
			JsonData.update_inventory(HOTBAR, hotbar)
		SLOT.SlotType.INVENTORY:
			inventory[slot_index] = [item.item_name, item.item_stat, item.item_quantity]
			JsonData.update_inventory(INVENTORY, inventory)
		_:
			equips[slot_index] = [item.item_name, item.item_stat, item.item_quantity]
			JsonData.update_inventory(EQUIPS, equips)

func remove_item(slot: SLOT):
	var slot_index = str(slot.slot_index)
	match slot.slot_type:
		SLOT.SlotType.HOTBAR:
			hotbar.erase(slot_index)
			JsonData.update_inventory(HOTBAR, hotbar)
		SLOT.SlotType.INVENTORY:
			inventory.erase(slot_index)
			JsonData.update_inventory(INVENTORY, inventory)
		_:
			equips.erase(slot_index)
			JsonData.update_inventory(EQUIPS, equips)

func add_item_quantity(slot: SLOT, value):
	var slot_index = str(slot.slot_index)
	match slot.slot_type:
		SLOT.SlotType.HOTBAR:
			hotbar[slot_index][2] += value
			JsonData.update_inventory(INVENTORY, inventory)
		SLOT.SlotType.INVENTORY:
			inventory[slot_index][2] += value
			JsonData.update_inventory(INVENTORY, inventory)
		_:
			equips[slot_index][2] += value
			JsonData.update_inventory(EQUIPS, equips)

func active_item_scroll_up():
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated")

func active_item_scroll_down():
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	emit_signal("active_item_updated")
