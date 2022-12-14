extends Area2D
signal weapon_swing

const MAX_CHARGE = 1.0
const MIN_CHARGE = 0.25
const CHARGE_RATE = 0.008

var weapon_charge = 0
var physics_lock = false
var playChargeSound = true
var WeaponCharge
var spawnFrame

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnFrame = true
	WeaponCharge = get_node("/root/Main/HUD/Control/Weapon Charge")
	show()
	$AnimatedSprite.hide()
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (spawnFrame):
		spawnFrame = false
		return
	if($AnimatedSprite.frame == 0):
		$AnimatedSprite.playing = false
		$AnimatedSprite.hide()
		$Swing.playing = false
		physics_lock = false
	if (!physics_lock):
		rotation = find_weapon_rotation()
		if (weapon_charge > MIN_CHARGE):
			scale = Vector2(weapon_charge, weapon_charge)
		else:
			scale = Vector2(MIN_CHARGE, MIN_CHARGE)
	if Input.is_action_just_pressed("left_click") and physics_lock == false and get_parent().dead == false:
		weapon_charge = 0
		$Swing.playing = true
		playChargeSound = true
		WeaponCharge.set_text(str(0))
		emit_signal("weapon_swing")
		#print("Left Click")
		physics_lock = true
		$AnimatedSprite.playing = true
		$AnimatedSprite.frame = 1
		$AnimatedSprite.show()
		check_weapon_targets()
	return

func find_weapon_rotation():
	var screenCenter = get_viewport_rect().size/2
	var weaponVector = Vector2(get_viewport().get_mouse_position() - screenCenter)
	return weaponVector.angle() + PI/2
	
func check_weapon_targets():
	for thing in get_overlapping_bodies():
		if thing.has_method("die"):
			thing.die()
		if thing.has_method("_on_Lifetime_timeout"):
			thing._on_Lifetime_timeout()
	return

func _on_Player_charge_weapon():
	if (weapon_charge < MAX_CHARGE):
		weapon_charge += CHARGE_RATE
	else:
		if (playChargeSound == true):
			$FullCharge.playing = true
			playChargeSound = false
	WeaponCharge.set_text(str(weapon_charge))
	return
