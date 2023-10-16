extends Node

class Item: #carry this to a singleton
	var item_name : String
	var attack : int
	var weight : float
	var value : int
	
var items = {}

func _ready():
	var new_item = Item.new()
	new_item.item_name = "torch"
	new_item.attack = 2
	new_item.weight = 1.0
	new_item.value = 20
	items["torch"] = new_item
	
	new_item.item_name = "wooden spear"
	new_item.attack = 3
	new_item.weight = 2.0
	new_item.value = 20
	items["wooden spear"] = new_item

	new_item = Item.new()
	new_item.item_name = "bronze spear"
	new_item.attack = 5
	new_item.weight = 2.5
	new_item.value = 50
	items["bronze spear"] = new_item

	new_item = Item.new()
	new_item.item_name = "great hammer"
	new_item.attack = 10
	new_item.weight = 10
	new_item.value = 300
	items["great hammer"] = new_item
