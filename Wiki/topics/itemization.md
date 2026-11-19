---
type: topic
category: Game design
sources: [2026-11-08-phase-3-item-shop, 2026-11-08-phase-6-map-systems, 2026-11-09-phase-7-feel-heroes-original-rules, 2026-11-10-phase-9-map-gaps-and-24-heroes, 2026-11-18-phase-10-terrain-monsters-itemization, 2026-11-19-phase-11-title-icon-and-remaining-gaps]
updated: 2026-11-19
---
# Itemization
How items work in Fight Of Characters and in FZFoC Mobile's original version. The shop follows the map's structure: cheap parts, two-part recipes, a signature item per hero, tomes and utility items. It uses original names and a balance test priced at the map's own rates.

## History
- **Phase 3:** 13 original items in five categories (100–900 gold), sold at 50%. Relics tie items to the transformation meter ([src](../sources/2026-11-08-phase-3-item-shop.md)).
- **Phase 6:** gold moved to the map's scale (×10), with 7 tomes, exclusive items and 7 recipes at a combining circle ([src](../sources/2026-11-08-phase-6-map-systems.md)).
- **Phase 7:** utility items after the map's mixed shop (recall scroll, throwing knives, shadow cloak, capture orb), and an exclusive item for every hero ([src](../sources/2026-11-09-phase-7-feel-heroes-original-rules.md)).
- **Phase 9:** the storage satchel, lasting capture, the recall point and potion stacking ([src](../sources/2026-11-10-phase-9-map-gaps-and-24-heroes.md)).
- **Phase 10:** the shop was rebuilt on the map's item and recipe structure ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).

## The map's structure (Phase 10)
- **Parts at 3,000 gold:** +25 to an attribute, +1,000 HP, or an aura idol that burns for 50 a second ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).
- **Big parts:** +100 damage or +100 armour at 8,000–8,500 gold; a speed part at 5,000; true sight at 500 ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).
- **Seven two-part recipes:** belt + shield, belt + axe, boots + speed part, idol + boots, health + mana stone, axe + shield, and a secret one that gives a reusable summon ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).
- **Signature items:** 10,000 gold for about 150 attribute points, one per hero ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).
- **Item rules:** reusable recall (30 s), the capture ball (≤30% health, 30% success) and a 5 s silence stone ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).

## The game's version
- **Shops:** Items, Artifacts (recipes), Exclusive, Stats (tomes), Utility, Relics and Consumables. Original names, such as the Golden Bulwark for belt + shield ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).
- **Armour in points:** agility gives half a point each. Reduction has diminishing returns and is capped at 70% ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).
- **New effects:** reusable items with cooldowns, silence (no skills), true sight, a burning aura, and a reusable Bog Titan summon ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).
- **Shopping while dead:** a dead hero can shop anywhere while waiting to respawn; otherwise heroes shop at their fountain ([src](../sources/2026-11-19-phase-11-title-icon-and-remaining-gaps.md)).

## Balance model
- **Pricing at the map's rates:** a test prices every stat at the map's own costs: an attribute point 120 gold, an HP point 3, a damage or armour point 80 ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).
- **Its rules:**
  - shop items buy 0.75–1.35 of their value;
  - signature items are the best value and within 1.2× of each other;
  - no recipe is worth less than its parts ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).
- **Uneven signature items:** before they were evened out, they ranged from ~1.6 to ~2.4 value per gold, and one armour-heavy item let a bruiser out-duel casters 2 : 1 ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).

## Bots
- **Builds:** bots buy a build for their role, fuse recipes at the circle ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)), and use utility items by situation — see [Bot AI](bot-ai.md).

## Related
- [Fight Of Characters](fight-of-characters.md) — the map's systems
- [Bot AI](bot-ai.md)
- [Roster](roster.md) — signature items and damage balance
- [Hero transformations](hero-transformations.md) — relics tie items to the meter
