extends Enemy


func setStats():
	SPEED = 40
	$AnimatedSprite.animation = "ElfFighter"
	
#Fighter has no projectile attack
func projectileAttack():
	pass
