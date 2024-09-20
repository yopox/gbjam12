class_name Bullet extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: CPUParticles2D = $Particles

var team: int
var column: int
var damage: int = 1
var arrow: bool = false
var dir: float = 0.0
var stopped: bool = false


func _ready():
	FightUtil.destroy_bullets.connect(_on_destroy_bullets)
	sprite.texture = sprite.texture.duplicate()
	sprite.flip_v = team == 1
	sprite.texture.region.position.x = 0 if not arrow else 8


func _physics_process(_delta):
	if stopped: return
	velocity = Vector2(0, -Values.BULLET_SPEED).rotated(dir)
	move_and_slide()


func destroy():
	stopped = true
	sprite.visible = false
	particles.emitting = true
	await Util.wait(particles.lifetime)
	queue_free()


func _on_destroy_bullets() -> void:
	destroy()


func _on_area_2d_body_entered(body):
	var bullet: Bullet = body
	if arrow and bullet.team != team:
		bullet.destroy()
