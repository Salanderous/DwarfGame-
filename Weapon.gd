extends Area2D
signal weapon_swing

var weapon_charge = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		scale = Vector2(weapon_charge, weapon_charge)
		weapon_charge = 0
		emit_signal("weapon_swing")
		rotation = find_weapon_rotation()
		#print("Left Click")
		show()
		var hit_things
		hit_things = get_overlapping_bodies()
		for thing in hit_things:
			#print("Got overlapping body")
			if thing.has_method("die"):
				#print("Got enemy")
				thing.die()
		yield(get_tree().create_timer(1.0), "timeout")
		hide()
		

func find_weapon_rotation():
	var screenCenter = get_viewport_rect().size/2
	var weaponVector = Vector2(get_viewport().get_mouse_position() - screenCenter)
	#print("Mouse Position:")
	#print(get_viewport().get_mouse_position())
	#print("Screen Center:")
	#print(screenCenter)
	#print("Weapon Vector:")
	#print(weaponVector.normalized())
	return weaponVector.angle() + PI/2
	


func _on_Player_charge_weapon():
	weapon_charge += .05
