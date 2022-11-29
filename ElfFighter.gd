extends Enemy


func setStats():
	SPEED = 80
	$AnimatedSprite.animation = "ElfFighter"
	
#Fighter has no projectile attack
func projectileAttack():
	pass
