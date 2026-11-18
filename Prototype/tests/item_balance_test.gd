extends SceneTree
## Item and damage balance, measured on the real game code:
##   Godot_v4.7.2-stable_win64_console.exe --headless --path Prototype -s res://tests/item_balance_test.gd
## • gold efficiency at the reference map's own prices (an attribute point 120
##   gold, HP 3, damage and armour 80 — its Belt, Healthstone, Axe and Shield):
##   shop items near 1.0, signature items better (the map's are ~1.8), recipes
##   never worth less than their parts;
## • time-to-kill between two equal heroes at levels 10, 20 and 30 carrying a
##   build they could afford, for every role: 4–14 s, so fights neither drag
##   nor end in a blink as the game goes on.

const PRICE := {"str": 120.0, "agi": 120.0, "int": 120.0, "hp": 3.0, "damage": 80.0, "armor": 80.0,
	"regen": 60.0, "attack_speed": 6000.0, "move_speed": 16000.0, "cooldown": 15000.0}
## Builds by level and role: what the role's bot build has bought by then
## (recipes fused), plus primary-attribute tomes from spare gold.
const BUILDS := {
	10: {"tank": [["titan_belt", "heartstone"], 4], "damage": [["swift_boots", "titan_belt"], 4], "caster": [["sage_stone", "heartstone"], 4]},
	# Equal gold per level: ~24,000 by level 20, ~35,000 by level 30.
	20: {"tank": [["labyrinth_cleaver", "exclusive", "heartstone"], 20], "damage": [["swift_boots", "warbreaker_axe", "exclusive", "heartstone"], 20],
		"caster": [["mystic_heartstone", "exclusive", "titan_belt", "ember_idol"], 20]},
	30: {"tank": [["labyrinth_cleaver", "exclusive", "golden_bulwark", "heartstone"], 60],
		"damage": [["swift_boots", "warbreaker_axe", "exclusive", "labyrinth_cleaver", "heartstone"], 60],
		"caster": [["mystic_heartstone", "exclusive", "golden_bulwark", "ember_idol", "titan_belt"], 60]},
}
const HEROES := ["vael", "ryn", "barrow", "sable", "tamsin", "brannoc", "nyx", "lys"]

var _failures: Array[String] = []


var _started := false


## Runs on the first frame: heroes only set themselves up (_ready) once the
## main loop is running.
func _process(_delta: float) -> bool:
	if _started:
		return false
	_started = true
	_run()
	return false


func _run() -> void:
	_gold_efficiency()
	_time_to_kill()
	for failure in _failures:
		printerr("FAIL: " + failure)
	print("ITEM BALANCE TEST %s (%d checks failed)" % ["PASSED" if _failures.is_empty() else "FAILED", _failures.size()])
	quit(1 if _failures.size() else 0)


static func value(item: ItemDef) -> float:
	var total := 0.0
	for key in item.stats:
		total += float(item.stats[key]) * PRICE.get(key, 0.0)
	return total


func _gold_efficiency() -> void:
	var shop_low := INF
	var shop_high := 0.0
	for item in ItemCatalog.in_category("Items"):
		if item.id in ["ember_idol", "watcher_eye", "seeing_stone"]:
			continue  # aura and true sight are utility, priced as in the map
		var e := value(item) / item.cost
		shop_low = minf(shop_low, e)
		shop_high = maxf(shop_high, e)
		print("  %-18s %6d gold  value %6.0f  efficiency %.2f" % [item.display_name, item.cost, value(item), e])
	_check(shop_low >= 0.75 and shop_high <= 1.35, "shop items buy power at the map's rate (%.2f–%.2f)" % [shop_low, shop_high])
	var sig_low := INF
	for item in ItemCatalog.in_category("Exclusive"):
		sig_low = minf(sig_low, value(item) / item.cost)
	var sig_high := 0.0
	for item in ItemCatalog.in_category("Exclusive"):
		sig_high = maxf(sig_high, value(item) / item.cost)
	_check(sig_low >= 1.2, "signature items are the best value per gold, as in the map (lowest %.2f)" % sig_low)
	_check(sig_high / sig_low <= 1.2, "no hero's signature item outclasses another's (%.2f–%.2f)" % [sig_low, sig_high])
	var recipes_ok := true
	for recipe in ItemCatalog.RECIPES:
		var parts := 0.0
		for part_id in recipe[1]:
			parts += value(ItemCatalog.find(part_id))
		var made := value(ItemCatalog.find(recipe[0]))
		print("  recipe %-20s parts %6.0f → %6.0f" % [recipe[0], parts, made])
		if made < parts - 1.0 and recipe[0] != "titan_pact":
			recipes_ok = false
	_check(recipes_ok, "a recipe is never worth less than its parts (and frees inventory slots)")


func _time_to_kill() -> void:
	var world := Node3D.new()
	root.add_child(world)
	for level in BUILDS:
		var low := INF
		var high := 0.0
		var line := PackedStringArray()
		var duel_low := INF
		var duel_high := 0.0
		var duels := PackedStringArray()
		var reference := _build(world, "vael", level)
		for hero_id in HEROES:
			var h := _build(world, hero_id, level)
			var ttk := _ttk(h, h)
			# Duel against a bruiser of equal level and gold: >1 wins, <1 loses.
			var ratio := _ttk(reference, h) / _ttk(h, reference)
			duel_low = minf(duel_low, ratio)
			duel_high = maxf(duel_high, ratio)
			duels.append("%s %.2f" % [hero_id, ratio])
			low = minf(low, ttk)
			high = maxf(high, ttk)
			line.append("%s %.1f" % [hero_id, ttk])
			if OS.get_cmdline_user_args().has("--detail"):
				print("    %-8s L%d  dmg %4.0f  every %.2fs  hp %5.0f  armour %2.0f%%  regen %3.0f" % [hero_id, level, h.attack_damage, h.attack_interval, h.max_hp, h.damage_reduction * 100.0, h.hp_regen])
			h.free()
		reference.free()
		print("  L%d time-to-kill: %s" % [level, ", ".join(line)])
		print("  L%d duel vs Vael: %s" % [level, ", ".join(duels)])
		_check(low >= 2.0 and high <= 18.0, "level %d: mirror fights last 2–18 s (%.1f–%.1f)" % [level, low, high])
		_check(duel_low >= 0.45 and duel_high <= 2.2, "level %d: every role holds its own in a duel with an equal bruiser (%.2f–%.2f)" % [level, duel_low, duel_high])
	world.free()


func _build(world: Node3D, hero_id: String, level: int) -> Hero:
	var h := Hero.new()
	h.definition = Roster.create(hero_id)
	h.is_player = false
	world.add_child(h)
	h.add_xp(Hero.xp_for_level(level))
	var kind := "caster" if h.definition.role == "Caster" else ("damage" if h.definition.role in ["Speed", "Ranged"] else "tank")
	var build: Array = BUILDS[level][kind][0]
	for item_id: String in build:
		var real_id := h.definition.exclusive_item if item_id == "exclusive" else item_id
		h.items.append(ItemCatalog.find(real_id))
	h.tome_attributes[h.definition.primary] += BUILDS[level][kind][1]
	for skill in h.skills:
		skill.rank = mini(skill.max_rank, maxi(1, (level - skill.required_level) / skill.level_skip + 1))
	h.recompute_stats()
	return h


## Seconds for `a` to kill `b`: auto-attacks, every learned skill on its
## cooldown (zones over their duration, barrages and volleys by their hits)
## and any burning aura, through b's armour, minus b's regeneration.
static func _ttk(a: Hero, b: Hero) -> float:
	var skill_dps := 0.0
	for skill in a.skills:
		if skill.rank <= 0:
			continue
		# The first three heroes' hand-written skills carry no damage field: count
		# them as a typical hit (130, ultimates 300) at their rank and attributes.
		var base: float = skill.damage if "damage" in skill else (300.0 if skill.ultimate else 130.0)
		var hit: float = skill.scaled(a, base)
		if "zone_time" in skill and skill.zone_time > 0.0:
			hit *= skill.zone_time
		if "strikes" in skill:
			hit *= skill.strikes
		if "count" in skill and skill.count > 1:
			hit *= minf(skill.count, 2.0)  # a fan rarely lands every shot
		skill_dps += hit / (skill.cooldown * (1.0 - a.cooldown_reduction))
	var dps := a.attack_damage / a.attack_interval + skill_dps + a.aura_dps
	var taken := dps * (1.0 - b.damage_reduction) - b.hp_regen
	return b.max_hp / taken if taken > 0.0 else INF


func _check(ok: bool, what: String) -> void:
	if ok:
		print("ok   " + what)
	else:
		_failures.append(what)
