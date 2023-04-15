extends QuiverCharacter

@export var gui_path: NodePath
@export var save_res : GameSave
var bomb_size = 125
var fire_speed = 4
var bullet_strength = 1

var arrow_types = {
	'normal': preload("res://tiny_wizard/player/weapon/bullet/arrow.tscn"),
	'violet': preload("res://tiny_wizard/player/weapon/bullet/violet_arrow.tscn"),
}

func _ready():
	save_res = GameSave.new()
	if ResourceLoader.exists("user://save.tres"):
		save_res = load("user://save.tres")
		character_stats.max_life = save_res.max_life
		character_stats.current_life = save_res.current_life
		character_stats.current_shield = save_res.shield
		inventory.add_item(load("res://tiny_wizard/items/coin/coin.tres"), save_res.gold - inventory.get_item_amount(load("res://tiny_wizard/items/coin/coin.tres")))
		inventory.add_item(load("res://tiny_wizard/items/pickable_bomb/bomb.tres"), save_res.bomb - inventory.get_item_amount(load("res://tiny_wizard/items/pickable_bomb/bomb.tres")))
		inventory.add_item(load("res://tiny_wizard/items/key/key.tres"), save_res.key - inventory.get_item_amount(load("res://tiny_wizard/items/key/key.tres")))
		bomb_size = save_res.bomb_size
		fire_speed = save_res.fire_speed
		bullet_strength = save_res.bullet_strength

func hit(damage:=1, from:=Vector2.ZERO):
	super.hit(damage, from)
	$Visual/AnimationPlayer.play("Blink")

func _process(delta):
	if Input.is_action_just_pressed("drop_bomb"):
		(inventory as QuiverInventory).use_item(self, "Bomb")
#			inventory.add_to_item('bombs', -1)
#			var bomb = BOMB_SCENE.instantiate()
#			bomb.position = position
#			get_parent().add_child(bomb)

func change_arrow(arrow_scene):
	$Visual/DistanceWeapon.bullet_scene = arrow_scene
#	inventory.current_arrow = arrow_scene.instantiate().icon
	var gui = get_node_or_null(gui_path)
	if gui != null:
		gui.change_arrow_texture(arrow_scene.instantiate().icon)

func save():
	save_res.max_life = character_stats.max_life
	save_res.current_life = character_stats.current_life
	save_res.shield = character_stats.current_shield
	save_res.gold = inventory.get_item_amount(load("res://tiny_wizard/items/coin/coin.tres"))
	save_res.bomb = inventory.get_item_amount(load("res://tiny_wizard/items/pickable_bomb/bomb.tres"))
	save_res.key = inventory.get_item_amount(load("res://tiny_wizard/items/key/key.tres"))
	save_res.bomb_size = bomb_size
	save_res.fire_speed = fire_speed
	save_res.bullet_strength = bullet_strength
	save_res.level = get_parent().level + 1
	ResourceSaver.save(save_res, "user://save.tres")


