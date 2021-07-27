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

onready var das_model = $"Body"
onready var das_model_head = $"Body/Head"
onready var das_model_torso = $"Body/Torso"
onready var das_model_arms = $"Body/Arms"
onready var das_model_legs = $"Body/Legs"


var hat_color_index = 0
var torso_color_index = 0
var legs_color_index = 0

var original_position = Vector2()

signal color_change


const COLORS = [Color(1.0, 1.0, 1.0),	#WHITE
				Color(0.75, 0.076172, 0.076172),	# RED 
				Color(0.365707, 0.75, 0.076172),	# GREEN
				Color(0.076172, 0.402557, 0.75),	# BLUE
				Color(0.665771, 0.076172, 0.75),	# PURPLE
				Color(0.076172, 0.686829, 0.75),	# TEAL
				Color(0.9375, 0.529003, 0.05127),	# ORANGE
				Color(0.40625, 0.34322, 0.209473),	# SHIT IN THE WOODS
				]

func _ready():
	original_position = self.get_global_position()
	self.connect("color_change",self,"set_model_colors")	
	set_color(hat_color_button, hat_style_override, hat_color_index)
	set_color(torso_color_button, torso_style_override, torso_color_index)
	set_color(legs_color_button, legs_style_override, legs_color_index)

func set_model_colors():	
	das_model_torso.set_modulate(COLORS[torso_color_index])
	das_model_legs.set_modulate(COLORS[legs_color_index])
	Playervars.player_torso_color = COLORS[torso_color_index]
	Playervars.player_legs_color = COLORS[legs_color_index]
	print ("COLOR CHANGED BY SIGNAL")




func increase_index(aArray, aIndex):
	if aIndex + 1 < aArray.size()-1:
		print ("No zwiekszykłem")
		aIndex += 1
	else:
		print ("Cos poszlo nie tak")
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
