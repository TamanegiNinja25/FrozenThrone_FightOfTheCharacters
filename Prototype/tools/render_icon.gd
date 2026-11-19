extends SceneTree
## Renders the app icon: two of the game's own heroes squaring off — Oren,
## the Windcutter, and Nyx, the Shade Dancer — in black and white before grey
## stalks, with the title in blood red (Dancing Script, SIL OFL).
## Needs a window (not --headless) so the GPU renders:
##   Godot_v4.7.2-stable_win64_console.exe --path Prototype -s res://tools/render_icon.gd --resolution 320x240
## Writes assets/icon/icon.png (512) and the Android adaptive-icon layers (432).

const SIZE := 1024
const FONT := "res://assets/thirdparty/fonts/dancing_script/DancingScript.ttf"
const RED := Color(0.78, 0.05, 0.07)

var _duel: SubViewport
var _cam: Camera3D
var _models: Array[RiggedModel] = []
var _canvas: SubViewport
var _layers: SubViewport
var _frames := 0


func _initialize() -> void:
	_duel = SubViewport.new()
	_duel.size = Vector2i(SIZE, SIZE)
	_duel.transparent_bg = true
	_duel.msaa_3d = Viewport.MSAA_8X
	_duel.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(_duel)
	_cam = Camera3D.new()
	_cam.fov = 27.0
	_duel.add_child(_cam)
	var key := DirectionalLight3D.new()
	key.rotation_degrees = Vector3(-28, 200, 0)
	key.light_energy = 1.7
	key.shadow_enabled = true
	_duel.add_child(key)
	var rim := DirectionalLight3D.new()
	rim.rotation_degrees = Vector3(-15, 20, 0)
	rim.light_energy = 1.5
	_duel.add_child(rim)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(0.8, 0.8, 0.8)
	env.environment.ambient_light_energy = 1.0
	env.environment.adjustment_enabled = true  # black and white, punchy contrast
	env.environment.adjustment_saturation = 0.0
	env.environment.adjustment_contrast = 1.3
	env.environment.adjustment_brightness = 1.0
	_duel.add_child(env)
	for spec in [["oren", Vector3(-0.58, 0, 0.1), -0.6], ["nyx", Vector3(0.58, 0, -0.1), 0.6]]:
		var model: RiggedModel = Roster.create(spec[0]).model_builder.call()
		model.position = spec[1]
		model.rotation.y = spec[2]  # face each other, three-quarter to the camera
		_duel.add_child(model)
		_models.append(model)
	_canvas = _make_canvas(true)
	_layers = _make_canvas(false)


func _make_canvas(with_backdrop: bool) -> SubViewport:
	var vp := SubViewport.new()
	vp.size = Vector2i(SIZE, SIZE)
	vp.transparent_bg = true
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(vp)
	var holder := Control.new()
	holder.size = Vector2(SIZE, SIZE)
	if not with_backdrop:  # Android masks the outer third of an adaptive icon
		holder.scale = Vector2.ONE * 0.68
		holder.position = Vector2.ONE * SIZE * 0.16
	vp.add_child(holder)
	if with_backdrop:
		_backdrop(holder)
	var duel := TextureRect.new()
	duel.texture = _duel.get_texture()
	duel.size = Vector2(SIZE, SIZE)
	duel.position = Vector2(0, -SIZE * 0.04)
	holder.add_child(duel)
	_title(holder)
	if with_backdrop:
		_frame(holder)
	return vp


## Pale paper with grey stalks, darker toward the edges.
func _backdrop(parent: Control) -> void:
	var paper := ColorRect.new()
	paper.color = Color(0.93, 0.93, 0.92)
	paper.size = Vector2(SIZE, SIZE)
	parent.add_child(paper)
	var rng := RandomNumberGenerator.new()
	rng.seed = 11
	for i in 14:
		var x := rng.randf_range(0.0, SIZE)
		var w := rng.randf_range(18.0, 46.0)
		var shade := rng.randf_range(0.45, 0.75)
		var stalk := ColorRect.new()
		stalk.color = Color(shade, shade, shade, rng.randf_range(0.35, 0.8))
		stalk.position = Vector2(x, 0)
		stalk.size = Vector2(w, SIZE)
		parent.add_child(stalk)
		var y := rng.randf_range(40.0, 200.0)
		while y < SIZE:  # the stalk's joints
			var joint := ColorRect.new()
			joint.color = Color(shade * 0.6, shade * 0.6, shade * 0.6, 0.9)
			joint.position = Vector2(x - 3, y)
			joint.size = Vector2(w + 6, 7)
			parent.add_child(joint)
			y += rng.randf_range(150.0, 260.0)
	var vignette := TextureRect.new()
	var radial := GradientTexture2D.new()
	radial.width = SIZE
	radial.height = SIZE
	radial.fill = GradientTexture2D.FILL_RADIAL
	radial.fill_from = Vector2(0.5, 0.45)
	radial.fill_to = Vector2(1.05, 1.05)
	radial.gradient = Gradient.new()
	radial.gradient.colors = PackedColorArray([Color(1, 1, 1, 0.0), Color(0.05, 0.05, 0.05, 0.75)])
	vignette.texture = radial
	vignette.size = Vector2(SIZE, SIZE)
	parent.add_child(vignette)


func _title(parent: Control) -> void:
	var font := FontVariation.new()
	font.base_font = load(FONT)
	font.variation_opentype = {"wght": 700}
	var lines := [["Fight of", 140, Vector2(0.24, 0.6)], ["the Characters", 130, Vector2(0.08, 0.74)]]
	for line in lines:
		var label := Label.new()
		label.text = line[0]
		var settings := LabelSettings.new()
		settings.font = font
		settings.font_size = line[1]
		settings.font_color = RED
		settings.outline_size = 20
		settings.outline_color = Color(0.05, 0.02, 0.02)
		settings.shadow_size = 8
		settings.shadow_color = Color(0, 0, 0, 0.6)
		settings.shadow_offset = Vector2(5, 7)
		label.label_settings = settings
		label.position = line[2] * SIZE
		parent.add_child(label)


func _frame(parent: Control) -> void:
	var outer := Panel.new()
	var box := StyleBoxFlat.new()
	box.bg_color = Color(0, 0, 0, 0)
	box.border_color = Color(0.04, 0.04, 0.04)
	box.set_border_width_all(34)
	box.set_corner_radius_all(150)
	outer.add_theme_stylebox_override("panel", box)
	outer.size = Vector2(SIZE, SIZE)
	parent.add_child(outer)
	var inner := Panel.new()
	var line := StyleBoxFlat.new()
	line.bg_color = Color(0, 0, 0, 0)
	line.border_color = RED
	line.set_border_width_all(7)
	line.set_corner_radius_all(118)
	inner.add_theme_stylebox_override("panel", line)
	inner.position = Vector2(32, 32)
	inner.size = Vector2(SIZE - 64, SIZE - 64)
	parent.add_child(inner)


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames == 2:
		_cam.look_at_from_position(Vector3(0.0, 2.05, -4.6), Vector3(0, 1.45, 0))
	if _frames == 25:
		for model in _models:  # mid-swing reads better than idle
			model.play_anim("attack")
	if _frames == 37:
		_save(_canvas.get_texture().get_image(), "res://assets/icon/icon.png", 512, true)
		_save(_layers.get_texture().get_image(), "res://assets/icon/android_foreground.png", 432, false)
		_save(_paper_image(), "res://assets/icon/android_background.png", 432, false)
		quit()
	return false


## The adaptive background: pale paper fading to grey at the edges.
func _paper_image() -> Image:
	var img := Image.create(SIZE, SIZE, false, Image.FORMAT_RGBA8)
	for y in SIZE:
		for x in SIZE:
			var d := Vector2(x - SIZE * 0.5, y - SIZE * 0.45).length() / (SIZE * 0.75)
			img.set_pixel(x, y, Color(0.93, 0.93, 0.92).lerp(Color(0.3, 0.3, 0.3), clampf(d, 0.0, 1.0)))
	return img


## Downsamples, and for the main icon clears the corners outside the frame.
func _save(img: Image, path: String, size: int, round_corners: bool) -> void:
	img.convert(Image.FORMAT_RGBA8)
	if round_corners:
		var r := 150
		for y in SIZE:
			for x in SIZE:
				var cx := clampi(x, r, SIZE - 1 - r)
				var cy := clampi(y, r, SIZE - 1 - r)
				if Vector2(x - cx, y - cy).length() > r:
					img.set_pixel(x, y, Color(0, 0, 0, 0))
	img.resize(size, size, Image.INTERPOLATE_LANCZOS)
	img.save_png(ProjectSettings.globalize_path(path))
