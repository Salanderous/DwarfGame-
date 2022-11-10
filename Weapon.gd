extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("left_click"):
		#print("Left Click")
		var hit_things
		hit_things = get_overlapping_bodies()
		for thing in hit_things:
			#print("Got overlapping body")
			if thing.has_method("die"):
				#print("Got enemy")
				thing.die()
