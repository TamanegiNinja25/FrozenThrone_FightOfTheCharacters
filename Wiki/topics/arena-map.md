---
type: topic
category: Game design
sources: [2026-11-08-ui-polish-and-phase-2, 2026-11-08-phase-6-map-systems, 2026-11-09-phase-7-feel-heroes-original-rules, 2026-11-10-phase-9-map-gaps-and-24-heroes, 2026-11-18-phase-10-terrain-monsters-itemization, 2026-11-19-v0.10.1-phone-performance, 2026-11-19-phase-11-title-icon-and-remaining-gaps, 2026-11-19-v0.12.0-items-icons-rims]
updated: 2026-11-19
---
# Arena map
The original battlefield FZFoC Mobile plays on. It has the macro structure of Fight Of Characters' map — bases at either end, neutral camps, high and low ground, private creep rooms and an off-field duel arena — in its own shapes.

## Layout
- **Bases:** two bases with healing fountains and a central lane between them. The first arena also had pillars and neutral camps ([src](../sources/2026-11-08-ui-polish-and-phase-2.md)).
- **Creep camps:** the map's 12, spawning waves every 30, 60 and 90 s ([src](../sources/2026-11-08-phase-6-map-systems.md)).
  - Four camps were moved away from the bases after creep piles reached the fountains in a phone test ([src](../sources/2026-11-09-phase-7-feel-heroes-original-rules.md)).
- **Combining circles:** recipes fuse at a circle by each base ([src](../sources/2026-11-08-phase-6-map-systems.md)).
- **Creep rooms:** four private rooms south of the field, reached by teleport pads. Entering spawns the room's creeps, at most 20 of a type ([src](../sources/2026-11-10-phase-9-map-gaps-and-24-heroes.md)).
- **Duel arena:** off the field; the duel freezes everyone else ([src](../sources/2026-11-08-phase-6-map-systems.md)).

## High and low ground (Phase 10–11)
- **Map read:** the map's terrain is 97 × 65 tiles with cliff layers 0–3. A three-circle plateau sits in the middle, sunken ground lies north and south, and water channels wrap the bases ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).
- **What was built:**
  - a central plateau (+1.5) of three joined circles with four ramps;
  - a sunken basin to the south (−1.2) where the boss chains wait, with two ramps;
  - moats either side of each base ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).
- **The north pit:** a second sunken pit north of the plateau, where the win boss waits, reached by two ramps. It completes the map's north/south low ground ([src](../sources/2026-11-19-phase-11-title-icon-and-remaining-gaps.md)).
- **Cliffs:** cliff edges are invisible walls, so ramps are the only way between levels ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)).
- **Uphill rule:** attacks from low ground at a target on high ground miss 25% of the time, as in Warcraft III ([src](../sources/2026-11-18-phase-10-terrain-monsters-itemization.md)). Since Phase 11 the status line warns "▲ Uphill — 25% miss" while the target stands higher ([src](../sources/2026-11-19-phase-11-title-icon-and-remaining-gaps.md)).
- **Cliff rims:** since v0.12.0 a pale rim runs along every cliff top and pit edge, on the high side, so high ground reads from the camera ([src](../sources/2026-11-19-v0.12.0-items-icons-rims.md)).

## Phone cost
- **The ground:** one vertex-coloured mesh in 2 × 2 m blocks; flat blocks are a single quad ([src](../sources/2026-11-19-v0.10.1-phone-performance.md)). See [Art direction](art-direction.md#v0101-shadows-not-the-ground).

## Related
- [Fight Of Characters](fight-of-characters.md) — the reference map's systems
- [Art direction](art-direction.md) — terrain look and phone cost
- [Bot AI](bot-ai.md) — how bots use rooms and circles
- [Hero arena genre](hero-arena-genre.md)
