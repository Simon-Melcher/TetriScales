extends Node

@onready var main_scene: Node2D = $".."


func cube_obj(origin: Vector3, vertex_offset := 0, size := Vector3(1, 1, 1), rotation_degrees := Vector3.ZERO) -> String:
	# size.x = length, size.y = width, size.z = height

	# Half-sizes so we can center the box at (0,0,0) before rotation
	var hx = size.x / 2.0
	var hy = size.y / 2.0
	var hz = size.z / 2.0

	# Vertices centered around origin
	var v = [
		Vector3(-hx, -hy, -hz),
		Vector3( hx, -hy, -hz),
		Vector3( hx,  hy, -hz),
		Vector3(-hx,  hy, -hz),
		Vector3(-hx, -hy,  hz),
		Vector3( hx, -hy,  hz),
		Vector3( hx,  hy,  hz),
		Vector3(-hx,  hy,  hz),
	]

	# Build rotation basis
	var rotation_basis = Basis().rotated(Vector3.RIGHT, deg_to_rad(rotation_degrees.x))
	rotation_basis = rotation_basis.rotated(Vector3.UP, deg_to_rad(rotation_degrees.y))
	rotation_basis = rotation_basis.rotated(Vector3.FORWARD, deg_to_rad(rotation_degrees.z))

	# Apply rotation and then move to final origin
	for i in range(v.size()):
		v[i] = rotation_basis * v[i] + origin

	var out = ""

	# Write vertices
	for vert in v:
		out += "v %f %f %f\n" % [vert.x, vert.y, vert.z]

	# Faces
	var faces = [
		[1, 2, 3, 4], # bottom
		[5, 6, 7, 8], # top
		[1, 5, 8, 4], # left
		[2, 6, 7, 3], # right
		[4, 3, 7, 8], # front
		[1, 2, 6, 5], # back
	]

	for f in faces:
		out += "f %d %d %d %d\n" % [
			f[0] + vertex_offset,
			f[1] + vertex_offset,
			f[2] + vertex_offset,
			f[3] + vertex_offset
		]

	return out
	
func write():
	
	var path = "user://tetriscales.obj"
	#var path = "C:/TEMP/two_cubes.obj"
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Could not open file for writing")
		return

	var obj_text = ""
	obj_text += "# TetriScales\n"

	# First cube at origin
	#obj_text += cube_obj(Vector3(0, 0, 0))

	# Second cube shifted in X by 3 units
	# Note: OBJ vertices are global, so we keep adding vertices in sequence
	#var vertex_offset = 8 # first cube has 8 vertices
	#obj_text += cube_obj(Vector3(3, 0, 0), vertex_offset)
	
	# Note: OBJ vertices are global, so we keep adding vertices in sequence
	var vertex_offset = 0 # first cube has 8 vertices

	var blocks = []
	for c in main_scene.get_children():
		if c is RigidBody2D and "friendly_name" in c:
			blocks.append(c)
	
	var s = 0.001
	
	# ground
	const offset_z = 64
	const block_z = 64
	var vs = get_viewport().size
	var pos : Vector3 = Vector3(0,0,0)
	var size : Vector3 = Vector3(vs.x * s, vs.y * s, offset_z * s)
	var rot_deg : Vector3 = Vector3.ZERO
	obj_text += cube_obj(pos, vertex_offset, size, rot_deg)
	vertex_offset += 8
	
	# base plate
	var base_plate = main_scene.get_node("Objects/Base_Plate")
	
	pos = Vector3(base_plate.position.x*s, base_plate.position.y*s, offset_z * s)
	var tex = base_plate.get_node("Sprite2D").texture
	size = Vector3(tex.get_width() * s, tex.get_height() * s, block_z * s)
	rot_deg = Vector3(0, 0, base_plate.rotation_degrees)
	obj_text += cube_obj(pos, vertex_offset, size, rot_deg)
	vertex_offset += 8
	
	
	for b in blocks:
		pos = Vector3(b.position.x, b.position.y, offset_z)
		print("pos: ", pos)
		#tex = b.get_node("Sprite2D").texture
		#		size = Vector3(tex.get_width(), tex.get_height(), block_z)
		if b.friendly_name == "Glitchy":
			size = Vector3(3*64, 1*64, block_z)
		elif b.friendly_name == "Block 1x1" or b.friendly_name == "Icy Block 1x1":
			size = Vector3(1*64, 1*64, block_z)
		elif b.friendly_name == "Block 3x1":
			size = Vector3(3*64, 1*64, block_z)
		elif b.friendly_name == "Block 2x2L":
			size = Vector3(2*64, 2*64, block_z)
		else:
			print("skipping unknown ", b.friendly_name)
		print("size: ", size)
		rot_deg = Vector3(0, 0, b.rotation_degrees)
		obj_text += cube_obj(pos * s, vertex_offset, size * s, rot_deg)
		vertex_offset += 8

	# Second cube: rotated 45° around Y axis
#	obj_text += cube_obj(Vector3(3, 0, 0), vertex_offset, Vector3(0, 45, 0))	

	file.store_string(obj_text)
	file.close()
	print("OBJ written to: ", path)
	var absolute_path = ProjectSettings.globalize_path(path)
	# Open with default application
	OS.shell_open(absolute_path)
