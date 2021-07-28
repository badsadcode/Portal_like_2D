extends Node

# ARRAY TO STORE INFO ABOUT PORTALS
var PortalContainer = []
const TILE_SIZE = 8

signal add_message(aMessage)

func add_message(aMessage):
	emit_signal("add_message",aMessage)
	
func _ready():
	#SET THE SIZE OF PORTALCONTAINTER ARRAY TO TWO ELEMENTS (0 AND 1). BOTH ARE NULL AT THIS MOMENT.
	PortalContainer.resize(2)


#FUNCTION FOR DELETING PORTALS
func deletePortals():
	if PortalContainer[0] != null:
		PortalContainer[0].queue_free()
		PortalContainer[0] = null
		
	if PortalContainer[1] != null:
		PortalContainer[1].queue_free()
		PortalContainer[1] = null


