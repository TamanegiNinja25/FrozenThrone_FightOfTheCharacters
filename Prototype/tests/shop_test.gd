extends SceneTree
## Headless check of the item shop:
##   Godot_v4.7.2-stable_win64_console.exe --headless --path Prototype -s res://tests/shop_test.gd
## Catalogue and categories, buying rules, stat effects, selling, consumables,
## and bots shopping on their own in the arena. (Matches typed as Node: naming
## their classes here would compile them before autoloads exist.)

var _scene: Node
var _hero: Hero
var _frames := 0
var _phase := "boot"
var _sim := 0.0
var _failures: Array[String] = []


func _initialize() -> void:
	_scene = load("res://scenes/main.tscn").instantiate()
	root.add_child(_scene)
	current_scene = _scene


func _process(delta: float) -> bool:
	_frames += 1
	_sim += delta
	match _phase:
		"boot":
			if _frames < 5:
				return false
			_hero = _scene.hero
			_catalogue()
			_buying()
			_effects()
			_consumables()
			_phase = "heal"
			_frames = 0
		"heal":
			if _frames == 1:
				_hero.hp = 300.0
				_hero.gold = 1000.0
				_hero.buy("ember_draught")
				_hero.use_item(_hero.items.size() - 1)
			if _sim > 0.0 and _frames > 2:
				pass
			if _frames > 400:  # ~6.7 s at 60 fps: the full 5 s heal-over-time
				_check(_hero.hp >= 690.0, "Ember Draught heals ~400 over 5 s (300 → %d)" % _hero.hp)
				_start_arena()
		"arena":
			var bots: Array = _scene.bots
			var shopped := bots.filter(func(b): return b.hero.items.size() > 0).size()
			if shopped >= 2:
				_check(true, "bots shop on their own (%d of 5 bought items by %.0f s)" % [shopped, _sim])
				_finish()
			elif _sim > 300.0:
				_check(false, "bots bought items within 300 s (only %d did)" % shopped)
				_finish()
	return false


func _catalogue() -> void:
	var items := ItemCatalog.all()
	var categories := {}
	for item in items:
		categories[item.category] = categories.get(item.category, 0) + 1
		_check(item.icon() != null, "icon exists for %s" % item.id) if item.icon() == null else null
	_check(categories.keys().size() == ItemCatalog.CATEGORIES.size() and categories.values().all(func(n): return n >= 2),
			"%d shops, each with ≥2 items: %s" % [ItemCatalog.CATEGORIES.size(), str(categories)])
	_check(categories.Items == 14 and categories.Stats == 7 and categories.Exclusive == 24 and categories.Artifacts == 15,
			"the shops: 14 items, 7 tomes, 24 signature items (one per hero), 15 recipes (the map's 7 plus 8)")
	_check(ItemCatalog.in_category("Relics").size() == 3, "category filter works (3 relics, with the satchel)")


func _buying() -> void:
	_hero.gold = 0.0
	_check(_hero.buy("warbreaker_axe") == "Not enough gold", "can't buy without gold")
	_hero.gold = 10000.0
	_hero.in_shop_range = false
	_check(_hero.buy("warbreaker_axe") == "Return to your fountain to shop", "can't buy away from the fountain")
	_hero.in_shop_range = true
	var base_damage := _hero.attack_damage
	_check(_hero.buy("warbreaker_axe") == "" and is_equal_approx(_hero.gold, 2000.0), "buying spends gold (10000 → 2000)")
	_check(is_equal_approx(_hero.attack_damage, base_damage + 100.0), "Warbreaker Axe adds 100 damage (the map's Axe)")
	_check(_hero.sell(0) and is_equal_approx(_hero.gold, 8000.0) and is_equal_approx(_hero.attack_damage, base_damage),
			"selling refunds 75% (2000 → 8000) and removes the bonus")
	_hero.gold = 99999.0
	for i in 6:
		_hero.buy("swift_boots")
	_check(_hero.buy("heartstone") == "Inventory full", "inventory caps at 6")
	while _hero.items.size() > 0:
		_hero.sell(0)


func _effects() -> void:
	_hero.gold = 99999.0
	var base_hp := _hero.max_hp
	var base_interval := _hero.attack_interval
	var base_reduction := _hero.damage_reduction
	_hero.buy("heartstone")
	_hero.buy("swift_boots")
	_hero.buy("tower_shield")
	_hero.buy("kindling_rune")
	_hero.buy("sage_stone")
	_check(is_equal_approx(_hero.max_hp, base_hp + 1000.0), "Heartstone: +1,000 max HP (the map's Healthstone)")
	var agi_before: float = _hero.attribute_gained("agi") - 25.0
	var expected: float = base_interval * (1.0 + Hero.AGI_ATTACK_SPEED * agi_before) / (1.0 + Hero.AGI_ATTACK_SPEED * _hero.attribute_gained("agi"))
	_check(is_equal_approx(_hero.attack_interval, expected) and _hero.attack_interval < base_interval,
			"Swiftstride Boots: +25 agility, 1%% faster attacks per point (%.2f → %.2f s)" % [base_interval, _hero.attack_interval])
	var armour := 0.5 * _hero.attribute_gained("agi") + 100.0
	_check(is_equal_approx(_hero.damage_reduction, 0.02 * armour / (1.0 + 0.02 * armour)) and _hero.damage_reduction > base_reduction + 0.5,
			"Tower Shield: +100 armour points on top of agility armour (%.0f%% less damage)" % (_hero.damage_reduction * 100.0))
	_hero.meter.charge = 0.0
	_hero.meter._add(10.0)
	_check(is_equal_approx(_hero.meter.charge, 12.5), "Kindling Rune: meter gains ×1.25")
	_hero.meter.charge = 0.0
	_hero.skills[0].time_left = 0.0
	_hero.skills[0].rank = 1
	_hero.try_skill(0)
	_check(is_equal_approx(_hero.skills[0].time_left, 6.0 * 0.95), "Sage Stone: slam cooldown 6 → 5.7 s")
	while _hero.items.size() > 0:
		_hero.sell(0)


func _consumables() -> void:
	_hero.gold = 10000.0
	_hero.buy("spark_flask")
	_hero.meter.charge = 0.0
	_check(_hero.use_item(0) and is_equal_approx(_hero.meter.charge, 25.0) and _hero.items.is_empty(),
			"Spark Flask: +25 meter, then it's gone")
	_hero.buy("warbreaker_axe")
	_check(not _hero.use_item(0), "non-consumables can't be 'used'")
	_hero.sell(0)


func _start_arena() -> void:
	_scene.queue_free()
	_scene = load("res://scenes/arena.tscn").instantiate()
	root.add_child(_scene)
	current_scene = _scene
	Engine.max_physics_steps_per_frame = 64
	Engine.time_scale = 8.0
	_sim = 0.0
	_phase = "arena"
	# Items now cost thousands; give the bots a purse so the test sees them shop.
	for brain in _scene.bots:
		brain.hero.gold = 12000.0


func _finish() -> void:
	for failure in _failures:
		printerr("FAIL: " + failure)
	print("SHOP TEST %s (%d checks failed)" % ["PASSED" if _failures.is_empty() else "FAILED", _failures.size()])
	Engine.time_scale = 1.0
	paused = false
	quit(1 if _failures.size() else 0)


func _check(ok: bool, what: String) -> void:
	if ok:
		print("ok   " + what)
	else:
		_failures.append(what)
