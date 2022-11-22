extends Node2D

var enemy_scene = preload("res://Enemy.tscn")
var score
var game_duration = 0
var STAGE_HEIGHT = 500
var STAGE_LENGTH = 500


onready var Player = get_node("/root/Player")


func _ready():
	randomize()
	new_game()


func _process(delta):
	game_duration += 1
	
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	
func new_game():
	score = 0
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_ScoreTimer_timeout():
	score += 1


func _on_MobTimer_timeout():
	#Set the spawn location
	var spawn_location = get_node("Level/MobPath/MobSpawnLocation")
	spawn_location.offset = randi()
	#If it is too close to the player, abort
	if (Player.position - spawn_location.position).length() < 150:
		print("Spawn prevented due to proximity")
		return
	# Create a new instance of the Enemy scene.
	#The enemy object will handle its own movement
	var enemy = enemy_scene.instance()
	# Choose a spawn location
	enemy.position = spawn_location.position
	
	# Spawn the mob by adding it to the Main scene.
	add_child(enemy)
