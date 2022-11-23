extends KinematicBody2D
signal hit

class_name Enemy

var spawning
var SPEED = 25
var KNOCKBACK = 25


onready var Player = get_node("/root/Player")
onready var HealthBar = get_node("/root/Main/HUD/Control/HealthBar")


func _ready():
	#Different enemies wil override this to set their stats
	setStats()
	#First, play the spawn animation
	spawning = true
	$CollisionShape2D.disabled = true
	$AnimatedSprite.hide()
	$SpawnParticles.emitting = true
	$SpawnParticles.show()
	$AnimatedSprite.playing = true
	$AnimatedSprite.animation = get_class()
	yield(get_tree().create_timer(3.0), "timeout")
	$AnimatedSprite.show()
	$CollisionShape2D.disabled = false
	spawning = false
	
func die():
	#print("Enemy died")
	hide()
	queue_free()


func _process(delta):
	#Don't do anything if still spawning
	if (spawning):
		return
	#Different enemies will override this with their own projectiles
	projectileAttack()
	var collision = move_and_collide(findPlayerVector() * SPEED * delta)
	if collision:
		if collision.collider.name == "Player":
			if Player.invincibility == 0:
				Player.knockback += findPlayerVector() * KNOCKBACK
				Player.invincibility = 60
				HealthBar.frame += 1
	pass
	
func findPlayerVector():
	return (Player.position - position).normalized()

func setStats():
	pass

func projectileAttack():
	pass
