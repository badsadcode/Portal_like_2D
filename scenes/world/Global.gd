extends Node

# ARRAY TO STORE INFO ABOUT PORTALS
var PortalContainer = []
const TILE_SIZE = 8

# SETTINGS/CONFIG
var config_file_name = "config.ini"
var config_file

# DEFAULT KEYBINDS
var default_keybinds = {
	'left':KEY_A,	
	'right': KEY_D,	
	'jump': KEY_SPACE,
	'pause': KEY_P,
	}
var default_audio_settings ={
	'master_volume': 0,
	'sfx_volume': 0,
	'music_volume': 0,
	}

signal add_message(aMessage)


func _ready():	
	PortalContainer.resize(2)
	config_file = ConfigFile.new()
	if !config_file.load(config_file_name) == OK:
		reset_config_file()
	else:
		set_keybinds()
	print("domel",set_player_colors())

# CONFIG FILE HANDLING
func reset_config_file():
	config_file.set_value("GENERAL","fullscreen",false)
	
	for key in default_keybinds:
		config_file.set_value("KEYBINDS",key,default_keybinds[key])
	config_file.save(config_file_name)

	for key in default_audio_settings:
		config_file.set_value("AUDIO",key,default_audio_settings[key])
	config_file.save(config_file_name)
	
	# Reset player colors to default values
	for key in Playervars.default_player_colors:
		config_file.set_value("PLAYER_COLORS", key, Playervars.default_player_colors[key])
	config_file.save(config_file_name)
	
	
	set_audio_settings()
	set_keybinds()


func load_player_colors():
	var player_colors = {}
	for key in config_file.get_section_keys("PLAYER_COLORS"):
		var key_value = config_file.get_value("PLAYER_COLORS", key)
		player_colors[key] = key_value
	return player_colors

func set_player_colors():
	var loaded_player_colors = load_player_colors()
	var key_value
	for key in loaded_player_colors.keys():
		key_value = loaded_player_colors[key]
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

