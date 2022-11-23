extends KinematicBody2D
signal charge_weapon
signal hit



export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
const STARTPOSITION = Vector2(200, 200)
var knockback = Vector2(0, 0)
var invincibility = 0

#When the main menu is made, move this to start()
func _ready():
	position = STARTPOSITION
	show()
	$CollisionShape2D.disabled = false
	
	
func start(pos):
	pass


func _process(delta):
	if invincibility > 0:
		if ((invincibility % 6) == 0):
			if visible:
				hide()
			else:
				show()
		invincibility -= 1
	#Just to make sure the player never gets stuck as hidden because of getting hit. 
	#If the player is visible and should not be, look here
	if invincibility == 0:
		show()
	if knockback != Vector2(0, 0):
		position += knockback
		knockback = .9 * knockback
		if knockback.length() < 5:
			knockback = Vector2(0, 0)
		return
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		emit_signal("charge_weapon")
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		emit_signal("charge_weapon")
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		emit_signal("charge_weapon")
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		emit_signal("charge_weapon")

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += velocity * delta
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0


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
	yield(get_tree().create_timer(1.0), "timeout")
	$CollisionShape2D.set("disabled", false)
