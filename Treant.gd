extends Enemy

var fireball = preload("res://Projectile.tscn")
var projectileCount = 120
const WALL_SPREAD = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED = 10
	$AnimatedSprite.animation = "TreeNew"
	yield(get_tree().create_timer(3.0), "timeout")
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = false


func projectileAttack():
	if (projectileCount > 0):
		projectileCount -= 1
		return
	if (position - Player.position).length() < 150:
		#Close range attack
		var projectile1 = fireball.instance()
		var projectile2 = fireball.instance()
		var projectile3 = fireball.instance()
		var projectile4 = fireball.instance()
		var projectile5 = fireball.instance()
		var projectile6 = fireball.instance()
		var projectile7 = fireball.instance()
		var projectile8 = fireball.instance()
		# Choose a spawn location
		projectile1.position = self.position
		projectile2.position = self.position
		projectile3.position = self.position
		projectile4.position = self.position
		projectile5.position = self.position
		projectile6.position = self.position
		projectile7.position = self.position
		projectile8.position = self.position
		projectile1.direction = findPlayerVector()
		projectile2.direction = projectile1.direction.rotated(PI/4)
		projectile3.direction = projectile1.direction.rotated(PI/2)
		projectile4.direction = projectile1.direction.rotated(3*PI/4)
		projectile5.direction = projectile1.direction.rotated(PI)
		projectile6.direction = projectile1.direction.rotated(5*PI/4)
		projectile7.direction = projectile1.direction.rotated(3*PI/2)
		projectile8.direction = projectile1.direction.rotated(7*PI/4)
		# Spawn the projectile by adding it to the Main scene.
		get_node("/root/Main").add_child(projectile1)
		get_node("/root/Main").add_child(projectile2)
		get_node("/root/Main").add_child(projectile3)
		get_node("/root/Main").add_child(projectile4)
		get_node("/root/Main").add_child(projectile5)
		get_node("/root/Main").add_child(projectile6)
		get_node("/root/Main").add_child(projectile7)
		get_node("/root/Main").add_child(projectile8)
		projectileCount = 120
		return
	#Else, long range attack
	var projectile1 = fireball.instance()
	var projectile2 = fireball.instance()
	var projectile3 = fireball.instance()
	var projectile4 = fireball.instance()
	var projectile5 = fireball.instance()
	# Choose a spawn location
	projectile1.position = self.position
	projectile2.position = self.position
	projectile3.position = self.position
	projectile4.position = self.position
	projectile5.position = self.position
	projectile1.direction = findPlayerVector()
	projectile2.direction = projectile1.direction
	projectile3.direction = projectile1.direction
	projectile4.direction = projectile1.direction
	projectile5.direction = projectile1.direction
	projectile2.position += (projectile1.direction.rotated(PI/2) * WALL_SPREAD)
	projectile3.position += (projectile1.direction.rotated(-PI/2) * WALL_SPREAD)
	projectile4.position += (projectile1.direction.rotated(PI/2) * WALL_SPREAD * 2)
	projectile5.position += (projectile1.direction.rotated(-PI/2) * WALL_SPREAD * 2)
	# Spawn the projectile by adding it to the Main scene.
	get_node("/root/Main").add_child(projectile1)
	get_node("/root/Main").add_child(projectile2)
	get_node("/root/Main").add_child(projectile3)
	get_node("/root/Main").add_child(projectile4)
	get_node("/root/Main").add_child(projectile5)
	projectileCount = 120
	return
	
func die():
	if ($AnimatedSprite.animation == "TreeNew"):
		$AnimatedSprite.animation = "TreeDamaged"
		return
	if ($AnimatedSprite.animation == "TreeDamaged"):
		$AnimatedSprite.animation = "TreeDying"
		return
	if ($AnimatedSprite.animation == "TreeDying"):
		hide()
		queue_free()
		Main.score += 1000
		return
