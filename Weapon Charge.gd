extends Label

var chargeText


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func _process(delta):
	pass

func _on_Weapon_weapon_swing():
	text = str(0)
	
func _on_Weapon_weapon_charge():
	text = str(int(text) + 0.5)
