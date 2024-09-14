class_name Bullet extends CharacterBody2D

var team: int
var damage: int = 1
var dir: float = 0.0


func _physics_process(_delta):
	velocity = Vector2(0, -Values.BULLET_SPEED).rotated(dir)
	move_and_slide()
