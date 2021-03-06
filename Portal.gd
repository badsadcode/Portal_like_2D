extends Node2D

onready var debug_window = $"../DebugWindow/VBoxContainer/console"
onready var debug_window1 = $"../DebugWindow/VBoxContainer/better_console"

var type #TYPE OF PORTAL. DEPENDING ON VALUE (0 AND 1) THE COLOR IS SET
var spawn_position #POSITION WHERE OBJECTS WILL SPAWN WHEN EXITING THE PORTAL
var exit_speed = 0.0
var last_exit_speed = 0.0
var enters_count = 0
const FORCE_MULTIPLIER = 1.75
const FORCE_MULTIPLIER_Y = 0.75

# TM 20210725 - added for code clarity and ease of use
const COLOR_PORTAL_0 : Color = Color(1, 0.694118, 0)	# orange portal
const COLOR_PORTAL_1 : Color = Color(0, 0.4375, 1)		# blue portal

func add_message(aMessage: String):
	debug_window.add_text(aMessage+"\n")	
	#debug_window1.insert_text_at_cursor(aMessage+"\n")	

func _ready():
	Global.connect("add_message",self,"add_message")
	#SET spawn_position variable TO POSITION OF PARTICLES2D NODE OF THE PORTAL
	spawn_position = $Particles2D.get_global_position()
	#SETTING COLOR DEPENDING ON THE type VARIABLE
	if type != null:
		setColor(type)


func _on_Area2D_body_entered(body):
	#IF OBJECT THAT ENTERED PORTAL IS NOT A TILEMAP (NO TileMap STRING IN THE NAME OF OBJECT
	if !("TileMap" in body.name):
		exit_speed = body.max_velocity
		enters_count += 1
		print("_on_Area2D_body_entered(): exit_speed = ", exit_speed)

		#CHECK IF PLAYER(OR OBJECT) IS EXITING THE PORTAL OR ENTERING IT
		if not body.exiting_portal:
			#WE NEED TO CHECK IF BOTH PORTALS ARE PRESENT IN THE GAME
			if Global.PortalContainer[0] and Global.PortalContainer[1]:
				#DECISION WHERE TO PUT OBJECT (SET ITS POSITION TO THE OTHER PORTAL SPAWN POINT)
				print ("Entered portal type: ", self.type)
				body.exiting_portal = true
				body.set_global_position(Global.PortalContainer[abs(type - 1)].spawn_position)


func _on_Area2D_body_exited(body):
	if !("TileMap" in body.name):	
		#IF OBJECT EXITED PORTALS AREA2D IT'S NOT IN STATE exiting_portal ANYMORE
		body.exiting_portal = false		
		#IF SELF TYPE == 0 THEN WE NEED TO CHANGE SOME PROPERTIES OF THE OTHER PORTAL (THE ONE WITH TYPE 1)
		#THIS IS MOST PROBLEMATIC FOR ME. I FOUND THAT THESE RULES WORKS QUITE WELL, BUT THEY SHOULD BE CHANGED
		
		# check the exit_direction of the other portal:
		
		if Global.PortalContainer[0] != null and Global.PortalContainer[1] !=null:
			match getPortalExitDirection(Global.PortalContainer[abs(type - 1)]):
				8:
					print("entrance up: halting horizontal motion, vertical motion is unaffected")
					body.motion.x = 0
					body.motion.y = 0 #PREVENTS PLAYER BEING THROWN AGAIN INTO PORTAL WHICH HE'S EXITING
				6:
					print("entrance right: setting horizontal motion to the higher of ", exit_speed, " or ", body.MAX_SPEED, " and reversing it")
					print("                halting vertical motion")
					body.motion.x = -max(exit_speed * FORCE_MULTIPLIER, body.MAX_SPEED)
					body.motion.y = 0
				2:
					print("entrance down: halting horizontal motion, flipping and clamping vertical motion to higher of ", exit_speed, " or 150 (not 64?)")
					#Global.add_message(str("Portal 0 exit_speed:[",Global.PortalContainer[0].exit_speed,"] Portal 1 exit_speed: [",Global.PortalContainer[1].exit_speed,"]"))
					Global.add_message(str(self.type,"<- type || exit speed-->",exit_speed * FORCE_MULTIPLIER_Y))
					body.motion.x = 0		
					# THERE IS SOMETHING WRONG WITH NEXT LINE. NOW IT WORKS OK BUT WITH PREVIOUS VERSIO
					# WHERE  SECOND PARAMETER FOR CLAMP WAS exit_speed DOUBLE TELEPORTATION HAPPEND OCCASIONALLY
					# TODO: FIND BEST MOVEMENT PARAMETERS
					body.motion.y = -clamp(exit_speed * FORCE_MULTIPLIER_Y,body.MAX_SPEED,150)
				4:
					print("entrance left: horizontal motion is exit_speed or 64, halting vertical motion")
					body.motion.x = max(exit_speed * FORCE_MULTIPLIER, body.MAX_SPEED)
					body.motion.y = 0

#		if self.type == 0:
#			if Global.PortalContainer[1] != null:
#				if getPortalExitDirection(Global.PortalContainer[1]) == 8:
#					body.motion.x = 0
#				if getPortalExitDirection(Global.PortalContainer[1]) == 6:
#					body.motion.x = -(max(exit_speed * FORCE_MULTIPLIER,64))
#					body.motion.y = 0
#				if getPortalExitDirection(Global.PortalContainer[1]) == 2:
#					body.motion.x = 0	
#					Global.add_message(str("Portal 0 enters_count:[",Global.PortalContainer[0].enters_count,"] Portal 1 enters_count: [",Global.PortalContainer[1].enters_count,"]"))
#					body.motion.y = -(clamp(exit_speed * FORCE_MULTIPLIER_Y,exit_speed,150))
#				if getPortalExitDirection(Global.PortalContainer[1]) == 4:
#					body.motion.x = (max(exit_speed * FORCE_MULTIPLIER,64))
#					body.motion.y = 0
#		#OPPOSITE SITUATION (IF SELF.TYPE == 1 THEN CHANGE PROPERTIES OF THE OTHER PORTAL WITH TYPE 0)
#		if self.type == 1:
#			if Global.PortalContainer[0] != null:
#				if getPortalExitDirection(Global.PortalContainer[0]) == 8:
#					body.motion.x = 0
#				if getPortalExitDirection(Global.PortalContainer[0]) == 6:
#					body.motion.y = 0
#					body.motion.x = -(max(exit_speed * FORCE_MULTIPLIER,64))
#				if getPortalExitDirection(Global.PortalContainer[0]) == 2:
#					body.motion.x = 0	
#					body.motion.y = -(clamp(exit_speed * FORCE_MULTIPLIER_Y,exit_speed,150))
#				if getPortalExitDirection(Global.PortalContainer[0]) == 4:
#					body.motion.y = 0
#					body.motion.x = (max(exit_speed * FORCE_MULTIPLIER,64))


func setColor(aType):
	# TM20210705 - magic numbers? these colors should be specified in constants
	if aType == 0:
		$Sprite.set_self_modulate(COLOR_PORTAL_0)
		$Light2D.color = COLOR_PORTAL_0
	elif aType == 1:
		$Sprite.set_self_modulate(COLOR_PORTAL_1)
		$Light2D.color = COLOR_PORTAL_1


func getPortalExitDirection(aPortal: Node2D):
	match int(aPortal.get_rotation_degrees()):
		0:
			print("exit is below portal ", aPortal.type)
			return 8
		90:
			print("exit is left of portal ", aPortal.type)
			return 6
		180:
			print("exit is above portal ", aPortal.type)
			return 2
		-90:
			print("exit is right of portal ", aPortal.type)
			return 4

func _process(delta):
	if Input.is_action_just_pressed("reset_enters"):
		self.enters_count = 0
		debug_window.clear()
