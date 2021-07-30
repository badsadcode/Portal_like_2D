extends Node

var default_player_colors =	{
	'player_hat_model':"res://assets/player_sprites/hats/hat_no_hat.png",
	'player_torso_color':Color(1.0, 1.0, 1.0, 1.0),
	'player_legs_color':Color(1.0, 1.0, 1.0, 1.0),
	'player_skin_color':Color(1.0, 1.0, 1.0, 1.0),
	'player_hat_color':Color(1.0, 1.0, 1.0, 1.0),
	'player_laser_color':Color(1.0, 1.0, 1.0, 1.0),	
	}
	
var current_player_colors = {
	'player_hat_model':"res://assets/player_sprites/hats/hat_no_hat.png",
	"player_hat_color":Color(1.0, 1.0, 1.0, 1.0),
	"player_skin_color":Color(2.0, 1.0, 1.0, 1.0),
	"player_torso_color":Color(3.0, 1.0, 1.0, 1.0),
	"player_legs_color":Color(4.0, 1.0, 1.0, 1.0),
	"player_laser_color":Color(5.0, 1.0, 1.0, 1.0),	
	}

#var player_torso_color = Color(1.0, 1.0, 1.0, 1.0)
#var player_legs_color = Color(1.0, 1.0, 1.0, 1.0)
#var player_skin_color = Color(1.0, 1.0, 1.0, 1.0)
#var player_hat_color = Color(1.0, 1.0, 1.0, 1.0)
#var laser_glow_color = Color(1.0, 1.0, 1.0, 1.0)
#var laser_beam_color = Color(1.0, 1.0, 1.0)

# Possible bug when there's no CustomizablePlayer scene in current scene...
# onreadys below will be removed when CharacterCustomizator will be finished
# all changes in CharacterCustomizator will be saved in playervars.gd autoload 
# or in a config file? 
signal update_appearance
#onready var player = get_tree().get_root().get_node("World/CustomizablePlayer")
#onready var player_hat = player.get_node("Body/Hat")
#onready var player_head = player.get_node("Body/Head")
#onready var player_torso = player.get_node("Body/Torso")
#onready var player_arms = player.get_node("Body/Arms")
#onready var player_legs = player.get_node("Body/Legs")
#onready var player_laser_particles = player.get_node("Laser_Beam/Laser_Beam_Particles")
#var player_hat_model = "res://assets/player_sprites/hat_no_hat.png"
#
#
#
#func update_appearance():
#	player_hat.texture = load(Playervars.player_hat_model)
#	var texture_width = player_hat.texture.get_width()
#	var texture_height = player_hat.texture.get_height()	
#	player_hat.centered = false	
#	player_hat.set_offset(Vector2(-texture_width/2, -texture_height))	
#	player_laser_particles.process_material.get_color_ramp().get_gradient().set_color(0,laser_glow_color)
#	#player_laser_particles.process_material.color_ramp.gradient.set_color(0, laser_glow_color)
#	player_hat.modulate = player_hat_color
#	player_torso.modulate = player_torso_color
#	player_legs.modulate = player_legs_color
