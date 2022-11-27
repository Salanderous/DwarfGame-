extends Node2D

var enemy_list = [preload("res://ElfFighter.tscn"), preload("res://ElfMage.tscn")]
var boss = preload("res://Treant.tscn")
var score = 0
var game_duration = 0
var STAGE_HEIGHT = 500
var STAGE_LENGTH = 500


onready var Player = get_node("/root/Player")


func _ready():
	randomize()
	new_game()


func _process(delta):
	game_duration += 1
	score += 1
	$HUD/Control/Score.text = str(score)
	
	
func game_over():
	$ScoreTimer.stop()
	$BossTimer.stop()
	$MobTimer.stop()
	
	
func new_game():
	score = 0
	$MobTimer.start()
	$BossTimer.start()
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
	enemy_list.shuffle()
	var enemy = enemy_list[0].instance()
	# Choose a spawn location
	enemy.position = spawn_location.position
	# Spawn the mob by adding it to the Main scene.
	add_child(enemy)
	
func _on_BossTimer_timeout():
	#Set the spawn location
	var spawn_location = get_node("Level/MobPath/MobSpawnLocation")
	spawn_location.offset = randi()
	#If it is too close to the player, abort
	if (Player.position - spawn_location.position).length() < 150:
		print("Spawn prevented due to proximity")
		return
	# Create a new instance of the Enemy scene.
	var enemy = boss.instance()
	# Choose a spawn location
	enemy.position = spawn_location.position
	# Spawn the mob by adding it to the Main scene.
	add_child(enemy)
	print("Boss spawned")
