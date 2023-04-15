extends QuiverBullet

# A custom bullet type that explode

@export var icon: Texture 

var _freed := false

func _ready():
	$AnimatedSprite2D.modulate = Color(1, 1.0/get_parent().get_node("Character").bullet_strength, 1.0/get_parent().get_node("Character").bullet_strength)
	self.tree_exited.connect(_on_tree_exited)

func _on_tree_exited():
	if _freed: return
	_freed = true
	$AnimatedSprite2D.play("explode")
	($AnimatedSprite2D as AnimatedSprite2D).animation_finished.connect(self.destroy)
	_velocity = Vector2.ZERO
	collision_mask = 0
	bullet_destroyed.emit()

func destroy():
	super.queue_free()
