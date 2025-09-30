class_name NavigationManager
extends Node3D

var navigation_region: NavigationRegion3D
var navigation_mesh: NavigationMesh


func _ready():
	_setup_navigation()


func _setup_navigation():
	navigation_region = NavigationRegion3D.new()
	add_child(navigation_region)
	
	navigation_mesh = NavigationMesh.new()
	navigation_mesh.geometry_parsed_geometry_type = NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS
	navigation_mesh.cell_size = 0.5
	navigation_mesh.agent_max_slope = 5

	var nav_map = navigation_region.get_navigation_map()
	NavigationServer3D.map_set_cell_size(nav_map, navigation_mesh.cell_size)

	navigation_region.navigation_mesh = navigation_mesh
	
	bake_navigation_async()


func on_building_changed():
	bake_navigation_async()


func bake_navigation_async():
	if navigation_region and navigation_mesh:
		var source_geometry = NavigationMeshSourceGeometryData3D.new()
		NavigationServer3D.parse_source_geometry_data(
			navigation_mesh,
			source_geometry,
			get_tree().root
		)

		NavigationServer3D.bake_from_source_geometry_data_async(
			navigation_mesh,
			source_geometry
		)
		print("Async navigation mesh baked")


func get_navigatoion_path(start: Vector3, end: Vector3) -> PackedVector3Array:
	return NavigationServer3D.map_get_path(
		navigation_region.get_navigation_map(),
		start,
		end,
		true
	)
