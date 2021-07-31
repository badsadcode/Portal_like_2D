extends Control


onready var laser_beam_increase = $"VBoxContainer/Laser_Beam/HBoxContainer/laser_beam_increase_button"
onready var laser_beam_color_button = $"VBoxContainer/Laser_Beam/HBoxContainer/Button2"
onready var laser_beam_decrease = $"VBoxContainer/Laser_Beam/HBoxContainer/laser_beam_decrease_button"

onready var laser_glow_increase = $"VBoxContainer/Laser_Glow/HBoxContainer/laser_glow_increase_button"
onready var laser_glow_color_button = $"VBoxContainer/Laser_Glow/HBoxContainer/Button2"
onready var laser_glow_decrease = $"VBoxContainer/Laser_Glow/HBoxContainer/laser_glow_decrease_button"

onready var hat_increase = $"VBoxContainer/Hat/HBoxContainer/hat_decrease_button"
onready var hat_color_button = $"VBoxContainer/Hat/HBoxContainer/Button2"
onready var hat_decrease = $"VBoxContainer/Hat/HBoxContainer/hat_increase_button"

onready var torso_increase = $"VBoxContainer/Torso/HBoxContainer/torso_increase_button"
onready var torso_color_button = $"VBoxContainer/Torso/HBoxContainer/Button2"
onready var torso_decrease = $"VBoxContainer/Torso/HBoxContainer/torso_decrease_button"

onready var legs_increase = $"VBoxContainer/Pants/HBoxContainer/legs_increase_button"
onready var legs_color_button = $"VBoxContainer/Pants/HBoxContainer/Button2"
onready var legs_decrease = $"VBoxContainer/Pants/HBoxContainer/legs_decrease_button"

onready var hat_style_override = hat_color_button.get_stylebox("disabled").duplicate()
onready var torso_style_override = torso_color_button.get_stylebox("disabled").duplicate()
onready var legs_style_override = legs_color_button.get_stylebox("disabled").duplicate()
onready var laser_glow_style_override = laser_glow_color_button.get_stylebox("disabled").duplicate()
onready var laser_beam_style_override = laser_beam_color_button.get_stylebox("disabled").duplicate()

onready var hat_model_decrease = $"VBoxContainer/Hat_Model/HBoxContainer/hat_model_decrease_button"
onready var hat_model_button = $"VBoxContainer/Hat_Model/HBoxContainer/Button2"
onready var hat_model_increase = $"VBoxContainer/Hat_Model/HBoxContainer/hat_model_increase_button"


onready var model_preview = $"Body"
onready var model_preview_head = $"Body/Head"
onready var model_preview_torso = $"Body/Torso"
onready var model_preview_arms = $"Body/Arms"
onready var model_preview_legs = $"Body/Legs"
onready var model_preview_hat = $"Body/Hat"


var hat_color_index = 0
var torso_color_index = 0
var legs_color_index = 0
var hat_model_index = 0
var laser_beam_color_index = 0
var laser_glow_color_index = 0


var original_position = Vector2()

signal color_change
signal hat_model_change

const HAT_MODELS = [["res://assets/player_sprites/hats/hat_no_hat.png","NO HAT"],
					["res://assets/player_sprites/hats/hat_fedora.png","FEDORA"],
					["res://assets/player_sprites/hats/hat_cylinder.png","CYLINDER"],
					["res://assets/player_sprites/hats/hat_bandana.png","BANDANA"],
					["res://assets/player_sprites/hats/hat_bandana2.png","BANDANA 2"],
					["res://assets/player_sprites/hats/hat_johnny_bravo.png","JOHNNY"],
					
					]


const COLORS = [Color(1.0, 1.0, 1.0, 1.0),	#WHITE
				Color(0.75, 0.076172, 0.076172, 1.0),	# RED 
				Color(0.365707, 0.75, 0.076172, 1.0),	# GREEN
				Color(0.076172, 0.402557, 0.75, 1.0),	# BLUE
				Color(0.665771, 0.076172, 0.75, 1.0),	# PURPLE
				Color(0.076172, 0.686829, 0.75, 1.0),	# TEAL
				Color(0.9375, 0.529003, 0.05127, 1.0),	# ORANGE
				Color(0.40625, 0.34322, 0.209473, 1.0),	# SHIT IN THE WOODS
				Color(1, 0.866667, 0, 1.0), # JOHNNY BRAVO BLOND
				Color(0.128906, 0.128906, 0.128906, 1.0), #BLACK AS A NIGHT
				]

func find_index_color(aColor):
	return COLORS.find(aColor,0)

func find_hat_model_index(aHatModel):
	var result = 0
	for index in HAT_MODELS.size():		
		if HAT_MODELS[index][0] == aHatModel:			
			result = index		
	return result


func _ready():	
	original_position = self.get_global_position()
	# Sets buttons colors on load
	load_set_settings()
	set_preview_model_hat()

func load_set_settings():
	var hat_color = Global.get_setting("PLAYER_COLORS","player_hat_color")	
	var hat_model = Global.get_setting("PLAYER_COLORS","player_hat_model")
	hat_color_index = find_index_color(hat_color)	
	hat_model_index = find_hat_model_index(hat_model)
	set_button_color(hat_color_button, hat_style_override, hat_color_index)
	set_preview_model_hat()
	set_preview_model_colors(model_preview_hat,hat_color)
	
	var torso_color = Global.get_setting("PLAYER_COLORS", "player_torso_color")
	torso_color_index = find_index_color(torso_color)
	set_button_color(torso_color_button, torso_style_override, torso_color_index)
	set_preview_model_colors(model_preview_torso,torso_color)
	
	var legs_color = Global.get_setting("PLAYER_COLORS", "player_legs_color")
	legs_color_index = find_index_color(legs_color)
	set_button_color(legs_color_button, legs_style_override, legs_color_index)
	set_preview_model_colors(model_preview_legs,legs_color)
	
	var laser_beam_color = Global.get_setting("PLAYER_COLORS", "player_laser_beam_color")
	laser_beam_color_index = find_index_color(laser_beam_color)
	set_button_color(laser_beam_color_button, laser_beam_style_override, laser_beam_color_index)
	#set_preview_model_colors(model_preview_laser_beam,laser_beam_color) #NEED TO ADD SOME PREVIEW MODEL FOR LASER BEAM
	
	var laser_glow_color = Global.get_setting("PLAYER_COLORS", "player_laser_glow_color")
	laser_glow_color_index = find_index_color(laser_glow_color)
	set_button_color(laser_glow_color_button, laser_glow_style_override, laser_glow_color_index)
	#set_preview_model_colors(model_preview_laser_glow,laser_glow_color) #NEED TO ADD SOME PREVIEW MODEL FOR LASER glow

# Save current settings to file
func set_configfile_setting(aKey, aValue):
	Global.set_setting("PLAYER_COLORS",aKey,aValue)	
	#Global.config_file.save(Global.config_file_name)
	

func set_playervar_current_setting(aSetting, aValue):
	Playervars.current_player_colors[aSetting] = aValue
	print (Playervars.current_player_colors[aSetting])
	
# Sets current colors settings to playervars
	
	
# Function assigns given color to given model part (hat, hands, torso, legs)
func set_preview_model_colors(aModelPart, aColor : Color):
	aModelPart.set_modulate(aColor)

# Function assings given hat model to preview model
func set_preview_model_hat():
	model_preview_hat.texture = load(HAT_MODELS[hat_model_index][0])
	var texture_width = model_preview_hat.texture.get_width()
	var texture_height = model_preview_hat.texture.get_height()		
	model_preview_hat.centered = false	
	model_preview_hat.set_offset(Vector2(-texture_width/2, -texture_height))
	hat_model_button.text = HAT_MODELS[hat_model_index][1]

# Function overrides given buttons style and changes its color to given value
func set_button_color(aObject,aOverride, aIndex):	
	aObject.text = str(aIndex)
	aOverride.set_modulate(COLORS[aIndex])
	aObject.add_stylebox_override("disabled",aOverride)

func _on_hat_increase_button_pressed():
	hat_color_index = increase_index(COLORS,hat_color_index)
	set_button_color(hat_color_button, hat_style_override, hat_color_index)	
	set_preview_model_colors(model_preview_hat,COLORS[hat_color_index])
	set_playervar_current_setting("player_hat_color",COLORS[hat_color_index])
	set_configfile_setting("player_hat_color",COLORS[hat_color_index])
	hat_increase.release_focus()
	Global.config_file.save(Global.config_file_name)


func _on_hat_decrease_button_pressed():	
	hat_color_index = decrease_index(COLORS,hat_color_index)	
	set_button_color(hat_color_button, hat_style_override, hat_color_index)	
	set_preview_model_colors(model_preview_hat,COLORS[hat_color_index])
	set_playervar_current_setting("player_hat_color",COLORS[hat_color_index])
	set_configfile_setting("player_hat_color",COLORS[hat_color_index])
	hat_decrease.release_focus()
	Global.config_file.save(Global.config_file_name)
	


func _on_torso_decrease_button_pressed():	
	torso_color_index = decrease_index(COLORS,torso_color_index)	
	set_button_color(torso_color_button, torso_style_override, torso_color_index)
	set_preview_model_colors(model_preview_torso,COLORS[torso_color_index])
	set_playervar_current_setting("player_torso_color",COLORS[torso_color_index])
	set_configfile_setting("player_torso_color",COLORS[torso_color_index])
	torso_decrease.release_focus()
	Global.config_file.save(Global.config_file_name)


func _on_torso_increase_button_pressed():	
	torso_color_index = increase_index(COLORS,torso_color_index)	
	set_button_color(torso_color_button, torso_style_override, torso_color_index)
	set_preview_model_colors(model_preview_torso,COLORS[torso_color_index])
	set_playervar_current_setting("player_torso_color",COLORS[torso_color_index])
	set_configfile_setting("player_torso_color",COLORS[torso_color_index])
	torso_increase.release_focus()
	Global.config_file.save(Global.config_file_name)


func _on_legs_decrease_button_pressed():	
	legs_color_index = decrease_index(COLORS,legs_color_index)	
	set_button_color(legs_color_button, legs_style_override, legs_color_index)
	set_preview_model_colors(model_preview_legs,COLORS[legs_color_index])
	set_playervar_current_setting("player_legs_color",COLORS[legs_color_index])
	set_configfile_setting("player_legs_color",COLORS[legs_color_index])
	legs_decrease.release_focus()
	Global.config_file.save(Global.config_file_name)

func _on_legs_increase_button_pressed():	
	legs_color_index = increase_index(COLORS,legs_color_index)	
	set_button_color(legs_color_button, legs_style_override, legs_color_index)
	set_preview_model_colors(model_preview_legs,COLORS[legs_color_index])
	set_playervar_current_setting("player_legs_color",COLORS[legs_color_index])
	set_configfile_setting("player_legs_color",COLORS[legs_color_index])
	legs_increase.release_focus()
	Global.config_file.save(Global.config_file_name)


func _on_hat_model_decrease_button_pressed():
	hat_model_index = decrease_index(HAT_MODELS, hat_model_index)
	hat_model_button.text = HAT_MODELS[hat_model_index][1]
	set_preview_model_hat()
	set_playervar_current_setting("player_hat_model",HAT_MODELS[hat_model_index][0])
	set_configfile_setting("player_hat_model",HAT_MODELS[hat_model_index][0])
	hat_model_decrease.release_focus()
	Global.config_file.save(Global.config_file_name)


func _on_hat_model_increase_button_pressed():
	hat_model_index = increase_index(HAT_MODELS, hat_model_index)
	hat_model_button.text = HAT_MODELS[hat_model_index][1]
	set_preview_model_hat()
	set_playervar_current_setting("player_hat_model",HAT_MODELS[hat_model_index][0])
	set_configfile_setting("player_hat_model",HAT_MODELS[hat_model_index][0])
	hat_model_increase.release_focus()
	Global.config_file.save(Global.config_file_name)


func _on_laser_glow_increase_button_pressed():
	laser_glow_color_index = increase_index(COLORS,laser_glow_color_index)
	set_button_color(laser_glow_color_button, laser_glow_style_override, laser_glow_color_index)
	var laser_glow_color_alpha = COLORS[laser_glow_color_index]
	laser_glow_color_alpha.a = laser_glow_color_alpha.a * 0.5
	set_playervar_current_setting("player_laser_glow_color",laser_glow_color_alpha)
	set_configfile_setting("player_laser_glow_color",laser_glow_color_alpha)
	Global.config_file.save(Global.config_file_name)

	


func _on_laser_glow_decrease_button_pressed():
	laser_glow_color_index = decrease_index(COLORS,laser_glow_color_index)
	set_button_color(laser_glow_color_button, laser_glow_style_override, laser_glow_color_index)
	var laser_glow_color_alpha = COLORS[laser_glow_color_index]
	laser_glow_color_alpha.a = laser_glow_color_alpha.a * 0.5
	set_playervar_current_setting("player_laser_glow_color",laser_glow_color_alpha)
	set_configfile_setting("player_laser_glow_color",laser_glow_color_alpha)
	Global.config_file.save(Global.config_file_name)

func _on_laser_beam_increase_button_pressed():
	laser_beam_color_index = increase_index(COLORS,laser_beam_color_index)
	set_button_color(laser_beam_color_button, laser_beam_style_override, laser_beam_color_index)
	set_playervar_current_setting("player_laser_beam_color",COLORS[laser_beam_color_index])
	set_configfile_setting("player_laser_beam_color",COLORS[laser_beam_color_index])
	Global.config_file.save(Global.config_file_name)
	

func _on_laser_beam_decrease_button_pressed():
	laser_beam_color_index = decrease_index(COLORS,laser_beam_color_index)
	set_button_color(laser_beam_color_button, laser_beam_style_override, laser_beam_color_index)
	set_playervar_current_setting("player_laser_beam_color",COLORS[laser_beam_color_index])
	set_configfile_setting("player_laser_beam_color",COLORS[laser_beam_color_index])
	Global.config_file.save(Global.config_file_name)
	
	
func increase_index(aArray, aIndex):	
	if aIndex + 1 <= aArray.size()-1:		
		aIndex += 1		

	else:

		return 0

	return aIndex


func decrease_index(aArray, aIndex):
	if aIndex - 1 >= 0:
		aIndex -= 1		
	
	else:	
	
		return aArray.size()-1	
	
	return aIndex


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")
