extends MarginContainer

@export var inventory : QuiverInventory


@onready var counters = {
	'Bomb': $VBoxContainer/Bombs/BombsCount,
	'Key': $VBoxContainer/Keys/KeysCount,
	'Coin': $VBoxContainer/Coins/CoinsCount,
}

func _ready():
	(inventory as QuiverInventory).item_changed.connect(self.item_changed)
	item_changed(load("res://tiny_wizard/items/pickable_bomb/bomb.tres"))
	item_changed(load("res://tiny_wizard/items/coin/coin.tres"))
	item_changed(load("res://tiny_wizard/items/key/key.tres"))

func item_changed(item:QuiverItem):
	if counters.has(item.name):
		counters[item.name].text = str(inventory.get_item_amount(item))
