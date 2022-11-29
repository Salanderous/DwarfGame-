extends Area2D
signal weapon_swing

const MAX_CHARGE = 1.3
const MIN_CHARGE = 0.3
const CHARGE_RATE = 0.005

var weapon_charge = 0
var physics_lock = false

onready var WeaponCharge = get_node("/root/Main/HUD/Control/Weapon Charge")

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if($AnimatedSprite.frame == 0):
		$AnimatedSprite.playing = false
		hide()
		physics_lock = false
	if (!physics_lock):
		rotation = find_weapon_rotation()
		if (weapon_charge > MIN_CHARGE):
			scale = Vector2(weapon_charge, weapon_charge)
		else:
			scale = Vector2(MIN_CHARGE, MIN_CHARGE)
	if Input.is_action_just_pressed("left_click") and physics_lock == false:
		weapon_charge = 0
		WeaponCharge.set_text(str(0))
		emit_signal("weapon_swing")
		#print("Left Click")
		physics_lock = true
		$AnimatedSprite.playing = true
		$AnimatedSprite.frame = 1
		show()
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
			print("Projectile detected")
			thing._on_Lifetime_timeout()
	return

func _on_Player_charge_weapon():
	if (weapon_charge < MAX_CHARGE):
		weapon_charge += CHARGE_RATE
	WeaponCharge.set_text(str(weapon_charge))
	return
