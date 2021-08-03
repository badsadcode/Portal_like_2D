extends Node2D

var type #TYPE OF PORTAL. DEPENDING ON VALUE (0 AND 1) THE COLOR IS SET
var color : Color = Color.white
var spawn_position #POSITION WHERE OBJECTS WILL SPAWN WHEN EXITING THE PORTAL
var exit_speed : float = 0.0
var enters_count = 0


func _ready():
	#SET spawn_position variable TO POSITION OF PARTICLES2D NODE OF THE PORTAL
	set_spawn()
	#SETTING COLOR DEPENDING ON THE type VARIABLE
	set_color(type)


# detect player entry
func _on_Area2D_body_entered(body):
	print("Detected ", body.name, " entering portal Area2D")
	#IF OBJECT THAT ENTERED PORTAL IS NOT A TILEMAP (NO TileMap STRING IN THE NAME OF OBJECT
#	if !("TileMap" in body.name):
	if !(body is TileMap): # faster than string comparison
#		exit_speed = body.max_velocity
		
		# "speedy thing goes in, speedy thing comes out"
		match get_portal_facing():
			Vector2.LEFT, Vector2.RIGHT:
				exit_speed = abs(body.motion.x)
			Vector2.UP, Vector2.DOWN:
				exit_speed = abs(body.motion.y)
			_: # default/unmatched
				assert(false, str("Portal.gd: _on_Area2D_body_exited(", body.name, "): ",
					 "ORANGE" if type == 0 else "BLUE" if type == 1 else "UNKNOWN", " portal faces ",
					 "LEFT" if get_portal_facing() == Vector2.LEFT else "RIGHT" if get_portal_facing() == Vector2.RIGHT else "UP" if get_portal_facing() == Vector2.UP else "DOWN"
					))
		print("ORANGE" if type == 0 else "BLUE" if type == 1 else "UNKNOWN", " portal: _on_Area2D_body_entered(", body.name, "): exit_speed = ", exit_speed)
		print("ORANGE" if type == 0 else "BLUE" if type == 1 else "UNKNOWN", " portal: _on_Area2D_body_entered(", body.name, "): entrance_vector = ", body.motion)

		enters_count += 1
		
		#CHECK IF PLAYER(OR OBJECT) IS EXITING THE PORTAL OR ENTERING IT
		if not body.exiting_portal:
			# CHECK IF BOTH PORTALS ARE PRESENT IN THE GAME
			if PortalControl.portals[0] != null and PortalControl.portals[1] != null:
				# check the facing of the exit portal:
				# modify entrance velocity to match exit direction
				# then we get the output direction...
				match PortalControl.portals[abs(type - 1)].get_portal_facing():
					Vector2.UP:
						body.motion = Vector2(0, -exit_speed)
					Vector2.DOWN:
						body.motion = Vector2(0, exit_speed)
					Vector2.LEFT:
						body.motion = Vector2(-exit_speed, 0)
					Vector2.RIGHT:
						body.motion = Vector2(exit_speed, 0)
				# ...and finally, we spit the player out in that direction
				#DECISION WHERE TO PUT OBJECT (SET ITS POSITION TO THE OTHER PORTAL SPAWN POINT)
				body.exiting_portal = true
				body.set_global_position(PortalControl.portals[abs(type - 1)].spawn_position)


# detect player exit
func _on_Area2D_body_exited(body):
#	if !("TileMap" in body.name):
	if !(body is TileMap):
		#IF OBJECT EXITED PORTALS AREA2D IT'S NOT IN exiting portal STATE ANYMORE
		if body.exiting_portal:
			body.activate_portal_timer() # this seems to be the best solution for not hitting the floor through the portal
#			body.exiting_portal = false		
			#IF SELF TYPE == 0 THEN WE NEED TO CHANGE SOME PROPERTIES OF THE OTHER PORTAL (THE ONE WITH TYPE 1)
			#THIS IS MOST PROBLEMATIC FOR ME. I FOUND THAT THESE RULES WORKS QUITE WELL, BUT THEY SHOULD BE CHANGED
			print("ORANGE" if type == 0 else "BLUE" if type == 1 else "UNKNOWN", " portal: _on_Area2D_body_exited(", body.name, "): exit_speed = ", exit_speed)
			print("ORANGE" if type == 0 else "BLUE" if type == 1 else "UNKNOWN", " portal: _on_Area2D_body_exited(", body.name, "): exit_vector = ", body.motion)
		else:
			print("ORANGE" if type == 0 else "BLUE" if type == 1 else "UNKNOWN", " portal: _on_Area2D_body_exited(", body.name, "): exiting_portal was false!")



func set_color(which_portal):
	color = PortalControl.PORTAL_COLOR[which_portal]
	$Sprite.set_modulate(color)
	$Particles2D.set_modulate(color)
	$Light2D.color = color


func set_spawn():
	spawn_position = $Particles2D.get_global_position()


func getPortalExitDirection(aPortal: Node2D):
	# why are we essentially returning portal.rotation_degrees as some proprietary direction indicator?
	# this should be called "dude, where's my spawn?"
	match int(aPortal.get_rotation_degrees()):
		0:
			print("exit is below ", "ORANGE" if aPortal.type == 0 else "BLUE" if aPortal.type == 1 else "UNKNOWN" , " portal ")
			return Vector2.UP
		90:
			print("exit is left of ", "ORANGE" if aPortal.type == 0 else "BLUE" if aPortal.type == 1 else "UNKNOWN" , " portal ", aPortal.type)
			return Vector2.RIGHT
		180:
			print("exit is above ", "ORANGE" if aPortal.type == 0 else "BLUE" if aPortal.type == 1 else "UNKNOWN" , " portal ", aPortal.type)
			return Vector2.DOWN
		-90:
			print("exit is right of ", "ORANGE" if aPortal.type == 0 else "BLUE" if aPortal.type == 1 else "UNKNOWN" , " portal ", aPortal.type)
			return Vector2.LEFT


func get_portal_facing() -> Vector2:
#	print("Portal ", type, " rotation: ", rotation_degrees, " degrees")
	match int(rotation_degrees):
		0: # portal faces down
			print("ORANGE" if type == 0 else "BLUE" if type == 1 else "UNKNOWN", " portal faces down")
			return Vector2.DOWN
		90: # portal faces left
			print("ORANGE" if type == 0 else "BLUE" if type == 1 else "UNKNOWN", " portal faces left")
			return Vector2.LEFT
		180: # portal faces up
			print("ORANGE" if type == 0 else "BLUE" if type == 1 else "UNKNOWN", " portal faces up")
			return Vector2.UP
		-90: # portal faces right
			print("ORANGE" if type == 0 else "BLUE" if type == 1 else "UNKNOWN", " portal faces right")
			return Vector2.RIGHT
		_:
			print("Portal.gd: get_portal_facing: FAILED for ", "ORANGE" if type == 0 else "BLUE" if type == 1 else "UNKNOWN", " portal, rotation_degrees = ", rotation_degrees)
			return Vector2.ZERO
