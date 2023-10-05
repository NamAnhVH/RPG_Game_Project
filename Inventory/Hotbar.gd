extends Node2D

const SLOT = preload("res://Inventory/Slot.gd")

onready var hotbar_slots = $TextureRect/HotbarlSlots
onready var active_item_label = $TextureRect/ActiveItemLabel
onready var slots = hotbar_slots.get_children()
onready var parent = get_parent()

func _ready():
	PlayerInventory.connect("active_item_updated", self, "update_active_item_label")
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		PlayerInventory.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].slot_index = i
		slots[i].slot_type = SLOT.SlotType.HOTBAR
	initialize_inventory()
	update_active_item_label()

func initialize_inventory():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])

func update_active_item_label():
	if slots[PlayerInventory.active_item_slot].item != null:
		active_item_label.text = slots[PlayerInventory.active_item_slot].item.item_name
	else:
		active_item_label.text = ""

func slot_gui_input(event, slot: SLOT):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if parent.holding_item != null:
				if !slot.item:
					left_click_empty_item(slot)
				else:
					if parent.holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif slot.item:
				left_click_not_holding(slot)
			update_active_item_label()

func left_click_empty_item(slot: SLOT):
	PlayerInventory.add_item_to_empty_slot(parent.holding_item, slot)
	slot.put_into_slot(parent.holding_item)
	parent.holding_item = null

func left_click_different_item(event: InputEvent, slot: SLOT):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(parent.holding_item, slot)
	var temp_item = slot.item
	slot.pick_from_slot()
	temp_item.global_position = event.global_position
	slot.put_into_slot(parent.holding_item)
	parent.holding_item = temp_item

func left_click_same_item(slot):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= parent.holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, parent.holding_item.item_quantity)
		slot.item.add_item_quantity(parent.holding_item.item_quantity)
		parent.holding_item.queue_free()
		parent.holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		parent.holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot: SLOT):
	PlayerInventory.remove_item(slot)
	parent.holding_item = slot.item
	slot.pick_from_slot()
	parent.holding_item.global_position = get_global_mouse_position()
