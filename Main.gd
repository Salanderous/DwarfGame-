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
	$HUD/Control/Endscore.visible = false


func _process(delta):
	game_duration += 1
	score += 1
	$HUD/Control/Score.text = str(score)
	$HUD/Control/Endscore.text = str(score)
	
	
func game_over():
	$BossTimer.stop()
	$MobTimer.stop()
	
	
	
func new_game():
	score = 0
	$MobTimer.start()
	$BossTimer.start()
	Player._ready()
	
func _on_ScoreTimer_timeout():
	score += 1


func _on_MobTimer_timeout():
	#Set the spawn location
	var spawn_location = get_node("Level/MobPath/MobSpawnLocation")
	spawn_location.offset = randi()
	# Create a new instance of the Enemy scene.
	enemy_list.shuffle()
	var enemy = enemy_list[0].instance()
	#If there are too many enemies, abort
	var enemyCount = 0
	for thing in self.get_children():
		if (thing.get_class() == enemy.get_class()):
			enemyCount += 1
	if (enemyCount > 20):
		print("max enemies")
		return
	# Choose a spawn location
	enemy.position = spawn_location.position
	# Spawn the mob by adding it to the Main scene.
	add_child(enemy)
	#Increase the spawn rate
	if ($MobTimer.wait_time > 0.5):
		$MobTimer.wait_time = $MobTimer.wait_time * 0.95
	
func _on_BossTimer_timeout():
	#Set the spawn location
	var spawn_location = get_node("Level/MobPath/MobSpawnLocation")
	spawn_location.offset = randi()
	# Create a new instance of the Enemy scene.
	var enemy = boss.instance()
	# Choose a spawn location
	enemy.position = spawn_location.position
	# Spawn the mob by adding it to the Main scene.
	add_child(enemy)
	#Increase the spawn rate
	if ($BossTimer.wait_time > 2.5):
		$BossTimer.wait_time = $BossTimer.wait_time * 0.95


func _on_Button_button_down():
	get_tree().reload_current_scene()
