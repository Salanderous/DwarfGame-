extends KinematicBody2D
signal hit

class_name Enemy

var inactive
var SPEED = 25
var KNOCKBACK = 13


onready var Player = get_node("/root/Player")
onready var HealthBar = get_node("/root/Main/HUD/Control/HealthBar")
onready var Main = get_node("/root/Main")


func _ready():
	#Different enemies wil override this to set their stats
	setStats()
	#First, play the spawn animation
	inactive = true
	$CollisionShape2D.disabled = true
	$AnimatedSprite.hide()
	$SpawnParticles.emitting = true
	$SpawnParticles.show()
	$AnimatedSprite.playing = true	
	yield(get_tree().create_timer(3.0), "timeout")
	$AnimatedSprite.show()
	$CollisionShape2D.disabled = false
	inactive = false
	$ProjectileTimer.start()
	
func die():
	inactive = true
	$CollisionShape2D.disabled = true
	$AnimatedSprite.hide()
	$DeathParticles.emitting = true
	$DeathParticles.show()
	Main.score += 100
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()
	return


func _process(delta):
	#Don't do anything if still spawning or dying
	if (inactive):
		return
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

func _on_ProjectileTimer_timeout():
	pass
	
func projectileAttack():
	pass
