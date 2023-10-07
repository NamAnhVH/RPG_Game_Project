extends Node

const item_data_path = "res://Data/ItemData.json"
const player_inventory_data_path = "res://Data/PlayerInventoryData.json"

var item_data: Dictionary
var player_inventory_data: Dictionary

func _ready():
	item_data = load_data(item_data_path)
	player_inventory_data = load_data(player_inventory_data_path)

func load_data(file_path):
	var json_data
	var file_data = File.new()
	
	file_data.open(file_path, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	return json_data.result

# Fix Save Game

func update_inventory(location, new_data):
	var file = File.new()
	file.open(player_inventory_data_path, File.WRITE)
	player_inventory_data[location] = new_data
	file.store_line(JSON.print(player_inventory_data))
	file.close()
