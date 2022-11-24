extends Enemy

var fireball = preload("res://Projectile.tscn")
var projectileCount = 100

func setStats():
	SPEED = 0
	
func projectileAttack():
	if (projectileCount > 0):
		projectileCount -= 1
		return
	var projectile1 = fireball.instance()
	var projectile2 = fireball.instance()
	var projectile3 = fireball.instance()
	# Choose a spawn location
	projectile1.position = self.position
	projectile2.position = self.position
	projectile3.position = self.position
	projectile1.direction = findPlayerVector()
	projectile2.direction = projectile1.direction.rotated(PI/8)
	projectile3.direction = projectile1.direction.rotated(-PI/8)
	# Spawn the projectile by adding it to the Main scene.
	get_node("/root/Main").add_child(projectile1)
	get_node("/root/Main").add_child(projectile2)
	get_node("/root/Main").add_child(projectile3)
	projectileCount = 200
	return
