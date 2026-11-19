class_name Terrain
extends RefCounted
## The arena's ground: high ground, low ground, cliffs, ramps and moats, laid
## out like the reference map's macro structure with its own shapes —
##   • high ground: three overlapping round hills along the centre lane (+1.5),
##     reached by four ramps (west, east, north, south);
##   • low ground: a sunken basin at the south centre (−1.2) where the boss
##     chains wait, and a pit at the north centre where the win boss waits,
##     each reached by two ramps from the field;
##   • moats: water channels on both sides of each base, open toward the field.
## Cliff edges carry invisible walls (except at ramps); deep water blocks too.
## Heights are a pure function of position, so every device agrees and units
## simply snap to it. Attacks from low ground up a cliff miss 25% of the time
## (Warcraft III's high-ground rule).

const HIGH := 1.5
const LOW := -1.2
const MOAT := -0.6
## Plateau hills: [centre x, centre z, radius].
const HILLS := [[-10.0, 2.0, 6.5], [0.0, 2.0, 6.5], [10.0, 2.0, 6.5]]
## Low basins: x from, x to, z from, z to. Each runs into the field's wall:
## the boss basin to the south, the win boss's pit to the north.
const BASINS := [[-13.0, 13.0, 15.0, 28.5], [-9.0, 9.0, -28.5, -17.0]]
## Ramps: [edge point x, z, outward direction x, z, width, length, height].
const RAMPS := [
	[-16.5, 2.0, -1.0, 0.0, 4.5, 3.5, HIGH], [16.5, 2.0, 1.0, 0.0, 4.5, 3.5, HIGH],
	[0.0, -4.5, 0.0, -1.0, 4.5, 3.5, HIGH], [0.0, 8.5, 0.0, 1.0, 4.5, 3.5, HIGH],
	[-7.5, 15.0, 0.0, -1.0, 4.0, 3.5, LOW], [7.5, 15.0, 0.0, -1.0, 4.0, 3.5, LOW],
	[-4.5, -17.0, 0.0, 1.0, 4.0, 3.5, LOW], [4.5, -17.0, 0.0, 1.0, 4.0, 3.5, LOW],
]
## Moats: [x from, x to, z from, z to] — two per base, either side of it.
const MOATS := [[-44.5, -34.5, -10.0, -8.0], [-44.5, -34.5, 8.0, 10.0], [34.5, 44.5, -10.0, -8.0], [34.5, 44.5, 8.0, 10.0]]
## The terrain mesh covers the field (the land beyond it is flat).
const EXTENT := Vector2(45.0, 29.5)
const STEP := 0.5
## The ground mesh works in blocks of this many cells a side (2 × 2 m).
const BLOCK := 4
const UPHILL_MISS := 0.25


static func height_at(at: Vector3) -> float:
	for ramp in RAMPS:
		var h := _ramp_height(ramp, at)
		if not is_nan(h):
			return h
	if _in_basin(at):
		return LOW
	if on_hills(at):
		return HIGH
	for moat in MOATS:
		if at.x >= moat[0] and at.x <= moat[1] and at.z >= moat[2] and at.z <= moat[3]:
			return MOAT
	return 0.0


static func on_hills(at: Vector3) -> bool:
	for hill in HILLS:
		if Vector2(at.x - hill[0], at.z - hill[1]).length() <= hill[2]:
			return true
	return false


static func _in_basin(at: Vector3) -> bool:
	for b in BASINS:
		if at.x >= b[0] and at.x <= b[1] and at.z >= b[2] and at.z <= b[3]:
			return true
	return false


## Height on a ramp (NAN when `at` isn't on it): full height at its edge,
## falling to 0 over its length.
static func _ramp_height(ramp: Array, at: Vector3) -> float:
	var out := Vector2(ramp[2], ramp[3])
	var side := Vector2(-out.y, out.x)
	var rel := Vector2(at.x - ramp[0], at.z - ramp[1])
	var u := rel.dot(out)
	var v := rel.dot(side)
	if u < -1.0 or u > ramp[5] or absf(v) > ramp[4] / 2.0:
		return NAN
	return ramp[6] * clampf(1.0 - u / ramp[5], 0.0, 1.0)


static func _near_ramp(at: Vector3, margin: float) -> bool:
	for ramp in RAMPS:
		var out := Vector2(ramp[2], ramp[3])
		var rel := Vector2(at.x - ramp[0], at.z - ramp[1])
		var u := rel.dot(out)
		var v := rel.dot(Vector2(-out.y, out.x))
		if u >= -1.6 and u <= 1.2 and absf(v) <= ramp[4] / 2.0 + margin:
			return true
	return false


## Warcraft III's high-ground rule: shooting up a cliff misses a quarter of the time.
static func uphill(from: Vector3, to: Vector3) -> bool:
	return height_at(to) > height_at(from) + 0.75


# ------------------------------------------------------------------ building
static func build(parent: Node3D) -> void:
	parent.add_child(_mesh())
	_walls(parent)
	_water(parent)


## One mesh for the whole field: grass, a dirt lane, lighter high ground, dark
## low ground, rock on the cliff faces. Vertex colours, one draw call.
## Blocks with slopes, cliff edges or colour changes keep the fine 0.5 grid;
## flat blocks of one colour are a single quad, or a small fan where they meet
## a fine block. Triangles stay compact: phone GPUs bin each triangle into every
## screen tile its bounding box touches, so long thin ones cost far more than
## their count suggests.
static func _mesh() -> MeshInstance3D:
	var mesh := MeshInstance3D.new()
	mesh.name = "Terrain"
	mesh.mesh = build_mesh()
	mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var material := Toon.material(Color.WHITE, 0.0)
	material.vertex_color_use_as_albedo = true
	material.vertex_color_is_srgb = true
	mesh.material_override = material
	return mesh


static func build_mesh() -> ArrayMesh:
	var cols := int(EXTENT.x * 2.0 / STEP) + 1
	var rows := int(EXTENT.y * 2.0 / STEP) + 1
	var heights := PackedFloat32Array()
	heights.resize(cols * rows)
	for r in rows:
		for c in cols:
			heights[r * cols + c] = _smooth_height(Vector3(-EXTENT.x + c * STEP, 0, -EXTENT.y + r * STEP))
	# Each cell's colour, and whether all four corners sit at one height.
	var cells_x := cols - 1
	var cells_z := rows - 1
	var colors: Array[Color] = []
	var flat := PackedByteArray()
	colors.resize(cells_x * cells_z)
	flat.resize(cells_x * cells_z)
	for r in cells_z:
		for c in cells_x:
			var h00 := heights[r * cols + c]
			var h10 := heights[r * cols + c + 1]
			var h11 := heights[(r + 1) * cols + c + 1]
			var h01 := heights[(r + 1) * cols + c]
			var low := minf(minf(h00, h10), minf(h11, h01))
			var high := maxf(maxf(h00, h10), maxf(h11, h01))
			var centre := Vector3(-EXTENT.x + (c + 0.5) * STEP, (h00 + h11) / 2.0, -EXTENT.y + (r + 0.5) * STEP)
			colors[r * cells_x + c] = _ground_color(centre, high - low)
			flat[r * cells_x + c] = 1 if high - low < 0.0001 else 0
	# Blocks of BLOCK × BLOCK cells: "coarse" when every cell is flat, one
	# colour and one height.
	var blocks_x := ceili(float(cells_x) / BLOCK)
	var blocks_z := ceili(float(cells_z) / BLOCK)
	var coarse := PackedByteArray()
	coarse.resize(blocks_x * blocks_z)
	for bz in blocks_z:
		for bx in blocks_x:
			var c0 := bx * BLOCK
			var r0 := bz * BLOCK
			var first := r0 * cells_x + c0
			var same := true
			for r in range(r0, mini(r0 + BLOCK, cells_z)):
				for c in range(c0, mini(c0 + BLOCK, cells_x)):
					var i := r * cells_x + c
					if not flat[i] or colors[i] != colors[first] or absf(heights[r * cols + c] - heights[r0 * cols + c0]) > 0.0001:
						same = false
						break
				if not same:
					break
			coarse[bz * blocks_x + bx] = 1 if same else 0
	var tool := SurfaceTool.new()
	tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for bz in blocks_z:
		for bx in blocks_x:
			var c0 := bx * BLOCK
			var r0 := bz * BLOCK
			var w := mini(BLOCK, cells_x - c0)
			var d := mini(BLOCK, cells_z - r0)
			if not coarse[bz * blocks_x + bx]:
				for r in range(r0, r0 + d):
					for c in range(c0, c0 + w):
						_block(tool, heights, cols, c, r, 1, 1, [false, false, false, false], colors[r * cells_x + c])
				continue
			# A side next to a fine block keeps every grid vertex, so the two
			# share their edge exactly (no cracks); sides next to coarse blocks
			# or the field's border need only the corners.
			var fine_side := [
				bz > 0 and not coarse[(bz - 1) * blocks_x + bx],
				bx < blocks_x - 1 and not coarse[bz * blocks_x + bx + 1],
				bz < blocks_z - 1 and not coarse[(bz + 1) * blocks_x + bx],
				bx > 0 and not coarse[bz * blocks_x + bx - 1],
			]
			_block(tool, heights, cols, c0, r0, w, d, fine_side, colors[r0 * cells_x + c0])
	tool.generate_normals()
	tool.index()
	return tool.commit()


## A w × d block of cells starting at (c, r). `fine_side` (north, east, south,
## west) marks sides that must carry every grid vertex; with none it's one quad,
## else a small fan from the block's centre around its border.
static func _block(tool: SurfaceTool, heights: PackedFloat32Array, cols: int, c: int, r: int, w: int, d: int,
		fine_side: Array, color: Color) -> void:
	var ring: Array[Vector3] = []
	for k in (w if fine_side[0] else 1):
		ring.append(_grid_point(heights, cols, c + k, r))
	for k in (d if fine_side[1] else 1):
		ring.append(_grid_point(heights, cols, c + w, r + k))
	for k in (w if fine_side[2] else 1):
		ring.append(_grid_point(heights, cols, c + w - k, r + d))
	for k in (d if fine_side[3] else 1):
		ring.append(_grid_point(heights, cols, c, r + d - k))
	tool.set_color(color)
	if ring.size() == 4:
		for k in [0, 1, 2, 0, 2, 3]:
			tool.add_vertex(ring[k])
		return
	var centre := (_grid_point(heights, cols, c, r) + _grid_point(heights, cols, c + w, r + d)) / 2.0
	for k in ring.size():
		tool.add_vertex(centre)
		tool.add_vertex(ring[k])
		tool.add_vertex(ring[(k + 1) % ring.size()])


static func _grid_point(heights: PackedFloat32Array, cols: int, c: int, r: int) -> Vector3:
	return Vector3(-EXTENT.x + c * STEP, heights[r * cols + c], -EXTENT.y + r * STEP)


## The mesh samples a small cross around each vertex, so cliff outlines come out
## as smooth curves instead of grid stairs (gameplay uses the exact height_at).
static func _smooth_height(at: Vector3) -> float:
	var r := STEP * 0.5
	return (height_at(at) * 2.0 + height_at(at + Vector3(r, 0, 0)) + height_at(at - Vector3(r, 0, 0))
			+ height_at(at + Vector3(0, 0, r)) + height_at(at - Vector3(0, 0, r))) / 6.0


static func _ground_color(at: Vector3, rise: float) -> Color:
	if rise > 0.45 and not _near_ramp(at, 0.0):
		return Color(0.42, 0.38, 0.34).lerp(Color(0.3, 0.27, 0.25), clampf(rise / 2.0, 0.0, 1.0))  # cliff face
	var h := height_at(at)
	var base := Color(0.31, 0.36, 0.28)  # grass
	if absf(at.z) <= 3.0 and absf(at.x) <= 38.0 and h == 0.0:
		base = Color(0.42, 0.39, 0.33)  # the lane
	if h >= HIGH - 0.05:
		base = Color(0.4, 0.43, 0.3)  # sunlit high ground
	elif h <= LOW + 0.05:
		base = Color(0.24, 0.26, 0.23)  # shaded low ground
	elif h < 0.0 and h > LOW + 0.05 and not _in_basin(at) and not _near_ramp(at, 1.0):
		base = Color(0.36, 0.33, 0.27)  # moat banks
	elif h > 0.0 or h < 0.0:
		base = Color(0.4, 0.37, 0.3)  # ramps
	return base


## Invisible walls along every cliff edge except where a ramp crosses it.
static func _walls(parent: Node3D) -> void:
	var body := StaticBody3D.new()
	body.name = "Cliffs"
	parent.add_child(body)
	# Hill edges: points on each circle that aren't inside another hill.
	for hill in HILLS:
		var count := 48
		for k in count:
			var a0 := TAU * k / count
			var a1 := TAU * (k + 1) / count
			var p0 := Vector3(hill[0] + cos(a0) * hill[2], 0, hill[1] + sin(a0) * hill[2])
			var p1 := Vector3(hill[0] + cos(a1) * hill[2], 0, hill[1] + sin(a1) * hill[2])
			var mid := (p0 + p1) / 2.0
			if _inside_other_hill(mid, hill) or _near_ramp(mid, 0.4):
				continue
			_segment(body, p0, p1)
	# Basin edges: west, east and the side facing the field (the far side is
	# the field's own wall).
	for b in BASINS:
		var z: float = b[2] if absf(b[2]) < absf(b[3]) else b[3]
		var x: float = b[0]
		while x < b[1]:
			var nx := minf(x + 1.0, b[1])
			var mid := Vector3((x + nx) / 2.0, 0, z)
			if not _near_ramp(mid, 0.4):
				_segment(body, Vector3(x, 0, z), Vector3(nx, 0, z))
			x = nx
		for side_x in [b[0], b[1]]:
			_segment(body, Vector3(side_x, 0, b[2]), Vector3(side_x, 0, b[3]))
	# Moats: deep water.
	for moat in MOATS:
		var shape := CollisionShape3D.new()
		var box := BoxShape3D.new()
		box.size = Vector3(moat[1] - moat[0], 3.0, moat[3] - moat[2])
		shape.shape = box
		shape.position = Vector3((moat[0] + moat[1]) / 2.0, 1.0, (moat[2] + moat[3]) / 2.0)
		body.add_child(shape)


static func _inside_other_hill(at: Vector3, own: Array) -> bool:
	for hill in HILLS:
		if hill != own and Vector2(at.x - hill[0], at.z - hill[1]).length() < hill[2] - 0.05:
			return true
	return false


static func _segment(body: StaticBody3D, a: Vector3, b: Vector3) -> void:
	var length := a.distance_to(b)
	if length < 0.05:
		return
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(length + 0.2, 4.0, 0.5)
	shape.shape = box
	shape.position = (a + b) / 2.0 + Vector3(0, 0.5, 0)
	shape.rotation.y = -atan2(b.z - a.z, b.x - a.x)
	body.add_child(shape)


static func _water(parent: Node3D) -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.22, 0.45, 0.68, 0.82)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.emission_enabled = true
	material.emission = Color(0.12, 0.3, 0.5)
	material.emission_energy_multiplier = 0.4
	material.roughness = 0.15
	for moat in MOATS:
		var water := MeshInstance3D.new()
		var plane := PlaneMesh.new()
		plane.size = Vector2(moat[1] - moat[0], moat[3] - moat[2])
		water.mesh = plane
		water.material_override = material
		water.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		water.position = Vector3((moat[0] + moat[1]) / 2.0, MOAT + 0.35, (moat[2] + moat[3]) / 2.0)
		parent.add_child(water)
