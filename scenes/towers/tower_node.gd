class_name TowerNode extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var animation = $AnimationPlayer

var empty: bool = true
var tower: Tower


func _ready():
	FightUtil.tower_hit.connect(_on_tower_hit)
	sprite_2d.texture = sprite_2d.texture.duplicate()
	update()


func update():
	if tower != null:
		(sprite_2d.texture as AtlasTexture).region.position.x = FightUtil.tower_sprite_x(tower.type)
	sprite_2d.visible = tower != null and tower.HP > 0


func check_alive():
	if tower.HP <= 0: FightUtil.tower_hide.emit(tower)


func is_alive() -> bool:
	if tower == null: return false
	return tower.HP > 0


func activate() -> void:
	if tower != null:
		tower.activate()


func _on_hitbox_body_entered(body):
	if empty or tower == null: return
	if body is Bullet and body.team != tower.team and tower.HP > 0:
		tower.hit(body.damage)
		body.queue_free()


func _on_tower_hit(t: Tower, _damage: int) -> void:
	if tower == t:
		animation.stop()
		animation.play("blink")
