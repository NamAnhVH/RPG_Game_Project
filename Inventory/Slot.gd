extends Panel
class_name Slot

const DEFAULT_TEX = preload("res://Art/Inventory/Item/item_slot_default.png")
const EMPTY_TEX = preload("res://Art/Inventory/Item/item_slot_empty.png")
const SELECTED_TEX = preload("res://Art/Inventory/Item/item_slot_selected.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null

var item = null
var slot_index
var slot_type

enum SlotType{
	HOTBAR = 0,
	INVENTORY,
	WEAPON,
	HAT,
	SHIRT,
	PANTS,
	SHOES,
	ACCESSORY
}

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	default_style.texture = DEFAULT_TEX
	empty_style.texture = EMPTY_TEX
	selected_style.texture = SELECTED_TEX
	refresh_style()

func refresh_style():
	if slot_type == SlotType.HOTBAR && PlayerInventory.active_item_slot == slot_index:
		set("custom_styles/panel", selected_style)
	elif item == null:
		set("custom_styles/panel", empty_style)
	elif slot_type == SlotType.INVENTORY || slot_type == SlotType.HOTBAR:
		set("custom_styles/panel", default_style)
	else:
		set("custom_styles/panel", selected_style)
	if slot_type != SlotType.HOTBAR && slot_type != SlotType.INVENTORY:
		var icon = get_child(0)
		if item != null:
			icon.texture = null
		else:
			match slot_type:
				SlotType.WEAPON:
					icon.texture = load("res://Art/Inventory/Item/weapon_overlay.png")
				SlotType.HAT:
					icon.texture = load("res://Art/Inventory/Item/hat_overlay.png")
				SlotType.SHIRT:
					icon.texture = load("res://Art/Inventory/Item/shirt_overlay.png")
				SlotType.PANTS:
					icon.texture = load("res://Art/Inventory/Item/pants_overlay.png")
				SlotType.SHOES:
					icon.texture = load("res://Art/Inventory/Item/shoes_overlay.png")
				SlotType.ACCESSORY:
					icon.texture = load("res://Art/Inventory/Item/accessory_overlay.png")


func pick_from_slot():
	remove_child(item)
	var inventory_node = find_parent("UserInterface")
	inventory_node.add_child(item)
	item = null
	refresh_style()

func put_into_slot(new_item):
	item = new_item
	item.position = Vector2.ZERO
	var inventory_node = find_parent("UserInterface")
	inventory_node.remove_child(item)
	add_child(item)
	refresh_style()

func drop_from_slot():
	remove_child(item)
	item = null
	refresh_style()

func initialize_item(item_name, item_stat, item_quantity = 1):
	if item == null:
		item = load("res://Item/Item.tscn").instance()
		add_child(item)
		item.set_item(item_name, item_stat, item_quantity)
	else:
		item.set_item(item_name, item_stat, item_quantity)
	refresh_style()
