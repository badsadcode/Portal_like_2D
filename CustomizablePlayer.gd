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
var PortalObject = load("res://Portal.tscn")

onready var body_torso = $"Body/Torso"
onready var body_head = $"Body/Head"
onready var body_legs = $"Body/Legs"
onready var body_arms = $"Body/Arms"

# let's not search for the raycast in _process(), for the same reason
onready var raycast = $"RayCast2D"


# portal type constants, for code clarity
const PORTAL_ORANGE = 0
const PORTAL_BLUE = 1
func _ready():
	set_colors()

func set_sprite_direction():
# TM 20210725 - optimized conditional statement
	body_head.flip_h = position.x > get_viewport().get_mouse_position().x
	body_torso.flip_h = position.x > get_viewport().get_mouse_position().x
	body_arms.flip_h = position.x > get_viewport().get_mouse_position().x
	body_legs.flip_h = position.x > get_viewport().get_mouse_position().x

func set_colors():
	body_torso.set_modulate(Playervars.player_torso_color)
	body_head.set_modulate(Playervars.player_skin_color)
	body_arms.set_modulate(Playervars.player_skin_color)
	body_legs.set_modulate(Playervars.player_legs_color)

func _process(delta):
	set_colors()
	update()
	
	set_sprite_direction()
	#display_info()
	
	#GUN RAYCAST
	raycast.cast_to = (get_viewport().get_mouse_position() - get_global_position()) * 300
	setTilePointer(coord, raycast, tilemap)
	deployPortals()


func _draw():
	#Draw line showing where player is pointing his portal gun
# TM 20210725 - named colors for code clarity
	var laser_glow_color : = Color(1.0, 0, 0, 1)
	var laser_beam_color : = Color(1.4, 0.60, 0, 1)
	draw_line(Vector2(0,0), raycast.get_collision_point() - get_global_position(), laser_glow_color, 1.25, true)
	draw_line(Vector2(0,0), raycast.get_collision_point() - get_global_position(), laser_beam_color, 1.0, true)


func get_max_velocity():
	current_velocity = max(abs(motion.x), abs(motion.y))
	if current_velocity >= max_velocity:
		max_velocity = current_velocity
	else:
		max_velocity=lerp(max_velocity, MAX_SPEED, FRICTION)
	
			


func _physics_process(delta):
	get_max_velocity()
	handle_inputs(delta)
	motion = move_and_slide(motion, Vector2.UP, false, 4, PI/4, false)

func play_animations(aAnimation: String):
	
	body_head.play(aAnimation)
	body_arms.play(aAnimation)
	body_torso.play(aAnimation)
	body_legs.play(aAnimation)

func handle_inputs(aDelta):	
	#APPLY GRAVITY
	motion.y += GRAVITY  * aDelta
	play_animations("run")
	
	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")	
	if x_input != 0:
		play_animations("run")
		if is_on_floor():
			motion.x += x_input * ACCELERATION * aDelta
		else:
			motion.x += x_input * (ACCELERATION * AIR_RESISTANCE) * aDelta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	else:		
		play_animations("stand")


	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)
		if Input.is_action_pressed("jump"):
			motion.y = -JUMP_FORCE
	else:
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE)
	
	#ORANGE PORTAL
	if Input.is_action_just_pressed("l_mouse"):
		#Check if orange portal is in Global.PortalContainer[0]. If null create one and add to array
		if raycast.get_collider().name=="TileMap3":
			place_portal(PORTAL_ORANGE)

	# BLU PORTAL
	if Input.is_action_just_pressed("r_mouse"):
		#Check if blue portal is in Global.PortalContainer[0]. If null create one and add to array
		if raycast.get_collider().name=="TileMap3":
			place_portal(PORTAL_BLUE)
		
	#DELETE PORTALS
	if Input.is_action_just_pressed("m_mouse"):
		Global.deletePortals()
		OrangeDeployed = false
		BlueDeployed = false


func place_portal(aPortalType):
	if Global.PortalContainer[aPortalType] == null:
		var NewPortal = PortalObject.instance()		
		Global.PortalContainer[aPortalType] = NewPortal		
		Global.PortalContainer[aPortalType].type = aPortalType			
		Global.PortalContainer[aPortalType].set_rotation_degrees(getPortalRotation($RayCast2D))
		Global.PortalContainer[aPortalType].position = getPortalPosition($RayCast2D, tilemap, coord.get_global_position(), tilemap.get_cell_size())			
		
	else:
		Global.PortalContainer[aPortalType].set_rotation_degrees(getPortalRotation($RayCast2D))			
		Global.PortalContainer[aPortalType].position = getPortalPosition($RayCast2D, tilemap, coord.get_global_position(), tilemap.get_cell_size())
		Global.PortalContainer[aPortalType].spawn_position = Global.PortalContainer[aPortalType].get_node("Particles2D").get_global_position()	


func getPortalRotation(aRayCast : RayCast2D):
	# Returns portal rotation value in degrees (-90, 0, 90, 180)
	# Arguments description:
	# aRayCast - RayCast2D object of which normal is calculated
	
# TM 20210725 - simplified conditional statement
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

# TM 20210725 - simplified conditional statement
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
	if Global.PortalContainer[0] != null and !OrangeDeployed:
		owner.add_child(Global.PortalContainer[0])
		OrangeDeployed = true
	if Global.PortalContainer[1] != null and !BlueDeployed:
		owner.add_child(Global.PortalContainer[1])
		BlueDeployed = true	


func display_info():
	$"../Label4".text = "SPEED:"+ str(motion) + "\nMAX VELOCITY -> [X]:" + str(abs(max_velocity.x)) +"[Y]: "+ str(abs(max_velocity.y))
#	if Global.PortalContainer[0] and Global.PortalContainer[1]:
#		$"../Label3".text = str("Portal positions: ", Global.PortalContainer[0].position, ", ", Global.PortalContainer[1].position)
#	else:
#		$"../Label3".text = ""
