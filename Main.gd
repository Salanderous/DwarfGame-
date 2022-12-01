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
	score = 0
	Player._ready()
	$MobTimer.start()
	$BossTimer.start()
	$HUD/Control/Endscore.visible = false
	$ScreenDim.visible = false


func _process(delta):
	game_duration += 1
	if (Player.dead == false):
		score += 1
	else:
		$ScreenDim.visible = true
	$HUD/Control/Score.text = str(score)
	$HUD/Control/Endscore.text = "Score: " + str(score)
	
	
func game_over():
	$BossTimer.stop()
	$MobTimer.stop()
	
	
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
	if (enemyCount > 15):
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
	#If there are too many enemies, abort
	var enemyCount = 0
	for thing in self.get_children():
		if (thing.get_class() == enemy.get_class()):
			enemyCount += 1
	if (enemyCount > 5):
		return
	# Choose a spawn location
	enemy.position = spawn_location.position
	# Spawn the mob by adding it to the Main scene.
	add_child(enemy)
	#Increase the spawn rate
	if ($BossTimer.wait_time > 2.5):
		$BossTimer.wait_time = $BossTimer.wait_time * 0.95


func _on_Button_button_down():
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"), 0, false)
	$HUD/Control/Endscore.visible = false
	$ScreenDim.visible = false
	score = 0
	for node in self.get_children():
		if (node.get_class() == "Enemy"):
			node.queue_free()
		if (node.get_class() == "Projectile"):
			node.queue_free()
	Player._ready()
	$MobTimer.start()
	$BossTimer.start()
