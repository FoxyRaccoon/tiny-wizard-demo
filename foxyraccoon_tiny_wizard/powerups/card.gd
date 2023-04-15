extends ColorRect

enum CardType{
	BOMB_COUNT,
	BOMB_ZONE,
	BULLET_STRENGTH,
	FIRE_SPEED,
	LIFE_REGEN,
	LIFE_MAX,
	KEY_COUNT,
}

var type

func _ready():
	type = randi_range(0, CardType.size()-1)
	match type:
		CardType.BOMB_COUNT:
			$VBoxContainer/Description.text = "Add a bomb to your inventory"
			$VBoxContainer/HBoxContainer/Prix.text = "2"
		CardType.BOMB_ZONE:
			$VBoxContainer/Description.text = "Increase the bomb explosion radius"
			$VBoxContainer/HBoxContainer/Prix.text = "8"
		CardType.BULLET_STRENGTH:
			$VBoxContainer/Description.text = "Increase the bullet damages"
			$VBoxContainer/HBoxContainer/Prix.text = "14"
		CardType.FIRE_SPEED:
			$VBoxContainer/Description.text = "Increase the speed of casting"
			$VBoxContainer/HBoxContainer/Prix.text = "10"
		CardType.LIFE_REGEN:
			$VBoxContainer/Description.text = "Regenerate a heart"
			$VBoxContainer/HBoxContainer/Prix.text = "6"
		CardType.LIFE_MAX:
			$VBoxContainer/Description.text = "Increase the maximum life"
			$VBoxContainer/HBoxContainer/Prix.text = "12"
		CardType.KEY_COUNT:
			$VBoxContainer/Description.text = "Add a key to the inventory"
			$VBoxContainer/HBoxContainer/Prix.text = "4"

func buy_bonus(character):
	if character is QuiverCharacter:
		if character.inventory.get_item_amount(load("res://tiny_wizard/items/coin/coin.tres")) >= int($VBoxContainer/HBoxContainer/Prix.text):
			character.inventory.remove_item(load("res://tiny_wizard/items/coin/coin.tres"), int($VBoxContainer/HBoxContainer/Prix.text)) 
			match type:
				CardType.BOMB_COUNT:
					character.inventory.add_item(load("res://tiny_wizard/items/pickable_bomb/bomb.tres"))
				CardType.BOMB_ZONE:
					character.bomb_size += 25
				CardType.BULLET_STRENGTH:
					character.bullet_strength += 1
				CardType.FIRE_SPEED:
					character.fire_speed += 2
				CardType.LIFE_REGEN:
					load("res://tiny_wizard/items/hearts/full_heart.tres").use(character)
				CardType.LIFE_MAX:
					character.character_stats.max_life += 2
				CardType.KEY_COUNT:
					character.inventory.add_item(load("res://tiny_wizard/items/key/key.tres"))
			if get_parent() is Control:
				get_parent().get_parent().close_shop()

func _on_prix_pressed():
	buy_bonus(get_node("/root/TinyWizardDemo/Character"))
