---
type: topic
category: Game design
sources: [2026-11-08-ui-polish-and-phase-2, 2026-11-08-phase-3-item-shop, 2026-11-08-phase-5-heroes-and-music, 2026-11-10-phase-9-map-gaps-and-24-heroes, 2026-11-18-phase-10-terrain-monsters-itemization, 2026-11-19-phase-11-title-icon-and-remaining-gaps, 2026-11-19-v0.11.3-agility-bruiser-builds]
updated: 2026-11-19
---
# Bot AI
How FZFoC Mobile's bots play. They use the same controls as a player. Only their decision skill adapts to the score; their stats never change. Over the phases they learned to shop, farm creep rooms, build recipes and use items.

## Adaptive skill
- **One "skill" value changes only decisions** ([src](../sources/2026-11-08-ui-polish-and-phase-2.md)):
  - reaction time 0.7 → 0.15 s;
  - retreat threshold 0 → 38% HP;
  - nearest vs weakest target;
  - accuracy 30 → 95%;
  - form timing and dash finishing.
- **Scaling:** enemy skill is 0.5 + 0.1 per kill of the player team's lead (0.15–0.95); allies stay at 0.55 ([src](../sources/2026-11-08-ui-polish-and-phase-2.md)).
- **Skills:** each skill says when it's worth casting, so bots play any hero without hero-specific AI ([src](../sources/2026-11-08-phase-5-heroes-and-music.md)).

## Shopping
- **Phase 3:** one fixed build order at the fountain ([src](../sources/2026-11-08-phase-3-item-shop.md)).
- **Phase 10:** a build per role (bruiser, giant, speed, ranged, caster), with recipes fused at the circle ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).
- **Phase 11** ([src](../sources/2026-11-19-phase-11-title-icon-and-remaining-gaps.md)):
  - builds include utility items by role: the recall scroll for the front line, the cloak for divers, the Hushstone against casters, and the Titan Pact recipe for casters;
  - bots buy true sight once an enemy carries a cloak, and a potion when gold is spare;
  - like players, bots shop while dead.
- **v0.11.3:** builds also follow the main attribute. Agility Bruisers (Kael, Corin) had been bought strength items, which don't add to their attack damage. They now get boots, Victor's Medal and the Labyrinth Cleaver, and Corin's damage per minute more than doubled ([src](../sources/2026-11-19-v0.11.3-agility-bruiser-builds.md)).

## Item use (Phase 11)
Bots use each item by situation ([src](../sources/2026-11-19-phase-11-title-icon-and-remaining-gaps.md)):

| Item | When |
|---|---|
| Potion | below 45% health |
| Throwing knives | to finish a low enemy hero |
| Hushstone | on an enemy hero about to fight back |
| Bog Titan | in a hero fight |
| Shadow Cloak | when retreating hurt with an enemy hero close |
| Recall scroll | when retreating far from base with no enemy hero near |
| Capture orb | on weakened creeps (since Phase 9) |

## The map's world
- **Creep rooms:** bots farm them when the field is quiet, and draw from the whole roster each match ([src](../sources/2026-11-10-phase-9-map-gaps-and-24-heroes.md)).

## Related
- [Itemization](itemization.md)
- [Arena map](arena-map.md)
- [Roster](roster.md)
- [Hero arena genre](hero-arena-genre.md)
