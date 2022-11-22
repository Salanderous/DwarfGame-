extends KinematicBody2D
signal hit

class_name Enemy


const SPEED = 25
const KNOCKBACK = 20


onready var Player = get_node("/root/Player")
onready var HealthBar = get_node("/root/Main/HUD/Control/HealthBar")


func _ready():
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	show()
	
func die():
	#print("Enemy died")
	hide()
	queue_free()


func _process(delta):
	var collision = move_and_collide(findPlayerVector() * SPEED * delta)
	if collision:
		if collision.collider.name == "Player":
			if Player.invincibility == 0:
				Player.knockback += findPlayerVector() * KNOCKBACK
				Player.invincibility = 60
				HealthBar.frame += 1
	pass
	
func findPlayerVector():
	return (get_node("/root/Player").position - position).normalized()


#func _on_VisibilityNotifier2D_screen_exited():
	#queue_free()
