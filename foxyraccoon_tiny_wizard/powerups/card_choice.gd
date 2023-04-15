extends Control

const CARD = preload("res://foxyraccoon_tiny_wizard/powerups/card.tscn")
var shop = null

func new_cards(shop_object):
	if shop != null:
		close_shop()
	else:
		shop = shop_object
		for card in $HBoxContainer.get_children():
			if card is ColorRect:
				card.queue_free()
		for i in range(3):
			$HBoxContainer.add_child(CARD.instantiate())


func _on_close_pressed():
	close_shop()

func close_shop():
	if shop != null:
		shop.queue_free()
	visible = false
