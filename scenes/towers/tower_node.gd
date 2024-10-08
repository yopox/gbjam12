class_name TowerNode extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var animation = $AnimationPlayer
@onready var popup: TowerPopup = $Popup

var empty: bool = true
var tower: Tower

var shoot_id: int = 0


func _ready():
	FightUtil.tower_hit.connect(_on_tower_hit)
	FightUtil.tower_shoot.connect(_on_tower_shoot)
	FightUtil.tower_ghostly.connect(_on_tower_ghostly)
	FightUtil.destroy_tower.connect(_on_destroy_tower)
	sprite_2d.texture = sprite_2d.texture.duplicate()
	popup.visible = false
	popup.z_index = Values.POPUP_Z
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
		body.destroy(not tower.ghostly)
		tower.hit(body)


func _on_tower_hit(t: Tower, _damage: int, _bullet: Bullet) -> void:
	if tower == t:
		animation.stop()
		animation.play("blink")


func _on_destroy_tower(t: Tower) -> void:
	if tower == t:
		animation.stop()
		animation.play("blink")


func _on_tower_shoot(t: Tower, _damage: int) -> void:
	if t != tower or t == null: return
	if t.HP <= 0: return
	animation.stop()
	sprite_2d.visible = true
	if t.type in [Tower.Type.COIN, Tower.Type.ROCK, Tower.Type.BOMB, Tower.Type.MIRROR]: return
	shoot_id += 1
	var id = shoot_id
	(sprite_2d.texture as AtlasTexture).region.position.x = FightUtil.tower_sprite_x(tower.type) + 16
	await Util.wait(Values.TOWER_SHOOT_FRAME_DURATION)
	if not tower.ghostly and shoot_id == id:
		(sprite_2d.texture as AtlasTexture).region.position.x = FightUtil.tower_sprite_x(tower.type)


func _on_tower_ghostly(t: Tower, ghostly: bool) -> void:
	if t != tower: return
	var offset = 16 if ghostly else 0
	(sprite_2d.texture as AtlasTexture).region.position.x = FightUtil.tower_sprite_x(tower.type) + offset


func show_popup(display: bool, force_right: bool) -> void:
	if tower == null:
		popup.visible = false
		return
	if display: popup.set_tower(tower)
	
	popup.reset_size()
	
	if global_position.y > 60: popup.position.y = -popup.size.y + 8
	else: popup.position.y = -8
	
	if not force_right and global_position.x > 80: popup.position.x = -popup.size.x - 10
	else: popup.position.x = 10
	
	popup.visible = display
