extends Area2D
signal weapon_swing

var weapon_charge = 0
var physics_lock = false

onready var WeaponCharge = get_node("/root/Main/HUD/Control/Weapon Charge")

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!physics_lock):
		rotation = find_weapon_rotation()
		scale = Vector2(weapon_charge, weapon_charge)
	if Input.is_action_just_pressed("left_click") and physics_lock == false:
		weapon_charge = 0
		WeaponCharge.set_text(str(0))
		emit_signal("weapon_swing")
		#print("Left Click")
		physics_lock = true
		show()
		check_weapon_targets()
		yield(get_tree().create_timer(0.2), "timeout")
		hide()
		physics_lock = false

func find_weapon_rotation():
	var screenCenter = get_viewport_rect().size/2
	var weaponVector = Vector2(get_viewport().get_mouse_position() - screenCenter)
	return weaponVector.angle() + PI/2
	
func check_weapon_targets():
	for thing in get_overlapping_bodies():
		#print("Got overlapping body")
		if thing.has_method("die"):
			#print("Got enemy")
			thing.die()

func _on_Player_charge_weapon():
	weapon_charge += .02
	WeaponCharge.set_text(str(weapon_charge))
