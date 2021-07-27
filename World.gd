extends Node2D


onready var debug_window = $DebugWindow
onready var player = $PlayerHD


onready var debug_line1 = debug_window.get_node("VBoxContainer/Line1")
onready var debug_line2 = debug_window.get_node("VBoxContainer/Line2")
onready var debug_line3 = debug_window.get_node("VBoxContainer/Line3")
onready var debug_line4 = debug_window.get_node("VBoxContainer/Line4")
onready var debug_line5 = debug_window.get_node("VBoxContainer/Line5")
onready var debug_line6 = debug_window.get_node("VBoxContainer/Line6")


func set_debug_line(aLine, aText, aValue):
	aLine.text = aText + " : " +str(aValue)
	
func _process(delta):
	set_debug_line(debug_line1, "MOTION.X", player.motion.x)
	set_debug_line(debug_line2, "MOTION.Y", player.motion.y)
	set_debug_line(debug_line3, "POSITIION", player.get_global_position())
	set_debug_line(debug_line4, "MAX VELOCITY", player.max_velocity)
	if Global.PortalContainer[0] != null:
		set_debug_line(debug_line5, "ORANGE PORTAL", Global.PortalContainer[0].position)
	if Global.PortalContainer[1] != null:
		set_debug_line(debug_line6, "BLUE PORTAL", Global.PortalContainer[1].position)
	


