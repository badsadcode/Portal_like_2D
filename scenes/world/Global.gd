extends Node

const TILE_SIZE = 8


const DEFAULT_PLAYER_COLORS = {
	"player_hat_model":"res://assets/player_sprites/hat_no_hat.png",
	"player_hat_color":Color(1.0, 1.0, 1.0, 1.0),
	"player_skin_color":Color(1.0, 1.0, 1.0, 1.0),
	"player_torso_color":Color(1.0, 1.0, 1.0, 1.0),
	"player_legs_color":Color(1.0, 1.0, 1.0, 1.0),
	"player_laser_beam_color":Color(1.0, 1.0, 1.0, 1.0),	
	"player_laser_glow_color":Color(1.0, 1.0, 1.0, 1.0),	
	}

const DEFAULT_KEYBINDS = {
	'left':KEY_A,    
	'right': KEY_D,    
	'jump': KEY_SPACE,
	'pause': KEY_P,
	'l_mouse': BUTTON_LEFT,
	'r_mouse': BUTTON_RIGHT,
	'm_mouse': BUTTON_MIDDLE,
	}	

const DEFAULT_AUDIO_SETTINGS ={
	'master_volume': 0,
	'sfx_volume': 0,
	'music_volume': 0,
	}

# ARRAY TO STORE INFO ABOUT PORTALS
var PortalContainer = []

# SETTINGS/CONFIG
var config_file_name = "config.ini"
var config_file

signal add_message(aMessage)


func _ready():    
	PortalContainer.resize(2)
	config_file = ConfigFile.new()
	if !config_file.load(config_file_name) == OK:
		print ("RESETUJE")
		reset_config_file()
	else:
		print ("Ustawiam klawisze")
		print (load_setting(config_file_name,"PLAYER_COLORS","player_hat_color"))
		set_keybinds()
	

func save_setting(aFileName : String, aSection : String, aKey : String, aValue):
	var cfg_file = ConfigFile.new()
	if cfg_file.load(aFileName) == OK:
		cfg_file.set_value(aSection, aKey, aValue)
	else:
		print ("Failed to load ",aFileName,". Settings where not saved!")
	
func load_setting(aFileName : String, aSection : String, aKey : String):	
	var value
	if config_file.load(aFileName) == OK:
		value = config_file.get_value(aSection, aKey)
	else:
		print ("Failed to load ",aFileName,". Settings where not loaded!")
	
	return value
	
		
	
func reset_config_file():
	config_file.set_value("GENERAL","fullscreen",false)
	
	for key in DEFAULT_KEYBINDS:
		config_file.set_value("KEYBINDS",key,DEFAULT_KEYBINDS[key])
	config_file.save(config_file_name)

	for key in DEFAULT_AUDIO_SETTINGS:
		config_file.set_value("AUDIO",key,DEFAULT_AUDIO_SETTINGS[key])
	config_file.save(config_file_name)
	
	# Reset player colors to default values
	for key in DEFAULT_PLAYER_COLORS:
		config_file.set_value("PLAYER_COLORS", key, DEFAULT_PLAYER_COLORS[key])
	config_file.save(config_file_name)
	
	
	set_audio_settings()
	set_keybinds()


func load_player_colors():
	var player_colors = {}
	for key in config_file.get_section_keys("PLAYER_COLORS"):
		var key_value = config_file.get_value("PLAYER_COLORS", key)
		player_colors[key] = key_value
	print ("PLAYER COLORS:\n",player_colors)
	return player_colors

func set_player_colors():
	var loaded_player_colors = load_player_colors()
	var key_value
	for key in loaded_player_colors.keys():
		key_value = loaded_player_colors[key]
		Playervars.current_player_colors[key] = key_value
		
		
	return key_value

	
	


func load_keybinds():
	var keybinds = {}
	for key in config_file.get_section_keys("KEYBINDS"):
		var key_value = config_file.get_value("KEYBINDS", key)
		keybinds[key] = key_value
	return keybinds
	

# Assign keybinds loaded from config file
func set_keybinds():
	var loaded_keybinds = load_keybinds()
	for key in loaded_keybinds.keys():
		var key_value = loaded_keybinds[key]
		var action = InputMap.get_action_list(key)
		if !action.empty():
			InputMap.action_erase_event(key,action[0])
		
		var new_key = InputEventKey.new()
		new_key.set_scancode(key_value)
		InputMap.action_add_event(key, new_key)


func load_audio_settings():
	var master_volume = config_file.get_value("AUDIO","master_volume")
	var sfx_volume = config_file.get_value("AUDIO","sfx_volume")
	var music_volume = config_file.get_value("AUDIO","music_volume")
	return [master_volume, sfx_volume, music_volume]

# Assign audio settings loaded from config file
func set_audio_settings():
	AudioServer.set_bus_volume_db(0,load_audio_settings()[0])
	AudioServer.set_bus_volume_db(1,load_audio_settings()[1])
	AudioServer.set_bus_volume_db(2,load_audio_settings()[2])


func deletePortals():
	if PortalContainer[0] != null:
		PortalContainer[0].queue_free()
		PortalContainer[0] = null
		
	if PortalContainer[1] != null:
		PortalContainer[1].queue_free()
		PortalContainer[1] = null


func add_message(aMessage):
	emit_signal("add_message",aMessage)



