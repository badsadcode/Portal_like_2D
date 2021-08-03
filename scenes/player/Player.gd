extends KinematicBody2D

#MOVEMENT CONSTANTS
const ACCELERATION = 1056
const MAX_SPEED = 72
const FRICTION = 0.125
const GRAVITY = Global.TILE_SIZE * 20
const AIR_RESISTANCE = 0.1#075
const JUMP_FORCE = 72

var motion = Vector2()

#HELPER VARIABLES VELOCITY
var max_velocity = 0.0
var current_velocity = 0.0

#PORTAL RELATED VARIABLES
var OrangeDeployed = false
var BlueDeployed = false
var exiting_portal = false

#HELPER VARIABLES 
onready var coord = $"../Coord"
onready var tilemap = $"../TileMap"
onready var laser_beam = $"Laser_Beam"
onready var laser_beam_particles = $"Laser_Beam/Laser_Beam_Particles"
var PortalObject = load("res://scenes/portal/Portal.tscn")

onready var body_torso = $"Body/Torso"
onready var body_head = $"Body/Head"
onready var body_legs = $"Body/Legs"
onready var body_arms = $"Body/Arms"
onready var hat = $"Body/Hat"

# let's not search for the raycast in _process(), for the same reason
onready var raycast = $"RayCast2D"

# portal type constants, for code clarity
const PORTAL_ORANGE = 0
const PORTAL_BLUE = 1

func set_player_colors():
	hat.texture = load(Playervars.current_player_colors["player_hat_model"])
	hat.set_modulate(Playervars.current_player_colors["player_hat_color"])
	var texture_width = hat.texture.get_width()
	var texture_height = hat.texture.get_height()		
	hat.centered = false	
	hat.set_offset(Vector2(-texture_width/2, -texture_height))	
	
	body_torso.set_modulate(Playervars.current_player_colors["player_torso_color"])
	body_legs.set_modulate(Playervars.current_player_colors["player_legs_color"])
	laser_beam.set_modulate(Playervars.current_player_colors["player_laser_beam_color"])
	laser_beam_particles.process_material.get_color_ramp().get_gradient().set_color(0,Playervars.current_player_colors["player_laser_glow_color"])
	
func _ready():	
	set_player_colors()


func set_sprite_direction():
	if self.position.x < get_viewport().get_mouse_position().x:
		$Body.scale.x  = 1
	else:
		$Body.scale.x  = -1


func _process(_delta):	
	set_sprite_direction()	
	
	#GUN RAYCAST
	raycast.cast_to = (get_viewport().get_mouse_position() - get_global_position()) * 300
	setTilePointer(coord, raycast, tilemap)
	PortalControl.deployPortals()

func calculate_particles_count(aLength):
	var particles_count = 0
	particles_count = aLength * 10
	return particles_count


func point_laser_beam():
	var cast_point = to_local(raycast.get_collision_point())
	laser_beam_particles.position = cast_point * 0.5 
	laser_beam_particles.rotation = (laser_beam.points[0] - cast_point).angle()
	laser_beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5
	# Code below causes particles emition to restart so it's not worth..
	# laser_beam_particles.amount = int(calculate_particles_count(cast_point.length()))
	
	laser_beam_particles.process_material.emission_box_extents.y = 0.1
	laser_beam.points[1] = cast_point


func get_max_velocity():
	current_velocity = max(abs(motion.x), abs(motion.y))
	if current_velocity >= max_velocity:
		max_velocity = current_velocity
	else:
		max_velocity=lerp(max_velocity, MAX_SPEED, FRICTION)



func _physics_process(delta):
	point_laser_beam()
	get_max_velocity()	
	handle_inputs(delta)
	var _moved_and_slid = move_and_slide(motion, Vector2.UP, false, 4, PI/4, false)
	

func play_animations(aAnimation: String):	
	body_head.play(aAnimation)
	body_arms.play(aAnimation)
	body_torso.play(aAnimation)
	body_legs.play(aAnimation)


func handle_inputs(aDelta):	
	if !exiting_portal:
		#APPLY GRAVITY
		if is_on_ceiling():
			print("touched ceiling, resetting vertical motion")
			motion.y = 0.01
		elif is_on_floor():
			print("touched floor, resetting vertical motion")
			motion.y = 0.01
		else:
			motion.y += GRAVITY * aDelta
		
		# get input
		var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
		
		# handle animation
		if x_input != 0:
			play_animations("run")
		else:		
			play_animations("stand")
		
		# apply movement
		if x_input != 0:
			if is_on_floor():
				motion.x += x_input * ACCELERATION * aDelta
			else:
				motion.x += x_input * (ACCELERATION * AIR_RESISTANCE) * aDelta
			motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		
		# apply friction with air or floor
		if is_on_floor():
			if x_input == 0:
				motion.x = lerp(motion.x, 0, FRICTION)
			if Input.is_action_just_pressed("jump"):
				motion.y = -JUMP_FORCE
		else:
			if x_input == 0:
				motion.x = lerp(motion.x, 0, AIR_RESISTANCE)
		
	#ORANGE PORTAL
	if Input.is_action_just_pressed("l_mouse"):
		#Check if orange portal is in PortalControl.portals[0]. If null create one and add to array
		if raycast.get_collider().name=="TileMap3":
			place_portal(PORTAL_ORANGE)
	
	# BLUE PORTAL
	if Input.is_action_just_pressed("r_mouse"):
		#Check if blue portal is in PortalControl.portals[0]. If null create one and add to array
		if raycast.get_collider().name=="TileMap3":
			place_portal(PORTAL_BLUE)
	
	#DELETE PORTALS
	if Input.is_action_just_pressed("m_mouse"):
		PortalControl.delete_all_portals()
		OrangeDeployed = false
		BlueDeployed = false


func place_portal(aPortalType):
	if PortalControl.portals[aPortalType] == null:
		var NewPortal = PortalObject.instance()
		PortalControl.portals[aPortalType] = NewPortal
		PortalControl.portals[aPortalType].type = aPortalType
		PortalControl.portals[aPortalType].set_rotation_degrees(getPortalRotation($RayCast2D))
		PortalControl.portals[aPortalType].position = getPortalPosition($RayCast2D, tilemap, coord.get_global_position(), tilemap.get_cell_size())
	
	else:
		PortalControl.portals[aPortalType].set_rotation_degrees(getPortalRotation($RayCast2D))
		PortalControl.portals[aPortalType].position = getPortalPosition($RayCast2D, tilemap, coord.get_global_position(), tilemap.get_cell_size())
		PortalControl.portals[aPortalType].spawn_position = PortalControl.portals[aPortalType].get_node("Particles2D").get_global_position()


func getPortalRotation(aRayCast : RayCast2D):
	# Returns portal rotation value in degrees (-90, 0, 90, 180)
	# Arguments description:
	# aRayCast - RayCast2D object of which normal is calculated
	
	match aRayCast.get_collision_normal().normalized() as Vector2:
		Vector2.DOWN:
			return 0
		Vector2.LEFT:
			return 90
		Vector2.UP:
			return 180
		Vector2.RIGHT:
			return -90


func getPortalPosition(aRayCast: RayCast2D, aTileMap: TileMap, aCoord: Vector2, aTileSize: Vector2):
	#Returns Vector2/position of portal
	# Arguments description:
	# aRayCast - RayCast2D object of which normal is calculated
	# aTileMap - TileMap object to use
	# aCoord - coords of a tile/cell pointed by user.
	# aTileSize - size of a cell of aTileMap
	
	match aRayCast.get_collision_normal().normalized():
		Vector2.DOWN:
			return getTilePoints(aTileMap, aCoord, aTileSize)[2]
		Vector2.LEFT:
			return getTilePoints(aTileMap, aCoord, aTileSize)[0]
		Vector2.UP:
			return getTilePoints(aTileMap, aCoord, aTileSize)[1]
		Vector2.RIGHT:
			return getTilePoints(aTileMap, aCoord, aTileSize)[3]


func getTilePoints(aTileMap: TileMap, aCoord: Vector2, aTileSize: Vector2):
	# Returns array of vector2() for position of each tile corner and a center of a tile
	# Arguments description:
	# aTileMap - TileMap object to use
	# aCoord - coords of a tile/cell pointed by user. 
	# aTileSize - size of a cell of aTileMap
	var tile = aTileMap.world_to_map(aCoord)
	#Converts aCoord to index of aTile
	var topLeft = tile*aTileSize
	var topRight = Vector2(tile.x * aTileSize.x + aTileSize.x, tile.y * aTileSize.y)
	var bottomLeft = Vector2(tile.x * aTileSize.x, tile.y * aTileSize.y + aTileSize.y)
	var bottomRight = Vector2(tile.x * aTileSize.x + aTileSize.x, tile.y * aTileSize.y + aTileSize.y)	
	var center = topLeft + aTileMap.get_cell_size() / 2
	
	return [topLeft, topRight, bottomLeft, bottomRight, center]


func setTilePointer(aObject: Node2D, aRayCast: RayCast2D, aTileMap: TileMap):
	#Sets aObject(Node2D) inside a Tile of a aTileMap(TileMap) which was hit by aRayCast (RayCast2D)
	aObject.set_global_position(aRayCast.get_collision_point() + (aTileMap.get_cell_size() / 2) * - aRayCast.get_collision_normal())


func deployPortals():
	if PortalControl.portals[0] != null and !OrangeDeployed:
		owner.add_child(PortalControl.portals[0])
		OrangeDeployed = true
	if PortalControl.portals[1] != null and !BlueDeployed:
		owner.add_child(PortalControl.portals[1])
		BlueDeployed = true	


func update_appearance():
	Playervars.update_appearance()


func _on_Portal_Exit_Timer_timeout():
	exiting_portal = false
	print("Portal Exit Timer timed out")


func activate_portal_timer():
	var _timer = $"Portal Exit Timer"
	if !_timer.is_stopped():
		_timer.stop()
		print("Stopped Portal Exit Timer because it was still running")
	_timer.start()
	print("Started Portal Exit Timer")
