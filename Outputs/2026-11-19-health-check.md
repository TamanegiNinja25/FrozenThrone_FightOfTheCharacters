# Wiki health check — 2026-11-19

The wiki's first full health check (workflow 5). It covered 9 topic articles, 27 source notes, the index, the log and the backlog.

## Contradictions
1. **Mobile passive income: 2 or 20 gold a second.**
   - [Hero arena genre](../Wiki/topics/hero-arena-genre.md) gives 2 gold/s with a +2 spree step, from the 2026-11-08 economy decision.
   - Phase 6 (commit `6a96f13`) scaled the whole economy by ten to the reference map's thousands-scale prices: 20 gold/s, kill gold 1,000, spree step +20.
   - No RAW record stated the new values.
   - **Fixed:** the Phase 11 record now states them, and the article was updated with both values and their dates.
2. **Visual style: "high-poly stylized" vs the low-poly models in use.**
   - [Art direction](../Wiki/topics/art-direction.md) records the owner's decision for high-poly stylized.
   - Every model in the game is a low-poly CC0 pack.
   - This is already flagged in the article. It needs the owner's decision (see backlog).
3. **"One 3D creator."**
   - [Assets and licensing](../Wiki/topics/assets-and-licensing.md) claimed all art came from one 3D creator plus one UI and sound creator.
   - The game now uses two 3D creators (KayKit, Quaternius) and a font.
   - **Fixed.**

## Mentioned but never explained (no topic article)
- **Itemization:** shops, parts, recipes, armour points and reusable items. It's spread across [Fight Of Characters](../Wiki/topics/fight-of-characters.md) and four source notes.
- **The arena map:** terrain, camps, basins, creep rooms, duel arena and circles. It appears only in source notes.
- **Bot AI:** adaptive skill, role builds, item use, creep rooms and shopping while dead. It's spread across five source notes.
- The duel, creep waves and boss chains are covered only as list items in [Fight Of Characters](../Wiki/topics/fight-of-characters.md#systems).

## Claims without a RAW source
- 21 claims are marked *(inference)* across 8 articles. The backlog's "Unsourced claims" list covers the long-standing ones.
- New since the last list:
  - Quaternius and KayKit read as one low-poly family; cute monsters suit the heroes ([Art direction](../Wiki/topics/art-direction.md)).
  - Halving the frame's work keeps the phone below its GPU slowdown point ([Art direction](../Wiki/topics/art-direction.md)). Only a full-match measurement can back this; one was run for Phase 11.
  - Three kinds of form each mirror the map ([Hero transformations](../Wiki/topics/hero-transformations.md)).
  - The scoreboard and callouts add information density on a small screen ([Hero arena genre](../Wiki/topics/hero-arena-genre.md)).
- There are no *(web)* claims in the wiki.

## Size
- [Art direction](../Wiki/topics/art-direction.md) is about 1,900 words, over the ~1,500 guideline.
  - Proposed split: "Phone performance", covering the budget, stress tests, the NOTE 30 measurements and v0.10.1.
  - Splitting needs approval in Active mode, so it's in the backlog.
- [Roster](../Wiki/topics/roster.md) is at the limit (~1,550 words).

## Suggested new articles
1. **Itemization:** the map's item structure and FZFoC's original version (shops, parts, seven recipes, signature items, armour points, reusable and utility items), plus the gold-efficiency model.
2. **Arena map:** the layout (bases, camps, plateau, basin, north pit, moats, ramps), the uphill rule, creep rooms, combining circles and the duel arena.
3. **Bot AI:** adaptive skill, role builds, shopping (including while dead), item use, creep rooms and transformation timing.

## Backlog hygiene
- Stale open questions now resolved:
  - heroes 2 and 3 → Ryn and Barrow, then 24 heroes;
  - the title → "Fight of the Characters", chosen by the owner 2026-11-19;
  - the phase list → Phases 1–11 done.
- Cleaned in [backlog.md](../Wiki/backlog.md).

## Fixed in this check (Active mode)
- The 2 vs 20 gold contradiction and the "one 3D creator" claim (above).
- Backlog cleanup.
- The index summaries for topics touched this phase.
