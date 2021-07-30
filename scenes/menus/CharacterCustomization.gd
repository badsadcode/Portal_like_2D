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


const COLORS = [Color(1.0, 1.0, 1.0),	#WHITE
				Color(0.75, 0.076172, 0.076172),	# RED 
				Color(0.365707, 0.75, 0.076172),	# GREEN
				Color(0.076172, 0.402557, 0.75),	# BLUE
				Color(0.665771, 0.076172, 0.75),	# PURPLE
				Color(0.076172, 0.686829, 0.75),	# TEAL
				Color(0.9375, 0.529003, 0.05127),	# ORANGE
				Color(0.40625, 0.34322, 0.209473),	# SHIT IN THE WOODS
				Color(1, 0.866667, 0), # JOHNNY BRAVO BLOND
				Color(0.128906, 0.128906, 0.128906), #BLACK AS A NIGHT
				]

func find_index_color(aColor):
	return COLORS.find(Color(aColor),0)
	
func load_setting(aFileName : String, aSection : String, aKey : String):
	var cfg_file = ConfigFile.new()
	var value
	if cfg_file.load(aFileName) == OK:
		value = cfg_file.get_value(aSection, aKey)
	else:
		print ("Failed to load ",aFileName,". Settings where not loaded!")
		return null
	return value

	
func _ready():
	
	original_position = self.get_global_position()
	# Sets buttons colors on load
# EXAMPLE: set_button_color(hat_color_button, hat_style_override, hat_color_index)
	load_settings()
	set_preview_model_hat()

func load_settings():
	var hat_color = Global.load_setting(Global.config_file_name,"PLAYER_COLORS","player_hat_color")
	
	var skin_color = Global.load_setting("config.ini","PLAYER_COLORS", "player_skin_color")
	var torso_color = Global.load_setting("config.ini","PLAYER_COLORS", "player_torso_color")
	var legs_color = Global.load_setting("config.ini","PLAYER_COLORS", "player_legs_color")
	var laser_beam_color = Global.load_setting("config.ini","PLAYER_COLORS", "player_laser_beam_color")
	var laser_glow_color = Global.load_setting("config.ini","PLAYER_COLORS", "player_laser_glow_color")
	
	# Set buttons colors
	print ("Kolor hata to: ",hat_color)
	print ("czy znalazlem: ",find_index_color(hat_color))
	
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

	hat_increase.release_focus()


func _on_hat_decrease_button_pressed():	
	hat_color_index = decrease_index(COLORS,hat_color_index)	
	set_button_color(hat_color_button, hat_style_override, hat_color_index)
	set_preview_model_colors(model_preview_hat,COLORS[hat_color_index])
	hat_decrease.release_focus()


func _on_torso_decrease_button_pressed():	
	torso_color_index = decrease_index(COLORS,torso_color_index)	
	set_button_color(torso_color_button, torso_style_override, torso_color_index)
	set_preview_model_colors(model_preview_torso,COLORS[torso_color_index])
	torso_decrease.release_focus()


func _on_torso_increase_button_pressed():	
	torso_color_index = increase_index(COLORS,torso_color_index)	
	set_button_color(torso_color_button, torso_style_override, torso_color_index)
	set_preview_model_colors(model_preview_torso,COLORS[torso_color_index])
	torso_increase.release_focus()


func _on_legs_decrease_button_pressed():	
	legs_color_index = decrease_index(COLORS,legs_color_index)	
	set_button_color(legs_color_button, legs_style_override, legs_color_index)
	set_preview_model_colors(model_preview_legs,COLORS[legs_color_index])
	legs_decrease.release_focus()

func _on_legs_increase_button_pressed():	
	legs_color_index = increase_index(COLORS,legs_color_index)	
	set_button_color(legs_color_button, legs_style_override, legs_color_index)
	set_preview_model_colors(model_preview_legs,COLORS[legs_color_index])
	legs_increase.release_focus()


func _on_hat_model_decrease_button_pressed():
	hat_model_index = decrease_index(HAT_MODELS, hat_model_index)
	hat_model_button.text = HAT_MODELS[hat_model_index][1]
	set_preview_model_hat()
	hat_model_decrease.release_focus()


func _on_hat_model_increase_button_pressed():
	hat_model_index = increase_index(HAT_MODELS, hat_model_index)
	hat_model_button.text = HAT_MODELS[hat_model_index][1]
	set_preview_model_hat()
	hat_model_increase.release_focus()


func _on_laser_glow_increase_button_pressed():
	laser_glow_color_index = increase_index(COLORS,laser_glow_color_index)
	set_button_color(laser_glow_color_button, laser_glow_style_override, laser_glow_color_index)
	Playervars.laser_glow_color = COLORS[laser_glow_color_index]
	


func _on_laser_glow_decrease_button_pressed():
	laser_glow_color_index = decrease_index(COLORS,laser_glow_color_index)
	set_button_color(laser_glow_color_button, laser_glow_style_override, laser_glow_color_index)
	Playervars.laser_glow_color = COLORS[laser_glow_color_index]



func _on_laser_beam_increase_button_pressed():
	laser_beam_color_index = increase_index(COLORS,laser_beam_color_index)
	set_button_color(laser_beam_color_button, laser_beam_style_override, laser_beam_color_index)
	Playervars.laser_beam_color = COLORS[laser_beam_color_index]

func _on_laser_beam_decrease_button_pressed():
	laser_beam_color_index = decrease_index(COLORS,laser_beam_color_index)
	set_button_color(laser_beam_color_button, laser_beam_style_override, laser_beam_color_index)
	Playervars.laser_beam_color = COLORS[laser_beam_color_index]

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
