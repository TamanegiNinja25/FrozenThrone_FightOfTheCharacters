---
title: Phase 10 — terrain, monster models, the map's itemization and damage balance
date: 2026-11-18
type: design + implementation
decided-by: owner asked to revamp the map from Fight Of Characters 7.7b E with terrain, high and low ground; replace creep and monster models with itch.io-style monster models (checking the local Game Assets folder first); add item balancing, item recipes and damage balancing by revamping the itemization from the map; and make all of it mobile-friendly
---
# Phase 10 — terrain, monster models, the map's itemization and damage balance

## What the map read found
- **Terrain (from the map's terrain file):** a 97 × 65 tile grid with cliff layers 0–3.
  - A raised plateau of three joined circles across the middle.
  - A sunken pit to the north and a sunken rectangle to the south.
  - A water channel shaped like "[" around one base and "]" around the other.
- **Items (from the item tooltips and the shop triggers):**
  - Basic parts at 3,000 gold:
    - Belt: +25 strength.
    - Boots: +25 agility.
    - Healthstone: +1,000 HP.
    - Manastone.
    - Voodoo idol: a 50 damage-per-second aura.
  - Big parts:
    - Axe: +100 damage, 8,000 gold.
    - Attack stone: +100 damage, 8,500 gold.
    - Shield: +100 armour, 8,000 gold.
    - A speed part, 5,000 gold.
  - Third Eye (true sight): 500 gold.
- **Recipes (from the trigger code):** seven two-part recipes.
  - Belt + Shield
  - Belt + Axe
  - Boots + speed part
  - Voodoo + Boots
  - Healthstone + Manastone
  - Axe + Shield
  - Attack stone + Voodoo, a secret recipe that gives a reusable summon.
- **Signature items:** each hero's own item costs 10,000 gold for about 150 attribute points.
- **Other rules:**
  - The recall item is reusable on a 30 s cooldown.
  - The capture ball works on creeps at 30% health or less, and succeeds 30% of the time.
  - A silence stone silences for 5 s.

## What was built (original names, art and numbers)
### Terrain
- **Height map:** an analytic height function shared by the mesh, movement and tests.
  - The plateau is 1.5 high: three circles of radius 6.5 joined in a row.
  - The south basin sits at −1.2; the moats around the bases at −0.6.
- **Ramps:** six in all.
  - Four lead onto the plateau, one on each side.
  - Two lead into the basin.
- **Cliffs:** cliff edges are invisible walls, so ramps are the only way up or down.
- **Mesh:** the ground is one vertex-coloured mesh, smoothed at the cliff edges: grass on top, earth on the slopes, water in the moats.
- **Ground snapping:** heroes, creeps, projectiles and network-synced units follow the ground height. Props sit on it.
- **Uphill misses:** attacks from low ground at a target on high ground miss 25% of the time and show "miss", as in Warcraft III.

### Monster models
- **Sources:**
  - No usable monster pack was found in the local Game Assets folder; its RPG pack has no licence file, so it was not used.
  - Itch.io blocks automated downloads behind a bot check.
  - Monsters came instead from Quaternius's CC0 packs on OpenGameArt: 11 "Cute" monsters, plus a slime and a dragon from the low-poly pack.
  - The Cute pack's licence file was written from its OpenGameArt page (CC0).
  - Both packs are credited in the third-party `CREDITS.md` and on the in-game Credits screen.
- **Which units got models:**
  - Every neutral creep, room creature, boss stage, summon and the win boss now uses a monster model.
  - Each type gets a tint per unit; skeleton creeps reuse the existing skeleton bodies.
- **Animation clips:** found automatically by name (idle, walk/run, attack, death).
- **Performance:**
  - Materials are shared per texture and tint.
  - Animations pause when a unit is off screen.
  - Room spawns are spread over several frames.
- **Setting:** a "Creep models" option (Detailed/Simple) keeps the old shapes for weaker phones.

### Itemization
The shop was rebuilt around the map's structure, with original names.
- **Shops:** Items, Artifacts (recipes), Exclusive (signature), Stats (tomes), Utility, Relics, Consumables.
- **Items shop:**
  - Titan's Belt, Swiftstride Boots, Heartstone and Sage Stone: 3,000 gold each.
  - Warbreaker Axe: 8,000 gold. Seeing Stone: 8,500 gold.
  - Tower Shield: 8,000 gold.
  - Ember Idol, a 50/s burning aura: 3,000 gold.
  - Watcher's Eye, true sight: 500 gold.
  - Wind Charm: 5,000 gold.
- **Seven recipes** with the map's structure:

  | Recipe | Parts | Gives |
  |---|---|---|
  | Golden Bulwark | belt + shield | +25 strength, +200 armour |
  | Labyrinth Cleaver | belt + axe | +25 strength, +200 damage |
  | Galewalker Treads | boots + charm | +25 agility, +60% move speed |
  | Victor's Medal | idol + boots | +25 to all attributes, +25 regeneration |
  | Mystic Heartstone | heartstone + sage stone | +2,000 HP, +25 intelligence |
  | Emperor's Blade | axe + shield | +200 damage, +200 armour |
  | Titan Pact (secret) | seeing stone + idol | +25 to all attributes; reusable 60 s Bog Titan summon, 120 s cooldown |

- **Armour:** now in points, as in Warcraft III; agility still adds half a point each.
  - Damage reduction is 2% per point with diminishing returns, capped at 70%.
- **Utility items:**
  - Homeward Scroll: recall, reusable, 30 s cooldown.
  - Capture orb: needs ≤30% health and works 30% of the time, else "Escaped!". Reusable, 3 s cooldown.
  - Hushstone: silences the nearest enemy hero for 5 s; silenced heroes can't cast.
  - Shadow Cloak, Throwing Knives.
  - Wanderer's Hat, and Dread Fin with a 5% on-hit silence.
- **Signature items:** 24 items at 10,000 gold, all brought into one value band (see Damage balance).
- **Bots:** they buy a build for their role (bruiser, giant, speed, ranged, caster) and fuse recipes at the circle.
- **Icons and HUD:** 20 new item icons were generated. The HUD shows reusable items' cooldowns on their slots and "Silenced" in the status line.

### Damage balance
- **Measuring tool:** a new test measures balance on the real game code (`item_balance_test`):
  - **Gold efficiency at the map's own prices:**
    - An attribute point is worth 120 gold, HP 3, and damage and armour 80 per point.
    - Shop items must land at 0.75–1.35 value per gold.
    - Signature items must land at 1.2 or better, and within 1.2× of each other.
    - A recipe is never worth less than its parts.
  - **Time-to-kill** between equal heroes at levels 10, 20 and 30, each carrying the role build they could afford.
- **First measurement:** agility heroes killed an equal hero in 1–2 s and giants took 25–52 s.
- **Changes the measurements led to:**
  - Attack speed is 1% per agility point (the map's 2% let agility heroes hit five times a second). Bonuses past +100% count at 35%.
  - Damage from items and attributes is scaled to the hero's attack interval, so slow hitters aren't punished.
  - Intelligence adds 1.5% skill power per point (was 1%).
  - Signature items were evened out. Before, they ranged from ~1.6 to ~2.4 value per gold, and an armour-heavy one let one bruiser out-duel casters 2 : 1.
- **Results:**
  - Mirror fights last 2.6–13.5 s at every level.
  - Every hero holds its own against an equal bruiser:

    | Level | Duel ratio range |
    |---|---|
    | 10 | 0.76–1.02 |
    | 20 | 0.61–1.07 |
    | 30 | 0.87–1.26 |

    The level-20 low is the casters (Tamsin and Lys), whose skill scaling hasn't caught up with the bruiser's fused recipe yet.

### Mobile
- The terrain is a single mesh with no textures.
- Monster detail can be switched off.
- Off-screen animation is paused.
- **Phone measurement (Infinix NOTE 30, same profile, crowded map):**
  - During development, detailed monsters averaged about 44 FPS, the same as simple shapes. v0.9.0, before terrain, measured 49.6.
  - Final build, battery at 37–38 °C:

    | Creep models | Average FPS | Minimum | Peak units | With 250+ units (avg) | GPU frame |
    |---|---|---|---|---|---|
    | Detailed | 38.1 | 32 | 377 | 35 | 22.1 ms |
    | Simple | 41.9 | 35 | 316 | 36.1 | 19.8 ms |

  - No script errors. Readings move with phone temperature about as much as with the setting.
  - The terrain mesh and water already cast no shadows; the frame is GPU-bound.

## Tests
- `map_systems_test`: cliffs block, ramps lead up, the recipe fuses, and the satchel and evolution checks run with the new items.
- `shop_test`: new prices, armour points, refunds and the shop list.
- `item_balance_test`: new. The gold-efficiency and time-to-kill checks listed under Damage balance.
