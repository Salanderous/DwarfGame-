extends KinematicBody2D


var direction = null
var SPEED = 60
var KNOCKBACK = 10

onready var Player = get_node("/root/Player")
onready var HealthBar = get_node("/root/Main/HUD/Control/HealthBar")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _process(delta):
	var collision = move_and_collide(direction * SPEED * delta)
	if collision:
		if collision.collider.name == "Player":
			if Player.invincibility == 0:
				Player.knockback += direction * KNOCKBACK
				Player.invincibility = 60
				HealthBar.frame += 1
				_on_Lifetime_timeout()
		if collision.collider.name == "Level":
			_on_Lifetime_timeout()
	
func _on_Lifetime_timeout():
	hide()
	queue_free()
