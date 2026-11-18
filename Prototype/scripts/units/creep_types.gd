class_name CreepTypes
extends RefCounted
## Every non-hero unit: the 15 creep types of the reference map's waves (its
## HP, gold and levels, under original names and looks), the two boss chains,
## the win boss and summons. A unit is rebuilt from its key on network clients.
##
## Fields: name, level, hp, damage, interval, range, bounty, size, color, shape
## ("brute", "caster", "beast", "golem").

const TYPES := {
	# 30 s wave (map: gnoll, gnoll poacher, spider, spitting spider)
	"ngno": {"name": "Mire Scavenger", "level": 1, "hp": 250, "damage": 14, "interval": 1.4, "range": 1.8, "bounty": 25, "size": 0.8, "color": Color(0.55, 0.45, 0.3), "shape": "brute"},
	"ngna": {"name": "Mire Slinger", "level": 1, "hp": 200, "damage": 11, "interval": 1.6, "range": 6.0, "bounty": 20, "size": 0.75, "color": Color(0.5, 0.5, 0.32), "shape": "caster"},
	"nspr": {"name": "Ash Crawler", "level": 1, "hp": 100, "damage": 8, "interval": 1.2, "range": 1.6, "bounty": 10, "size": 0.6, "color": Color(0.35, 0.33, 0.35), "shape": "beast"},
	"nssp": {"name": "Spitting Crawler", "level": 2, "hp": 200, "damage": 14, "interval": 1.5, "range": 5.5, "bounty": 20, "size": 0.75, "color": Color(0.4, 0.5, 0.35), "shape": "beast"},
	# 60 s wave (map: bandit, bandit lord, priest, rogue wizard, mud golem, footman, knight)
	"nban": {"name": "Road Brigand", "level": 2, "hp": 500, "damage": 18, "interval": 1.4, "range": 1.8, "bounty": 50, "size": 0.85, "color": Color(0.45, 0.35, 0.28), "shape": "brute"},
	"nbld": {"name": "Brigand Chief", "level": 4, "hp": 1500, "damage": 40, "interval": 1.4, "range": 2.0, "bounty": 100, "size": 1.1, "color": Color(0.6, 0.3, 0.22), "shape": "brute"},
	"hmpr": {"name": "Hedge Mystic", "level": 2, "hp": 400, "damage": 10, "interval": 1.8, "range": 6.0, "bounty": 50, "size": 0.8, "color": Color(0.75, 0.72, 0.6), "shape": "caster"},
	"nwzr": {"name": "Rogue Conjurer", "level": 4, "hp": 1000, "damage": 30, "interval": 1.8, "range": 6.5, "bounty": 100, "size": 0.9, "color": Color(0.45, 0.3, 0.6), "shape": "caster"},
	"ngrk": {"name": "Silt Golem", "level": 3, "hp": 500, "damage": 20, "interval": 1.6, "range": 1.8, "bounty": 75, "size": 0.95, "color": Color(0.45, 0.4, 0.32), "shape": "golem"},
	"hfoo": {"name": "Deserter", "level": 2, "hp": 400, "damage": 16, "interval": 1.4, "range": 1.8, "bounty": 50, "size": 0.85, "color": Color(0.5, 0.52, 0.56), "shape": "brute"},
	"hkni": {"name": "Fallen Knight", "level": 4, "hp": 1000, "damage": 38, "interval": 1.5, "range": 2.0, "bounty": 100, "size": 1.05, "color": Color(0.35, 0.38, 0.45), "shape": "brute"},
	# 90 s wave (map: tauren, necromancer, rock golem, druid of the claw)
	"otau": {"name": "Horned Brute", "level": 8, "hp": 2500, "damage": 70, "interval": 1.7, "range": 2.2, "bounty": 200, "size": 1.35, "color": Color(0.5, 0.36, 0.25), "shape": "brute"},
	"unec": {"name": "Bone Caller", "level": 6, "hp": 2000, "damage": 40, "interval": 1.8, "range": 6.5, "bounty": 200, "size": 0.95, "color": Color(0.7, 0.7, 0.62), "shape": "caster"},
	"ngst": {"name": "Crag Golem", "level": 5, "hp": 1000, "damage": 45, "interval": 1.8, "range": 2.0, "bounty": 150, "size": 1.2, "color": Color(0.5, 0.48, 0.45), "shape": "golem"},
	"edoc": {"name": "Wildclaw Shaman", "level": 7, "hp": 3000, "damage": 60, "interval": 1.5, "range": 2.0, "bounty": 200, "size": 1.25, "color": Color(0.32, 0.45, 0.3), "shape": "beast"},
}

## Private creep rooms (CreepRooms): the map's room units — levels and HP from
## the map, damage on this game's scale, original names.
const ROOM_TYPES := {
	"room_whelp": {"name": "Cinder Whelp", "level": 5, "hp": 1000, "damage": 45, "interval": 1.5, "range": 1.8, "bounty": 120, "size": 0.9, "color": Color(0.85, 0.4, 0.2), "shape": "beast"},
	"room_hound": {"name": "Scorch Hound", "level": 7, "hp": 1300, "damage": 60, "interval": 1.2, "range": 1.8, "bounty": 170, "size": 1.0, "color": Color(0.75, 0.3, 0.15), "shape": "beast"},
	"room_hound2": {"name": "Ash Stalker", "level": 7, "hp": 1300, "damage": 60, "interval": 1.2, "range": 1.8, "bounty": 170, "size": 1.0, "color": Color(0.45, 0.4, 0.4), "shape": "beast"},
	"room_wraith": {"name": "Flame Wraith", "level": 10, "hp": 1500, "damage": 80, "interval": 1.0, "range": 5.5, "bounty": 250, "size": 1.0, "color": Color(1.0, 0.55, 0.25), "shape": "caster"},
	"room_fiend": {"name": "Ember Fiend", "level": 10, "hp": 1500, "damage": 80, "interval": 1.0, "range": 2.0, "bounty": 250, "size": 1.05, "color": Color(0.95, 0.35, 0.15), "shape": "golem"},
	"room_warden": {"name": "Dread Warden", "level": 15, "hp": 5000, "damage": 130, "interval": 1.5, "range": 2.2, "bounty": 500, "size": 1.35, "color": Color(0.45, 0.3, 0.55), "shape": "brute"},
	"room_revenant": {"name": "Elder Revenant", "level": 20, "hp": 10000, "damage": 220, "interval": 0.8, "range": 2.2, "bounty": 900, "size": 1.5, "color": Color(0.7, 0.72, 0.65), "shape": "brute"},
}

## Boss chains: the reference map's HP per stage; the next boss appears 10 s
## after the last one falls. Names are original.
const CHAINS := {
	"a": {"hp": [500, 2000, 3500, 5000, 6500, 8000, 9500, 11000, 12500],
		"names": ["Gravel Hound", "Cinder Imp", "Thorn Matron", "Rust Colossus", "Murk Stalker", "Ember Drake", "Frost Revenant", "Storm Herald", "The Iron Tyrant"]},
	"b": {"hp": [500, 3500, 4500, 6000, 7500, 10000, 12500],
		"names": ["Bog Lurker", "Barrow Wight", "Briar Witch", "Dune Reaver", "Ash Titan", "Night Weaver", "The Pale Sovereign"]},
}

## The win boss: 100,000 HP, as in the reference map; killing it wins the match.
const COLOSSUS := {"name": "The Undying Colossus", "level": 20, "hp": 100000, "damage": 160, "interval": 2.0, "range": 3.2,
	"bounty": 0, "size": 2.6, "color": Color(0.42, 0.36, 0.5), "shape": "golem", "slam": [6.0, 220.0, 7.0, 1.5]}

const SUMMONS := {
	"golem": {"name": "Forge Golem", "level": 4, "hp": 900, "damage": 45, "interval": 1.2, "range": 2.0, "bounty": 50, "size": 1.0, "color": Color(0.9, 0.45, 0.15), "shape": "golem"},
	"wisp": {"name": "Grave Wisp", "level": 2, "hp": 380, "damage": 24, "interval": 1.1, "range": 5.0, "bounty": 25, "size": 0.6, "color": Color(0.55, 1.0, 0.7), "shape": "caster"},
	"skeleton": {"name": "Barrow-Dead", "level": 3, "hp": 650, "damage": 38, "interval": 1.2, "range": 1.9, "bounty": 30, "size": 0.85, "color": Color(0.82, 0.8, 0.7), "shape": "brute"},
	"rune": {"name": "Rune Guardian", "level": 4, "hp": 850, "damage": 42, "interval": 1.3, "range": 2.0, "bounty": 40, "size": 1.0, "color": Color(0.6, 0.65, 0.75), "shape": "golem"},
	"bog": {"name": "Bog Spawn", "level": 3, "hp": 520, "damage": 30, "interval": 1.2, "range": 1.8, "bounty": 30, "size": 0.8, "color": Color(0.4, 0.6, 0.3), "shape": "beast"},
	"titan": {"name": "Bog Titan", "level": 8, "hp": 3000, "damage": 120, "interval": 1.4, "range": 2.4, "bounty": 100, "size": 1.5, "color": Color(0.45, 0.6, 0.35), "shape": "golem"},
	"captured": {"name": "Captured creep", "level": 3, "hp": 800, "damage": 30, "interval": 1.4, "range": 2.0, "bounty": 30, "size": 0.9, "color": Color(0.7, 0.6, 1.0), "shape": "beast"},
}


## Stats for a key: a creep id, "boss:a:3", "colossus" or "summon:golem".
## Monster models (Quaternius CC0, KayKit skeletons CC0 — see CREDITS.md):
## name → [scene, the model's own height, texture ("" = its own colours)].
const MQ := "res://assets/thirdparty/quaternius/monsters/"
const MODELS := {
	"crab": [MQ + "cute/FBX/Crab.fbx", 1.57, MQ + "cute/Textures/Crab_Texture.png"],
	"cactus": [MQ + "cute/FBX/Cactus.fbx", 2.62, MQ + "cute/Textures/Cactus_Texture.png"],
	"ghost": [MQ + "cute/FBX/Ghost.fbx", 1.4, MQ + "cute/Textures/Ghost_Texture.png"],
	"tree": [MQ + "cute/FBX/Tree.fbx", 2.85, MQ + "cute/Textures/Tree_Texture.png"],
	"yeti": [MQ + "cute/FBX/Yeti.fbx", 1.67, MQ + "cute/Textures/Yeti_Texture.png"],
	"skull": [MQ + "cute/FBX/Skull.fbx", 1.55, MQ + "cute/Textures/Skull_Texture.png"],
	"cyclops": [MQ + "cute/FBX/Cyclops.fbx", 1.67, MQ + "cute/Textures/Cyclops_Texture.png"],
	"green_demon": [MQ + "cute/FBX/GreenDemon.fbx", 1.62, MQ + "cute/Textures/GreenDemon_Texture.png"],
	"demon": [MQ + "cute/FBX/Demon.fbx", 1.62, MQ + "cute/Textures/Demon_Texture.png"],
	"bat": [MQ + "cute/FBX/Bat.fbx", 1.75, MQ + "cute/Textures/Bat_Texture.png"],
	"yellow_dragon": [MQ + "cute/FBX/YellowDragon.fbx", 1.65, MQ + "cute/Textures/YellowDragon_Texture.png"],
	"slime": [MQ + "lowpoly/Slime.fbx", 1.95, ""],
	"dragon": [MQ + "lowpoly/Dragon.fbx", 4.78, ""],
}
const SKELETONS := "res://assets/thirdparty/kaykit/characters/"
## Which model each unit wears: key → [model, tint]. Skeleton names are KayKit bodies.
const LOOKS := {
	"ngno": ["green_demon", Color(0.85, 1.0, 0.8)], "ngna": ["cactus", Color.WHITE], "nspr": ["crab", Color(0.75, 0.7, 0.7)],
	"nssp": ["slime", Color(0.75, 1.0, 0.7)], "nban": ["skel:Skeleton_Rogue", Color(0.85, 0.72, 0.6)],
	"nbld": ["skel:Skeleton_Warrior", Color(1.0, 0.7, 0.62)], "hmpr": ["ghost", Color.WHITE],
	"nwzr": ["skel:Skeleton_Mage", Color(0.85, 0.72, 1.0)], "ngrk": ["tree", Color(0.85, 0.8, 0.7)],
	"hfoo": ["skel:Skeleton_Minion", Color(0.85, 0.85, 0.8)], "hkni": ["skel:Skeleton_Warrior", Color(0.75, 0.8, 0.95)],
	"otau": ["yeti", Color.WHITE], "unec": ["skull", Color.WHITE], "ngst": ["cyclops", Color.WHITE], "edoc": ["demon", Color.WHITE],
	"room_whelp": ["bat", Color(1.0, 0.75, 0.6)], "room_hound": ["yellow_dragon", Color(1.0, 0.7, 0.55)],
	"room_hound2": ["crab", Color(0.6, 0.55, 0.55)], "room_wraith": ["ghost", Color(1.0, 0.75, 0.55)],
	"room_fiend": ["demon", Color(1.0, 0.7, 0.6)], "room_warden": ["cyclops", Color(0.8, 0.7, 1.0)],
	"room_revenant": ["yeti", Color(0.85, 0.85, 1.0)],
	"summon:wisp": ["ghost", Color(0.65, 1.0, 0.75)], "summon:bog": ["slime", Color(0.6, 0.95, 0.5)],
	"summon:rune": ["tree", Color(0.75, 0.8, 0.95)], "summon:titan": ["yeti", Color(0.6, 0.85, 0.5)],
	"colossus": ["dragon", Color(0.8, 0.75, 0.9)],
}
## Boss chains: one monster per stage, growing as the chain climbs.
const BOSS_LOOKS := {
	"a": ["crab", "green_demon", "tree", "cyclops", "skull", "yellow_dragon", "ghost", "yeti", "dragon"],
	"b": ["slime", "skull", "cactus", "demon", "cyclops", "yeti", "dragon"],
}


## The model a unit wears: {model, tint} or {} for the simple shapes.
static func look_of(key: String) -> Dictionary:
	if key.begins_with("boss:"):
		var chain := key.get_slice(":", 1)
		var stage := int(key.get_slice(":", 2))
		return {"model": BOSS_LOOKS[chain][mini(stage, BOSS_LOOKS[chain].size() - 1)], "tint": Color.WHITE}
	if LOOKS.has(key):
		return {"model": LOOKS[key][0], "tint": LOOKS[key][1]}
	return {}


static func lookup(key: String) -> Dictionary:
	if TYPES.has(key):
		return TYPES[key]
	if ROOM_TYPES.has(key):
		return ROOM_TYPES[key]
	if key == "colossus":
		return COLOSSUS
	if key.begins_with("summon:"):
		return SUMMONS.get(key.get_slice(":", 1), SUMMONS.golem)
	if key.begins_with("boss:"):
		var chain: Dictionary = CHAINS[key.get_slice(":", 1)]
		var stage := int(key.get_slice(":", 2))
		var hp: int = chain.hp[stage]
		# Bosses hit harder each stage and slam the ground around them.
		return {"name": chain.names[stage], "level": 3 + stage * 2, "hp": hp, "damage": 30 + stage * 14, "interval": 1.6,
			"range": 2.4, "bounty": 500 + stage * 300, "size": 1.3 + stage * 0.08,
			"color": Color.from_hsv(fmod(0.08 + stage * 0.11, 1.0), 0.55, 0.6), "shape": ["brute", "beast", "golem", "caster"][stage % 4],
			"slam": [3.5 + stage * 0.15, 40.0 + stage * 25.0, 8.0, 1.0]}
	return TYPES.ngno
