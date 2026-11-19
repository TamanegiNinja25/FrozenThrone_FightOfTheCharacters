class_name ItemCatalog
extends RefCounted
## Every item, by shop. The itemization follows the reference map's own shops,
## stat values and recipes (names and icons are original):
##   Items      — the map's item shop: +25 attribute belts and boots, +1,000 HP,
##                +100 damage, +100 armour, a burning aura, true sight, speed;
##   Stats      — the stat shop's tomes at the map's prices;
##   Utility    — the mixed shop: a reusable recall, the capture orb, knives,
##                a cloak, a silencing stone, the satchel, two champion items;
##   Exclusive  — one signature item per hero, 10,000 gold, ~150 stat points;
##   Artifacts  — the map's seven recipes plus this game's own (lifesteal,
##                attack speed, regeneration, spell recipes, a three-part
##                banner, and two upgrades of map artifacts), made at a circle;
##   Relics     — this game's meter items; Consumables — potions.
## Gold buys power at roughly the same rate everywhere (an attribute point ≈ 120
## gold); recipes free inventory slots and add a little on top. Measured by
## tests/item_balance_test.gd, which also checks time-to-kill across levels.

const CATEGORIES := ["Items", "Artifacts", "Exclusive", "Stats", "Utility", "Relics", "Consumables"]
const INVENTORY_SIZE := 6
## The reference map pawns items for 75%.
const SELL_RATE := 0.75
## The map's seven combining recipes (its triggers' exact pairs, original names),
## checked in this order: carry every part into a circle and they fuse.
const RECIPES := [
	["golden_bulwark", ["titan_belt", "tower_shield"]],
	["labyrinth_cleaver", ["titan_belt", "warbreaker_axe"]],
	["galewalker_treads", ["swift_boots", "wind_charm"]],
	["victors_medal", ["ember_idol", "swift_boots"]],
	["mystic_heartstone", ["heartstone", "sage_stone"]],
	["emperors_blade", ["warbreaker_axe", "tower_shield"]],
	["titan_pact", ["seeing_stone", "ember_idol"]],
	# This game's own recipes, on the same rules (worth at least their parts).
	["bloodreaver", ["warbreaker_axe", "bloodfang_charm"]],
	["stormstrike_gauntlets", ["quickfang_gauntlets", "swift_boots"]],
	["lifewell_plate", ["heartstone", "vigor_band"]],
	["archmage_crown", ["sage_stone", "arcane_focus"]],
	["phantom_edge", ["wind_charm", "quickfang_gauntlets"]],
	["warlords_banner", ["titan_belt", "vigor_band", "ember_idol"]],
	# Upgrades: a map artifact plus one more part.
	["kingsguard_aegis", ["golden_bulwark", "vigor_band"]],
	["worldsplitter", ["labyrinth_cleaver", "bloodfang_charm"]],
]
## Bots buy for their role, in this order, at their fountain ("exclusive" is
## the hero's own signature item); pairs that are recipes fuse at the circle.
const BOT_BUILDS := {
	# Each fits 6 slots once its recipes fuse; utility items have roles: the
	# recall scroll for the front line, the cloak for divers, the Hushstone
	# for those who fight casters, the Titan Pact (seeing stone + idol) for casters.
	"Bruiser": ["titan_belt", "warbreaker_axe", "capture_orb", "homeward_scroll", "exclusive", "tower_shield", "titan_belt", "heartstone"],
	"Giant": ["titan_belt", "heartstone", "capture_orb", "homeward_scroll", "exclusive", "warbreaker_axe", "titan_belt", "tower_shield"],
	"Speed": ["swift_boots", "warbreaker_axe", "capture_orb", "shadow_cloak", "exclusive", "titan_belt", "wind_charm", "hushstone"],
	"Ranged": ["swift_boots", "warbreaker_axe", "capture_orb", "hushstone", "exclusive", "heartstone", "titan_belt"],
	"Caster": ["sage_stone", "heartstone", "capture_orb", "hushstone", "exclusive", "ember_idol", "seeing_stone", "titan_belt"],
	# Bruisers whose main attribute is agility (Kael, Corin): only the main
	# attribute adds attack damage, so boots replace the first belt, and boots
	# + idol fuse into Victor's Medal.
	"AgilityBruiser": ["swift_boots", "warbreaker_axe", "capture_orb", "homeward_scroll", "exclusive", "titan_belt", "ember_idol", "tower_shield"],
}


static func bot_build(role: String, primary := "") -> Array:
	if role == "Bruiser" and primary == "agi":
		return BOT_BUILDS.AgilityBruiser
	return BOT_BUILDS.get(role, BOT_BUILDS.Bruiser)

## Signature items: [id, name, hero, stats] — the map's 10,000-gold budget,
## evened out: each is worth ~16,500–18,000 gold at the map's own prices
## (+100 primary plus a role extra), so no hero's own item outclasses another's.
const SIGNATURES := [
	["kilnheart_core", "Kilnheart Core", "vael", {"str": 100.0, "armor": 50.0}],
	["galeheart_ribbon", "Galeheart Ribbon", "ryn", {"agi": 100.0, "str": 25.0, "attack_speed": 0.3}],
	["cairnstone_heart", "Cairnstone Heart", "barrow", {"str": 100.0, "hp": 1500.0}],
	["emberstring_bow", "Emberstring Bow", "sable", {"agi": 100.0, "damage": 60.0}],
	["gravebloom_censer", "Gravebloom Censer", "morrow", {"int": 100.0, "str": 25.0, "regen": 25.0}],
	["moonless_hilt", "Moonless Hilt", "kael", {"agi": 75.0, "str": 50.0, "move_speed": 0.15}],
	["thunderhead_crown", "Thunderhead Crown", "tamsin", {"int": 100.0, "str": 25.0, "cooldown": 0.2}],
	["wardens_bulwark", "Warden's Bulwark", "hask", {"str": 100.0, "armor": 60.0}],
	["cinderfist_wraps", "Cinderfist Wraps", "pyre", {"agi": 100.0, "str": 25.0, "attack_speed": 0.3}],
	["gatekeepers_seal", "Gatekeeper's Seal", "brannoc", {"str": 100.0, "armor": 60.0}],
	["dawnforged_sigil", "Dawnforged Sigil", "seraphine", {"str": 75.0, "agi": 50.0, "regen": 25.0}],
	["starfire_codex", "Starfire Codex", "ashka", {"int": 100.0, "agi": 25.0, "cooldown": 0.2}],
	["rimeglass_compass", "Rimeglass Compass", "isolde", {"int": 100.0, "hp": 1500.0}],
	["windcutter_tsuba", "Windcutter Tsuba", "oren", {"agi": 100.0, "attack_speed": 0.3, "move_speed": 0.2}],
	["galespire_lance", "Galespire Lance", "kestrel", {"agi": 100.0, "damage": 60.0}],
	["thunderheart_torc", "Thunderheart Torc", "thane", {"str": 100.0, "hp": 1500.0}],
	["dunestone_urn", "Dunestone Urn", "dunmar", {"str": 100.0, "armor": 60.0}],
	["marshlight_lantern", "Marshlight Lantern", "mire", {"int": 100.0, "str": 25.0, "regen": 25.0}],
	["carvers_chisel", "Carver's Chisel", "halvard", {"str": 100.0, "int": 25.0, "cooldown": 0.1}],
	["cairnwood_bow", "Cairnwood Bow", "wren", {"agi": 100.0, "damage": 60.0}],
	["spiritbound_knuckles", "Spiritbound Knuckles", "corin", {"agi": 100.0, "str": 25.0, "damage": 30.0}],
	["moonsilver_quiver", "Moonsilver Quiver", "velka", {"agi": 100.0, "attack_speed": 0.3, "damage": 40.0}],
	["nightglass_dagger", "Nightglass Dagger", "nyx", {"agi": 100.0, "move_speed": 0.15, "damage": 40.0}],
	["tidepearl_circlet", "Tidepearl Circlet", "lys", {"int": 100.0, "hp": 1500.0}],
]


static var _all: Array[ItemDef] = []


## Every item, built once and shared (items are read-only definitions).
static func all() -> Array[ItemDef]:
	if _all.is_empty():
		_all = _build()
	return _all


static func _build() -> Array[ItemDef]:
	var items: Array[ItemDef] = []
	# The map's item shop (its values; original names).
	for spec in [["titan_belt", "Titan's Belt", 3000, {"str": 25.0}],
			["swift_boots", "Swiftstride Boots", 3000, {"agi": 25.0}],
			["heartstone", "Heartstone", 3000, {"hp": 1000.0}],
			["sage_stone", "Sage Stone", 3000, {"int": 25.0, "cooldown": 0.05}],
			["warbreaker_axe", "Warbreaker Axe", 8000, {"damage": 100.0}],
			["seeing_stone", "Seeing Stone", 8500, {"damage": 100.0, "reveal": 10.0}],
			["tower_shield", "Tower Shield", 8000, {"armor": 100.0}],
			["ember_idol", "Ember Idol", 3000, {"aura_dps": 50.0}],
			["watcher_eye", "Watcher's Eye", 500, {"reveal": 10.0}],
			["wind_charm", "Wind Charm", 5000, {"move_speed": 0.3}],
			["quickfang_gauntlets", "Quickfang Gauntlets", 2500, {"attack_speed": 0.4}],
			["bloodfang_charm", "Bloodfang Charm", 3000, {"lifesteal": 0.12}],
			["vigor_band", "Vigor Band", 2500, {"regen": 40.0}],
			["arcane_focus", "Arcane Focus", 3000, {"int": 10.0, "cooldown": 0.1}]]:
		items.append(ItemDef.make(spec[0], spec[1], "Items", spec[2], stat_text(spec[3]), spec[3]))
	# This game's meter items, and the storage satchel.
	items.append(ItemDef.make("kindling_rune", "Kindling Rune", "Relics", 4500, "Transformation meter charges 25% faster.", {"meter_gain": 0.25}))
	items.append(ItemDef.make("everflame_sigil", "Everflame Sigil", "Relics", 6000, "Transformation lasts 4 s longer.", {"form_duration": 4.0}))
	var satchel := ItemDef.make("satchel_of_holding", "Satchel of Holding", "Relics", 2500, "Opens a 6-slot bag. Items resting in the bag give no stats: tap BAG, then tap an item to move it.")
	satchel.bag = true
	items.append(satchel)
	# Potions.
	items.append(ItemDef.make("ember_draught", "Ember Draught", "Consumables", 400, "Tap to heal 600 HP over 5 s. Two stack in a slot.", {}, "heal", 600.0))
	items.append(ItemDef.make("spark_flask", "Spark Flask", "Consumables", 1500, "Tap to charge the meter by 25. Two stack in a slot.", {}, "meter", 25.0))
	# The map's mixed shop.
	var recall := ItemDef.make("homeward_scroll", "Homeward Scroll", "Utility", 1000, "Tap: after 2 s standing still, return to your recall point (set it with MARK) or your fountain. Reusable every 30 s.", {}, "recall", 2.0)
	recall.reusable = 30.0
	items.append(recall)
	items.append(ItemDef.make("throwing_knives", "Throwing Knives", "Utility", 300, "Tap: hit the nearest enemy within 8 for 300. Two stack in a slot.", {}, "knife", 300.0))
	items.append(ItemDef.make("shadow_cloak", "Shadow Cloak", "Utility", 500, "Tap: unseen by enemies for 5 s, until you attack or cast.", {}, "cloak", 5.0))
	items.append(ItemDef.make("hushstone", "Hushstone", "Utility", 700, "Tap: the nearest enemy hero within 8 can't cast skills for 5 s.", {}, "silence", 5.0))
	var orb := ItemDef.make("capture_orb", "Capture Orb", "Utility", 1000, "Tap next to a creep at 30% health or less (not a boss): a 30% chance to catch it. It stays yours: tap the full orb to call it out or back.", {}, "capture", 4.0)
	orb.reusable = 3.0
	items.append(orb)
	var full_orb := ItemDef.make("capture_orb_full", "Capture Orb (full)", "Utility", 1000, "Your captured creep. Tap to call it out to fight for you, tap again to call it back. Selling the orb sets it free.", {}, "release", 0.0)
	full_orb.buyable = false
	items.append(full_orb)
	items.append(ItemDef.make("wanderers_hat", "Wanderer's Hat", "Utility", 10000, stat_text({"agi": 100.0, "str": 50.0}), {"agi": 100.0, "str": 50.0}))
	items.append(ItemDef.make("dread_fin", "Dread Fin", "Utility", 10000, stat_text({"str": 100.0, "silence_chance": 0.05}), {"str": 100.0, "silence_chance": 0.05}))
	# Stat shop — the reference map's tomes and prices, used up on purchase.
	for spec in [["tome_str_2", "Tome of Might +2", 250, {"str": 2}], ["tome_agi_2", "Tome of Grace +2", 200, {"agi": 2}],
			["tome_str_5", "Tome of Might +5", 600, {"str": 5}], ["tome_agi_5", "Tome of Grace +5", 500, {"agi": 5}],
			["tome_all_100", "Codex of Ascension", 19000, {"str": 100, "agi": 100, "int": 100}]]:
		var tome := ItemDef.make(spec[0], spec[1], "Stats", spec[2], "Permanently +%s." % _attribute_text(spec[3]))
		tome.tome = spec[3]
		items.append(tome)
	for spec in [["tome_xp_minor", "Minor Tome of Lore", 150, 100.0], ["tome_xp_greater", "Greater Tome of Lore", 450, 500.0]]:
		var lore := ItemDef.make(spec[0], spec[1], "Stats", spec[2], "Gain %d experience." % spec[3])
		lore.xp = spec[3]
		items.append(lore)
	# Signature items — one per hero, 10,000 gold like the map's.
	for spec in SIGNATURES:
		var item := ItemDef.make(spec[0], spec[1], "Exclusive", 10000, "%s only. %s" % [str(spec[2]).capitalize(), stat_text(spec[3])], spec[3])
		item.hero_only = spec[2]
		items.append(item)
	# Artifacts — the map's recipe results; sell value is the parts' total.
	for spec in [["golden_bulwark", "Golden Bulwark", {"str": 25.0, "armor": 200.0}],
			["labyrinth_cleaver", "Labyrinth Cleaver", {"str": 25.0, "damage": 200.0}],
			["galewalker_treads", "Galewalker Treads", {"agi": 25.0, "move_speed": 0.6}],
			["victors_medal", "Victor's Medal", {"str": 25.0, "agi": 25.0, "int": 25.0, "regen": 25.0}],
			["mystic_heartstone", "Mystic Heartstone", {"hp": 2000.0, "int": 25.0}],
			["emperors_blade", "Emperor's Blade", {"damage": 200.0, "armor": 200.0}],
			["titan_pact", "Pact of the Bog Titan", {"str": 25.0, "agi": 25.0, "int": 25.0}],
			["bloodreaver", "Bloodreaver", {"damage": 120.0, "lifesteal": 0.2}],
			["stormstrike_gauntlets", "Stormstrike Gauntlets", {"agi": 30.0, "attack_speed": 0.6}],
			["lifewell_plate", "Lifewell Plate", {"hp": 1500.0, "regen": 60.0}],
			["archmage_crown", "Archmage Crown", {"int": 40.0, "cooldown": 0.2}],
			["phantom_edge", "Phantom Edge", {"move_speed": 0.4, "attack_speed": 0.55}],
			["warlords_banner", "Warlord's Banner", {"str": 40.0, "regen": 45.0, "aura_dps": 80.0}],
			["kingsguard_aegis", "Kingsguard Aegis", {"str": 30.0, "armor": 260.0, "regen": 50.0}],
			["worldsplitter", "Worldsplitter", {"str": 30.0, "damage": 260.0, "lifesteal": 0.15}]]:
		var artifact := ItemDef.make(spec[0], spec[1], "Artifacts", 0, stat_text(spec[2]), spec[2])
		artifact.buyable = false
		items.append(artifact)
	# The secret recipe's pact: call a bog titan to fight for you (the map's summon scroll).
	var pact: ItemDef = items.filter(func(i): return i.id == "titan_pact")[0]
	pact.use = "titan"
	pact.use_amount = 60.0
	pact.consumable = true
	pact.reusable = 120.0
	pact.description += " Tap: call a bog titan to fight for you for 60 s (every 120 s)."
	# Artifacts cost their parts' total (parts may be artifacts themselves, so
	# recipes are priced in order); every artifact says what it's made from and
	# every part says what it builds into.
	for recipe in RECIPES:
		var artifact: ItemDef = items.filter(func(i): return i.id == recipe[0])[0]
		var names: Array[String] = []
		for part_id in recipe[1]:
			var part: ItemDef = items.filter(func(i): return i.id == part_id)[0]
			artifact.cost += part.cost
			names.append(part.display_name)
			part.builds_into.append(artifact.id)
		artifact.description += " Made from: %s." % " + ".join(names)
	for item in items:
		if not item.builds_into.is_empty():
			var names: Array[String] = []
			for id in item.builds_into:
				names.append(items.filter(func(i): return i.id == id)[0].display_name)
			item.description += " Builds into: %s." % ", ".join(names)
	return items


## Readable stats, e.g. "+25 strength, +200 armour."
static func stat_text(stats: Dictionary) -> String:
	var parts: Array[String] = []
	var words := {"str": "strength", "agi": "agility", "int": "intelligence"}
	for key in stats:
		var v: float = stats[key]
		match key:
			"str", "agi", "int": parts.append("+%d %s" % [v, words[key]])
			"hp": parts.append("+%d max HP" % v)
			"damage": parts.append("+%d attack damage" % v)
			"armor": parts.append("+%d armour" % v)
			"regen": parts.append("+%d HP per second" % v)
			"attack_speed": parts.append("+%d%% attack speed" % roundi(v * 100.0))
			"move_speed": parts.append("+%d%% move speed" % roundi(v * 100.0))
			"cooldown": parts.append("skills recharge %d%% faster" % roundi(v * 100.0))
			"aura_dps": parts.append("burns enemies within 3 for %d/s" % v)
			"reveal": parts.append("reveals cloaked enemies within %d" % v)
			"silence_chance": parts.append("%d%% chance on hit to silence for 2 s" % roundi(v * 100.0))
			"lifesteal": parts.append("attacks heal you for %d%% of their damage" % roundi(v * 100.0))
			"meter_gain": parts.append("meter charges %d%% faster" % roundi(v * 100.0))
			"form_duration": parts.append("transformation lasts %d s longer" % v)
	var text := ", ".join(parts)
	return text.left(1).to_upper() + text.substr(1) + "."


static func _attribute_text(points: Dictionary) -> String:
	var names := {"str": "strength", "agi": "agility", "int": "intelligence"}
	var parts: Array[String] = []
	for key in points:
		parts.append("%d %s" % [points[key], names[key]])
	return ", ".join(parts) if points.size() < 3 else "%d to every attribute" % points.values()[0]


static func parts_of(artifact_id: String) -> Array:
	for recipe in RECIPES:
		if recipe[0] == artifact_id:
			return recipe[1]
	return []


## Recipe text for the shop, e.g. "Titan's Belt + Tower Shield".
static func recipe_text(artifact_id: String) -> String:
	var names: Array[String] = []
	for part_id in parts_of(artifact_id):
		var part := find(part_id)
		names.append(part.display_name if part else part_id)
	return " + ".join(names)


static func find(item_id: String) -> ItemDef:
	for item in all():
		if item.id == item_id:
			return item
	return null


static func in_category(category: String) -> Array[ItemDef]:
	var result: Array[ItemDef] = []
	for item in all():
		if category == "All" or item.category == category:
			result.append(item)
	return result
