extends Node2D

onready var player = $"../Player"


func _process(delta):
	$Label.text = "Player h_speed: " + str(player.motion.x) + "| Player v_speed: " + str(player.motion.y) 
	$Label2.text = "REVERSED Player h_speed: " + str(player.motion.x * -1) + "| Player v_speed: " + str(player.motion.y*-1) 
