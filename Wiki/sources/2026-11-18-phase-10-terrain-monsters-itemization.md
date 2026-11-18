---
type: source
raw: ../../RAW/2026-11-18-phase-10-terrain-monsters-itemization.md
added: 2026-11-18
why: Owner asked to revamp the map from Fight Of Characters 7.7b E with terrain and high/low ground, swap creep and monster models for monster packs, rebuild the itemization with the map's recipes, balance items and damage, and keep all of it mobile-friendly.
---
# Phase 10 — terrain, monster models, the map's itemization and damage balance
Record of Phase 10, built from the map's terrain and item data.
- **Terrain:** the arena gained the map's layout of high and low ground — a central plateau, a sunken basin and moats around the bases. Cliff walls and ramps shape the routes, and uphill attacks can miss.
- **Monsters:** creeps, room creatures, bosses and summons use CC0 Quaternius monster models.
- **Items:** the shop follows the map's item and recipe structure, with original names. A new balance test measures item value and time-to-kill on the real code.

## Key points
- **Map facts:**
  - **Terrain:** 97 × 65 tiles with cliff layers 0–3. A three-circle plateau sits in the middle, with a sunken pit to the north and a sunken rectangle to the south. Water channels shaped "[" and "]" wrap the bases.
  - **Items:**
    - 3,000-gold parts give +25 attribute or +1,000 HP; the voodoo idol has a 50/s aura.
    - The 8,000-gold axe and shield give +100 damage and +100 armour.
    - Seven two-part recipes, one of them a secret summon.
    - Signature items cost 10,000 gold for about 150 attribute points.
  - **Item rules:**
    - The recall item is reusable on a 30 s cooldown.
    - The capture ball needs ≤30% health and succeeds 30% of the time.
    - A silence stone silences for 5 s.
- **Terrain build:**
  - One analytic height function drives the mesh, movement and tests.
  - Plateau at 1.5, basin at −1.2, moats at −0.6.
  - Six ramps; cliff edges are invisible walls.
  - Units snap to the ground.
  - Attacks from low ground at high ground miss 25% of the time.
- **Monster models:**
  - The local Game Assets folder held no licensed monster pack, and itch.io blocks automated downloads.
  - Quaternius's CC0 Cute and low-poly monster packs came from OpenGameArt instead: 13 models in all.
  - Shared materials and off-screen animation pausing keep the cost down.
  - A "Creep models" setting switches back to simple shapes.
- **Itemization:**
  - The shops are Items, Artifacts, Exclusive, Stats, Utility, Relics and Consumables.
  - Seven recipes follow the map's structure (belt + shield, belt + axe, boots + charm, idol + boots, heartstone + sage stone, axe + shield, and the secret seeing stone + idol summon).
  - **Armour:** counted in points, capped at 70% reduction.
  - **New item effects:** reusable item cooldowns, silence, true sight and a burning aura.
  - **Bots:** they buy builds for their role.
- **Damage balance:** a new `item_balance_test` prices stats at the map's own rates.
  - **Price-band checks:**
    - shop items at 0.75–1.35 value per gold;
    - signature items at ≥1.2 and within 1.2× of each other;
    - recipes worth at least their parts.
  - **Time-to-kill:** measured between equal heroes at levels 10, 20 and 30.
  - **Changes it led to:**
    - agility gives 1% attack speed (the map gives 2%), with a soft cap past +100%;
    - damage scales with attack interval;
    - intelligence gives 1.5% skill power;
    - signature items were evened out.
  - **Results:**
    - mirror fights last 2.6–13.5 s;
    - duels against an equal bruiser range 0.61–1.26.
- **Phone (Infinix NOTE 30, crowded map):**
  - During development, detailed monsters ran at about 44 FPS, on a par with simple shapes. v0.9.0 ran at 49.6 before the terrain was added.
  - Final build, at 37–38 °C: detailed 38.1 average (35 with 250+ units), simple 41.9 (36.1). GPU-bound at 20–22 ms; readings shift with temperature.

## Topics
- [Fight Of Characters](../topics/fight-of-characters.md) — terrain and item facts
- [Art direction](../topics/art-direction.md) — terrain and monster models
- [Assets and licensing](../topics/assets-and-licensing.md) — Quaternius monster packs
- [Roster](../topics/roster.md) — damage balance

## Open questions
- Does the uphill miss chance feel fair on a phone, where high ground is hard to read from the camera?
- Thermal behaviour over a full match with detailed monsters.
