extends Node


var player_torso_color = Color(1.0, 1.0, 1.0, 1.0)
var player_legs_color = Color(1.0, 1.0, 1.0, 1.0)
var player_skin_color = Color(1.0, 1.0, 1.0, 1.0)
var player_hat_color = Color(1.0, 1.0, 1.0, 1.0)
var laser_glow_color = Color(1.0, 1.0, 1.0, 1.0)
var laser_beam_color = Color(0.0, 0.5, 0.8, 1.0)

# Possible bug when there's no CustomizablePlayer scene in current scene...

onready var player = get_tree().get_root().get_node("World/CustomizablePlayer")
onready var player_hat = player.get_node("Body/Hat")
onready var player_head = player.get_node("Body/Head")
onready var player_torso = player.get_node("Body/Torso")
onready var player_arms = player.get_node("Body/arms")
onready var player_legs = player.get_node("Body/Legs")
var player_hat_model = "res://assets/player_sprites/hat_no_hat.png"

signal update_appearance

func update_appearance():
	player_hat.texture = load(Playervars.player_hat_model)
	var texture_width = player_hat.texture.get_width()
	var texture_height = player_hat.texture.get_height()	
	player_hat.centered = false	
	player_hat.set_offset(Vector2(-texture_width/2, -texture_height))	

	player_hat.modulate = player_hat_color
	player_torso.modulate = player_torso_color
	player_legs.modulate = player_legs_color
