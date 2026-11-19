extends SceneTree
## Renders the app icon: Tamsin (a CC0 Quaternius-based hero) under a magenta
## to purple sky, framed, with the title in Dancing Script (SIL OFL).
## Needs a window (not --headless) so the GPU renders:
##   Godot_v4.7.2-stable_win64_console.exe --path Prototype -s res://tools/render_icon.gd --resolution 320x240
## Writes assets/icon/icon.png (512) and the Android adaptive-icon layers (432).

const SIZE := 1024
const FONT := "res://assets/thirdparty/fonts/dancing_script/DancingScript.ttf"
const HERO := "tamsin"

var _portrait: SubViewport
var _cam: Camera3D
var _canvas: SubViewport
var _layers: SubViewport
var _frames := 0


func _initialize() -> void:
	_portrait = SubViewport.new()
	_portrait.size = Vector2i(SIZE, SIZE)
	_portrait.transparent_bg = true
	_portrait.msaa_3d = Viewport.MSAA_8X
	_portrait.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(_portrait)
	_cam = Camera3D.new()
	_cam.fov = 27.0
	_portrait.add_child(_cam)
	var key := DirectionalLight3D.new()
	key.rotation_degrees = Vector3(-30, 160, 0)
	key.light_energy = 1.35
	_portrait.add_child(key)
	var rim := DirectionalLight3D.new()
	rim.rotation_degrees = Vector3(-12, -25, 0)
	rim.light_energy = 2.2
	rim.light_color = Color(1.0, 0.5, 0.85)
	_portrait.add_child(rim)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(0.85, 0.72, 0.92)
	env.environment.ambient_light_energy = 0.7
	_portrait.add_child(env)
	var model: Node3D = Roster.create(HERO).model_builder.call()
	model.rotation.y = -0.5
	_portrait.add_child(model)

	_canvas = _make_canvas(true)
	_layers = _make_canvas(false)


## The full icon (with_sky) or the adaptive foreground (hero and title only,
## shrunk into the launcher's safe zone).
func _make_canvas(with_sky: bool) -> SubViewport:
	var vp := SubViewport.new()
	vp.size = Vector2i(SIZE, SIZE)
	vp.transparent_bg = true
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(vp)
	var holder := Control.new()
	holder.size = Vector2(SIZE, SIZE)
	if not with_sky:  # Android masks the outer third of an adaptive icon
		holder.scale = Vector2.ONE * 0.68
		holder.position = Vector2.ONE * SIZE * 0.16
	vp.add_child(holder)
	if with_sky:
		_sky(holder)
	var hero := TextureRect.new()
	hero.texture = _portrait.get_texture()
	hero.size = Vector2(SIZE, SIZE) * 1.05
	hero.position = Vector2(SIZE * 0.17, -SIZE * 0.07)
	holder.add_child(hero)
	_title(holder)
	if with_sky:
		_frame(holder)
	return vp


func _sky(parent: Control) -> void:
	var sky := TextureRect.new()
	var grad := GradientTexture2D.new()
	grad.width = SIZE
	grad.height = SIZE
	grad.fill_from = Vector2(0, 0)
	grad.fill_to = Vector2(1, 1)
	grad.gradient = Gradient.new()
	grad.gradient.colors = PackedColorArray([Color(0.93, 0.33, 0.66), Color(0.62, 0.2, 0.62), Color(0.25, 0.1, 0.4)])
	grad.gradient.offsets = PackedFloat32Array([0.0, 0.5, 1.0])
	sky.texture = grad
	sky.size = Vector2(SIZE, SIZE)
	parent.add_child(sky)
	var glow := TextureRect.new()
	var radial := GradientTexture2D.new()
	radial.width = SIZE
	radial.height = SIZE
	radial.fill = GradientTexture2D.FILL_RADIAL
	radial.fill_from = Vector2(0.58, 0.38)
	radial.fill_to = Vector2(0.58, 0.0)
	radial.gradient = Gradient.new()
	radial.gradient.colors = PackedColorArray([Color(1.0, 0.85, 0.95, 0.55), Color(1.0, 0.6, 0.9, 0.0)])
	glow.texture = radial
	glow.size = Vector2(SIZE, SIZE)
	parent.add_child(glow)


func _title(parent: Control) -> void:
	var font := FontVariation.new()
	font.base_font = load(FONT)
	font.variation_opentype = {"wght": 700}
	var lines := [["Fight of", 150, Vector2(0.07, 0.6)], ["the Characters", 128, Vector2(0.05, 0.75)]]
	for line in lines:
		var label := Label.new()
		label.text = line[0]
		var settings := LabelSettings.new()
		settings.font = font
		settings.font_size = line[1]
		settings.font_color = Color(1.0, 0.97, 1.0)
		settings.outline_size = 22
		settings.outline_color = Color(0.36, 0.08, 0.42)
		settings.shadow_size = 10
		settings.shadow_color = Color(0.1, 0.0, 0.15, 0.7)
		settings.shadow_offset = Vector2(6, 8)
		label.label_settings = settings
		label.position = line[2] * SIZE
		parent.add_child(label)


func _frame(parent: Control) -> void:
	var outer := Panel.new()
	var box := StyleBoxFlat.new()
	box.bg_color = Color(0, 0, 0, 0)
	box.border_color = Color(0.08, 0.05, 0.1)
	box.set_border_width_all(34)
	box.set_corner_radius_all(150)
	outer.add_theme_stylebox_override("panel", box)
	outer.size = Vector2(SIZE, SIZE)
	parent.add_child(outer)
	var inner := Panel.new()
	var line := StyleBoxFlat.new()
	line.bg_color = Color(0, 0, 0, 0)
	line.border_color = Color(0.95, 0.75, 0.35)
	line.set_border_width_all(8)
	line.set_corner_radius_all(118)
	inner.add_theme_stylebox_override("panel", line)
	inner.position = Vector2(32, 32)
	inner.size = Vector2(SIZE - 64, SIZE - 64)
	parent.add_child(inner)


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames == 2:
		_cam.look_at_from_position(Vector3(1.0, 2.25, -4.3), Vector3(0, 1.62, 0))
	if _frames == 45:
		_save(_canvas.get_texture().get_image(), "res://assets/icon/icon.png", 512, true)
		_save(_layers.get_texture().get_image(), "res://assets/icon/android_foreground.png", 432, false)
		var sky_only := _make_sky_image()
		_save(sky_only, "res://assets/icon/android_background.png", 432, false)
		quit()
	return false


## The adaptive background: the same gradient, no frame, no hero.
func _make_sky_image() -> Image:
	var img := Image.create(SIZE, SIZE, false, Image.FORMAT_RGBA8)
	var a := Color(0.93, 0.33, 0.66)
	var b := Color(0.62, 0.2, 0.62)
	var c := Color(0.25, 0.1, 0.4)
	for y in SIZE:
		for x in SIZE:
			var t := (x + y) / (2.0 * SIZE)
			img.set_pixel(x, y, a.lerp(b, t * 2.0) if t < 0.5 else b.lerp(c, (t - 0.5) * 2.0))
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
