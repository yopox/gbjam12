class_name Bullet extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: CPUParticles2D = $Particles

var team: int
var damage: int = 1
var dir: float = 0.0
var reflected: bool = false
var stopped: bool = false


func _ready():
	FightUtil.destroy_bullets.connect(_on_destroy_bullets)


func _physics_process(_delta):
	if stopped: return
	velocity = Vector2(0, -Values.BULLET_SPEED).rotated(dir)
	move_and_slide()


func _on_destroy_bullets() -> void:
	stopped = true
	sprite.visible = false
	particles.emitting = true
