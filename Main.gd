extends Node2D

#export(PackedScene) var enemy_scene
var enemy_scene = preload("res://Enemy.tscn")
var score


func _ready():
	randomize()
	_on_MobTimer_timeout()


func _process(delta):
	pass


func _on_Player_hit():
	game_over()
	
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
func _on_ScoreTimer_timeout():
	score += 1

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_MobTimer_timeout():
	# Create a new instance of the Enemy scene.
	#The enemy object will handle its own movement
	var enemy = enemy_scene.instance()
	# Choose a spawn location
	enemy.position = $TestEnemyPosition.position
	
	# Spawn the mob by adding it to the Main scene.
	add_child(enemy)
