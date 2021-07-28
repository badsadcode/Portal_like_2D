extends Control


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

onready var hat_model_decrease = $"VBoxContainer/Hat_Model/HBoxContainer/hat_model_decrease_button"
onready var hat_model_button = $"VBoxContainer/Hat_Model/HBoxContainer/Button2"
onready var hat_model_increase = $"VBoxContainer/Hat_Model/HBoxContainer/hat_model_increase_button"


onready var das_model = $"Body"
onready var das_model_head = $"Body/Head"
onready var das_model_torso = $"Body/Torso"
onready var das_model_arms = $"Body/Arms"
onready var das_model_legs = $"Body/Legs"
onready var das_model_hat = $"Body/Hat"


var hat_color_index = 0
var torso_color_index = 0
var legs_color_index = 0
var hat_model_index = 0

var original_position = Vector2()

signal color_change
signal hat_model_change

const HAT_MODELS = ["res://assets/player_sprites/hat_no_hat.png",
					"res://assets/player_sprites/hat_fedora.png",
					"res://assets/player_sprites/hat_cylinder.png",
					"res://assets/player_sprites/hat_bandana.png",
					"res://assets/player_sprites/hat_bandana2.png",
					"res://assets/player_sprites/hat_johnny_bravo.png"					
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

func _ready():
	original_position = self.get_global_position()
	self.connect("color_change",self,"set_model_colors")	
	self.connect("hat_model_change",self,"set_model")	
	set_color(hat_color_button, hat_style_override, hat_color_index)
	set_color(torso_color_button, torso_style_override, torso_color_index)
	set_color(legs_color_button, legs_style_override, legs_color_index)
	set_model()
	

func set_model_colors():	
	das_model_torso.set_modulate(COLORS[torso_color_index])
	das_model_legs.set_modulate(COLORS[legs_color_index])
	das_model_hat.set_modulate(COLORS[hat_color_index])
	Playervars.player_torso_color = COLORS[torso_color_index]
	Playervars.player_legs_color = COLORS[legs_color_index]
	Playervars.player_hat_color = COLORS[hat_color_index]
	
func set_model():
	das_model_hat.texture = load(HAT_MODELS[hat_model_index])
	var texture_width = das_model_hat.texture.get_width()
	var texture_height = das_model_hat.texture.get_height()
	
	das_model_hat.centered = false
	
	das_model_hat.set_offset(Vector2(-texture_width/2, -texture_height))
	print ("texture_width ",texture_width)
	print ("texture_offsetx ",das_model_hat.get_offset().x)
	Playervars.player_hat_model = HAT_MODELS[hat_model_index]
	
	print (hat_model_index, " MODEL INDEX")



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



func set_color(aObject,aOverride, aIndex):	
	aObject.text = str(aIndex)
	aOverride.bg_color = COLORS[aIndex]
	aObject.add_stylebox_override("disabled",aOverride)


func _on_hat_increase_button_pressed():
	hat_color_index = increase_index(COLORS,hat_color_index)
	set_color(hat_color_button, hat_style_override, hat_color_index)
	emit_signal("color_change")
	hat_increase.release_focus()


func _on_hat_decrease_button_pressed():	
	hat_color_index = decrease_index(COLORS,hat_color_index)	
	set_color(hat_color_button, hat_style_override, hat_color_index)
	emit_signal("color_change")
	hat_decrease.release_focus()


func _on_torso_decrease_button_pressed():	
	torso_color_index = decrease_index(COLORS,torso_color_index)	
	set_color(torso_color_button, torso_style_override, torso_color_index)
	emit_signal("color_change")
	torso_decrease.release_focus()


func _on_torso_increase_button_pressed():	
	torso_color_index = increase_index(COLORS,torso_color_index)	
	set_color(torso_color_button, torso_style_override, torso_color_index)
	emit_signal("color_change")
	torso_increase.release_focus()


func _on_legs_decrease_button_pressed():	
	legs_color_index = decrease_index(COLORS,legs_color_index)	
	set_color(legs_color_button, legs_style_override, legs_color_index)
	emit_signal("color_change")
	legs_decrease.release_focus()

func _on_legs_increase_button_pressed():	
	legs_color_index = increase_index(COLORS,legs_color_index)	
	set_color(legs_color_button, legs_style_override, legs_color_index)
	emit_signal("color_change")
	legs_increase.release_focus()


func _on_hat_model_decrease_button_pressed():
	hat_model_index = decrease_index(HAT_MODELS, hat_model_index)
	emit_signal("hat_model_change")
	hat_model_decrease.release_focus()


func _on_hat_model_increase_button_pressed():
	hat_model_index = increase_index(HAT_MODELS, hat_model_index)
	emit_signal("hat_model_change")
	hat_model_increase.release_focus()
