extends SceneTree
## Renders the item and skill icons from game-icons.net glyphs (CC BY 3.0,
## assets/thirdparty/game_icons/): each glyph is recoloured and framed, items
## as rounded squares tinted by shop, skills as circles tinted by the hero's
## realm. tools/icon_manifest.json maps every item and skill to its glyph.
##   Godot_v4.7.2-stable_win64_console.exe --headless --path Prototype -s res://tools/render_icons.gd

const SIZE := 128
const CATEGORY_COLORS := {
	"Items": Color(0.55, 0.24, 0.12), "Artifacts": Color(0.62, 0.46, 0.08), "Exclusive": Color(0.58, 0.12, 0.32),
	"Stats": Color(0.48, 0.36, 0.14), "Utility": Color(0.12, 0.38, 0.48), "Relics": Color(0.42, 0.22, 0.58),
	"Consumables": Color(0.1, 0.46, 0.44),
}
const REALM_COLORS := {
	"Ember Forge": Color(0.85, 0.38, 0.12), "Gale Peaks": Color(0.2, 0.55, 0.85),
	"Stone Barrows": Color(0.38, 0.55, 0.25), "Hollow Moon": Color(0.5, 0.32, 0.8),
}
const GOLD := "#f2c45a"


func _initialize() -> void:
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://tools/icon_manifest.json"))
	var made := 0
	for id in manifest.items:
		var entry: Array = manifest.items[id]
		_render(entry[0], CATEGORY_COLORS.get(entry[1], Color(0.4, 0.4, 0.4)), false, "res://assets/icons/items/%s.png" % id)
		made += 1
	for key in manifest.skills:
		var entry: Array = manifest.skills[key]
		var realm := Roster.create(entry[1]).realm
		_render(entry[0], REALM_COLORS.get(realm, Color(0.4, 0.4, 0.5)), true, "res://assets/icons/skills/%s.png" % key)
		made += 1
	print("ICONS RENDERED: %d" % made)
	quit()


func _render(glyph_path: String, tint: Color, round: bool, out_path: String) -> void:
	var glyph := _glyph_body(FileAccess.get_file_as_string(glyph_path))
	var light := tint.lightened(0.45).to_html(false)
	var dark := tint.darkened(0.65).to_html(false)
	var mid := tint.to_html(false)
	var pale := Color.WHITE.lerp(tint.lightened(0.6), 0.35).to_html(false)
	var frame := ('<circle cx="64" cy="64" r="60" fill="url(#bg)" stroke="%s" stroke-width="5"/>'
			+ '<circle cx="64" cy="64" r="54.5" fill="none" stroke="#000" stroke-opacity="0.35" stroke-width="2"/>') % GOLD
	if not round:
		frame = ('<rect x="4" y="4" width="120" height="120" rx="18" fill="url(#bg)" stroke="%s" stroke-width="5"/>'
				+ '<rect x="9.5" y="9.5" width="109" height="109" rx="13" fill="none" stroke="#000" stroke-opacity="0.35" stroke-width="2"/>') % GOLD
	var scale := 0.15 if round else 0.16  # glyph 77–82 px of 128
	var offset := (SIZE - 512.0 * scale) / 2.0
	var svg := ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128" width="128" height="128"><defs>'
			+ '<radialGradient id="bg" cx="0.5" cy="0.38" r="0.7"><stop offset="0" stop-color="#%s"/><stop offset="0.55" stop-color="#%s"/><stop offset="1" stop-color="#%s"/></radialGradient>'
			+ '<linearGradient id="gl" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#ffffff"/><stop offset="1" stop-color="#%s"/></linearGradient>'
			+ '</defs>%s'
			+ '<g transform="translate(%.2f %.2f) scale(%.4f)" fill="#000" fill-opacity="0.55">%s</g>'
			+ '<g transform="translate(%.2f %.2f) scale(%.4f)" fill="url(#gl)">%s</g></svg>') % [
		light, mid, dark, pale, frame, offset + 2.5, offset + 3.5, scale, glyph, offset, offset, scale, glyph]
	var image := Image.new()
	var err := image.load_svg_from_string(svg, 1.0)
	if err != OK:
		push_error("icon failed: %s" % out_path)
		return
	image.save_png(ProjectSettings.globalize_path(out_path))


## The glyph's shapes without the black background square or their own fills.
func _glyph_body(svg: String) -> String:
	var start := svg.find(">", svg.find("<svg")) + 1
	var body := svg.substr(start, svg.rfind("</svg>") - start)
	body = body.replace('<path d="M0 0h512v512H0z"/>', "")
	var fill := RegEx.create_from_string('\\sfill="[^"]*"')
	return fill.sub(body, "", true)
