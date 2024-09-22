class_name Bullet extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: CPUParticles2D = $Particles
@onready var destroy_timer = $DestroyTimer

var team: int
var column: int
var damage: int = 1
var arrow: bool = false
var dir: float = 0.0
var stopped: bool = false
var shot_by: Tower.Type


func _ready():
	FightUtil.destroy_bullets.connect(_on_destroy_bullets)
	sprite.texture = sprite.texture.duplicate()
	sprite.flip_v = team == 1
	sprite.texture.region.position.x = 0 if not arrow else 8
	destroy_timer.wait_time = particles.lifetime


func _physics_process(_delta):
	if stopped: return
	velocity = Vector2(0, -(Values.BULLET_SPEED if not arrow else Values.ARROW_SPEED)).rotated(dir)
	move_and_slide()


func destroy(emit_particles: bool = true):
	stopped = true
	sprite.visible = false
	if emit_particles:
		particles.emitting = true
		destroy_timer.start()
	else:
		queue_free()


func _on_destroy_bullets() -> void:
	destroy(false)


func _on_area_2d_body_entered(body):
	var bullet: Bullet = body
	if arrow and bullet.team != team:
		bullet.destroy()


func _on_destroy_timer_timeout():
	queue_free()
