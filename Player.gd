extends KinematicBody2D
signal charge_weapon
signal hit


export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.


func _ready():
	pass
	
	
func start(pos):
	position = get_parent().StartPosition
	show()
	$CollisionShape2D.disabled = false


func _process(delta):
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


func _on_Player_body_entered(body):
	#TODO: Remove unnecessary parts of this function. On touching an enemy the player should get hit and then become invuncible for a second
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
