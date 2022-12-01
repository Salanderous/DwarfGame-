extends KinematicBody2D
signal charge_weapon
signal hit



export var speed = 250 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
const STARTPOSITION = Vector2(200, 200)
const DODGE_SPEED = 8
var knockback = Vector2(0, 0)
var invincibility = 0
var dodge_cooldown = 0
var dodgeVelocity = Vector2(0, 0)
var dead = false

onready var HealthBar = get_node("/root/Main/HUD/Control/HealthBar")
onready var ReloadButton = get_node("/root/Main/HUD/Control/Button")
onready var EndScore = get_node("/root/Main/HUD/Control/Endscore")

#When the main menu is made, move this to start()
func _ready():
	position = STARTPOSITION
	HealthBar.frame = 0
	$Sparks.emitting = false
	show()
	$CollisionShape2D.disabled = false
	ReloadButton.visible = false


func start(pos):
	return


func _process(delta):
	if (HealthBar.frame == 3):
		dead = true
		$CollisionShape2D.disabled = true
		$AnimatedSprite.hide()
		$DeathParticles.emitting = true
		$DeathParticles.show()
		ReloadButton.visible = true
		EndScore.visible = true
		return
	if (dead):
		return
	if (dodge_cooldown > 0):
		dodge_cooldown -= 1
	if invincibility > 0:
		if ((invincibility % 8) == 0):
			if $AnimatedSprite.visible:
				$AnimatedSprite.hide()
			else:
				$AnimatedSprite.show()
		invincibility -= 1
	#Just to make sure the player never gets stuck as hidden because of getting hit. 
	if invincibility == 0:
		$AnimatedSprite.show()
	if knockback != Vector2(0, 0):
		position += knockback
		knockback = .9 * knockback
		if knockback.length() < 5:
			knockback = Vector2(0, 0)
		return
	
	if dodgeVelocity != Vector2(0, 0):
		position += dodgeVelocity
		dodgeVelocity = .9 * dodgeVelocity
		if dodgeVelocity.length() < 5:
			dodgeVelocity = Vector2(0, 0)
	var velocity = Vector2.ZERO # The player's movement vector.
	var moved = false
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		emit_signal("charge_weapon")
		moved = true
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		emit_signal("charge_weapon")
		moved = true
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		emit_signal("charge_weapon")
		moved = true
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		emit_signal("charge_weapon")
		moved = true
	if Input.is_action_pressed("right_click"):
		if (dodge_cooldown == 0):
			var dodgeVector = Vector2(0, 0)
			dodgeVector.x += velocity.x
			dodgeVector.y += velocity.y
			dodge(dodgeVector)
	if(moved):
		$Sparks.emitting = true
	else:
		$Sparks.emitting = false

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	move_and_collide(velocity * delta)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		if (velocity.x < 0):
			$AnimatedSprite.flip_h = true
			$Sparks.position.x = 10
			$Sparks.direction.x = 1
		else: 
			$AnimatedSprite.flip_h = false
			$Sparks.position.x = -10
			$Sparks.direction.x = -1

func _on_Enemy_body_entered(body):
	#TODO: Remove unnecessary parts of this function. On touching an enemy the player should get hit and then become invuncible for a second
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
func get_camera():
	return $Camera2D
	
func get_position():
	return position
	
func invincibility():
	$CollisionShape2D.set("disabled", true)
	set_collision_layer_bit(1, false)
	yield(get_tree().create_timer(1.0), "timeout")
	$CollisionShape2D.set("disabled", false)
	set_collision_layer_bit(1, true)
	
func dodge(dodgeVector):
	dodgeVelocity = dodgeVector * DODGE_SPEED
	dodge_cooldown = 30
