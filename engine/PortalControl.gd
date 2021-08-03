extends Node

var portals : Array = []

var base : PackedScene = load("res://scenes/portal/Portal.tscn")
const PORTAL_COLOR = [ Color(1, 0.694118, 0), Color(0, 0.4375, 1) ] # orange, blue
# portal type constants, for code clarity
const PORTAL_ORANGE = 0
const PORTAL_BLUE = 1

var orange_deployed : bool = false
var blue_deployed : bool = false

var enter_velocity : Vector2 = Vector2.ZERO
var exit_velocity : Vector2 = Vector2.ZERO

var enter_direction : Vector2 = Vector2.ZERO
var exit_direction : Vector2 = Vector2.ZERO


func _ready():
	portals.resize(2)
	if !get_node_or_null(NodePath("Portals")):
		var PortalParent = Node2D.new()
		PortalParent.name = "Portals"
		$"../World".call_deferred("add_child", PortalParent)


func add_portal(portal_id : int = 0, location : Vector2 = Vector2.ZERO, rotation : float = 0.0):
	print("adding portal ", portal_id)
	if !portals[portal_id]:
		portals[portal_id] = base.instance()
		portals[portal_id].type = portal_id
		portals[portal_id].color = PORTAL_COLOR[portal_id]
		portals[portal_id].position = location
		portals[portal_id].rotation = rotation
		portals[portal_id].spawn_position = portals[portal_id].get_node("Particles2D").get_global_position()


func delete_portal(portal_id):
	print("deleting portal ", portal_id)
	portals[portal_id].queue_free()
	portals[portal_id] = null


func deployPortals():
	if portals[0] != null and !orange_deployed:
		$"../World/Portals".add_child(portals[0])
#		owner.add_child(portals[0])
		orange_deployed = true
	if portals[1] != null and !blue_deployed:
		$"../World/Portals".add_child(portals[1])
#		owner.add_child(portals[1])
		blue_deployed = true	


#func place_portal(aPortalType):
#	if portals[aPortalType] == null:
#		var NewPortal = base.instance()
#		portals[aPortalType] = NewPortal
#		portals[aPortalType].type = aPortalType
#		portals[aPortalType].set_rotation_degrees(getPortalRotation($RayCast2D))
#		portals[aPortalType].position = getPortalPosition($RayCast2D, tilemap, coord.get_global_position(), tilemap.get_cell_size())
#
#	else:
#		portals[aPortalType].set_rotation_degrees(getPortalRotation($RayCast2D))
#		portals[aPortalType].position = getPortalPosition($RayCast2D, tilemap, coord.get_global_position(), tilemap.get_cell_size())
#		portals[aPortalType].spawn_position = portals[aPortalType].get_node("Particles2D").get_global_position()


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


#func getPortalPosition(aRayCast: RayCast2D, aTileMap: TileMap, aCoord: Vector2, aTileSize: Vector2):
#	#Returns Vector2/position of portal
#	# Arguments description:
#	# aRayCast - RayCast2D object of which normal is calculated
#	# aTileMap - TileMap object to use
#	# aCoord - coords of a tile/cell pointed by user. 
#	# aTileSize - size of a cell of aTileMap	
#
## TM 20210725 - simplified conditional statement
#	match aRayCast.get_collision_normal().normalized():
#		Vector2.DOWN:
#			return getTilePoints(aTileMap, aCoord, aTileSize)[2]
#		Vector2.LEFT:
#			return getTilePoints(aTileMap, aCoord, aTileSize)[0]
#		Vector2.UP:
#			return getTilePoints(aTileMap, aCoord, aTileSize)[1]
#		Vector2.RIGHT:
#			return getTilePoints(aTileMap, aCoord, aTileSize)[3]


# TM 20210802 - we should probably not delete portals,
#	but instead should remove them from the tree
#	so they can be reused; this will result in fewer
#	possible errors
func delete_all_portals():
	print("deleting ALL portals")
	for portal_to_delete in portals:
		portal_to_delete.queue_free()
		portal_to_delete = null
