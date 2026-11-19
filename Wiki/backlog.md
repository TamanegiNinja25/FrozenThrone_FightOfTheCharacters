---
type: index
updated: 2026-11-19
---
# Backlog

Open questions, gaps, wanted sources and proposals awaiting the user's approval.

## Awaiting approval
- **Split [Art direction](topics/art-direction.md)** (~1,900 words, over the ~1,500 guideline): move the phone budget, stress tests, NOTE 30 measurements and v0.10.1 performance into a new "Phone performance" article. Proposed by the [2026-11-19 health check](../Outputs/2026-11-19-health-check.md).

## Awaiting the owner's decision
Product choices only the owner can make (none blocks the build):
- **Art style:** the recorded decision is "high-poly stylized", but every model in the game is a low-poly CC0 pack. Either update the decision to the low-poly toon look, or plan sculpted heroes (the one unticked README item) — [Art direction](topics/art-direction.md#decision).
- **Online play:** multiplayer is local Wi-Fi only; internet play needs matchmaking servers (Photon, Nakama or similar) — [Hero arena genre](topics/hero-arena-genre.md#local-multiplayer).
- **Audience:** casual short sessions or competitive ranked play ([source](sources/2026-11-08-fight-of-characters-mobile-feasibility.md)).
- **Frame-rate target:** 60 FPS, or accept ~40 FPS in crowded fights on the NOTE 30 ([source](sources/2026-11-19-phase-11-title-icon-and-remaining-gaps.md)).
- **Voices:** spoken per-hero lines need recordings — the owner, friends or a hired actor ([source](sources/2026-11-08-ui-and-audio-direction.md)).
- ~~**Title**~~ decided 2026-11-19: "Fight of the Characters" ([source](sources/2026-11-19-phase-11-title-icon-and-remaining-gaps.md)).

## Unsourced claims
Marked *(inference)* in the wiki; each needs a RAW source:
- MPQ map header size and publicly known table-encryption keys — [Warcraft III map format](topics/warcraft-iii-map-format.md)
- The game finds files by hash, so stripping the file list doesn't stop it loading — [Warcraft III map format](topics/warcraft-iii-map-format.md)
- Copyright principles vary by country — [Copyright vs game mechanics](topics/copyright-vs-game-mechanics.md)
- Save licence screenshots in case pages change — [Assets and licensing](topics/assets-and-licensing.md)
- A public release would still need online matchmaking — [Hero arena genre](topics/hero-arena-genre.md#local-multiplayer)
- Long-press tooltips as the mobile tooltip pattern; transformation as its own sound moment — [UI and audio direction](topics/ui-and-audio-direction.md)
- The chunky low-poly KayKit look may call for revisiting the "high-poly stylized" decision — [Art direction](topics/art-direction.md#rigged-characters-and-scenery-phase-8)
- The original hero models remain as a fallback — [Roster](topics/roster.md)
- A spree economy without a comeback mechanic may snowball — [Hero arena genre](topics/hero-arena-genre.md#economy)

## Needs runtime verification
Claims a source marks as its own inference about Warcraft III engine behaviour; confirming them would need runtime observation (REA or play):
- Timed forms can't be cancelled early; level, XP, items and shared skills carry over through a morph; when the form cooldown starts — [Hero transformations](topics/hero-transformations.md)
- Hero A's form duration and cooldown (60 s / 180 s, stock defaults) — [Hero transformations](topics/hero-transformations.md)
- ~~Phone performance of high-poly heroes~~ **Verified 2026-11-08** on the Infinix NOTE 30: locked 60 FPS at realistic settings — [Art direction](topics/art-direction.md#phone-infinix-note-30)
- ~~Sustained heat over a full 5–8 minute match on the NOTE 30~~ **Measured 2026-11-19:** 8 minutes, 39 → 41 °C, the crowded end at 32 FPS average (lowest 20) with up to 676 units, no errors ([source](sources/2026-11-19-phase-11-title-icon-and-remaining-gaps.md)).
- Uphill misses on a phone: is high ground readable enough from the game camera for the 25% miss to feel fair? — [source](sources/2026-11-18-phase-10-terrain-monsters-itemization.md)
- Level-20 casters duel an equal bruiser at ~0.6 (the test passes at ≥0.45); does it show in real matches? — [Roster](topics/roster.md#phase-10-damage-balance)

## Recorded conflicts
- MP3s: "music tracks" vs measured 0.2–6.1 s clips — resolved in favour of the measurement; see [Fight Of Characters](topics/fight-of-characters.md#conflicts) and [Copyright vs game mechanics](topics/copyright-vs-game-mechanics.md#conflicts).
- Hero count: "36 hero forms" vs 25 playable heroes — different counting methods; the wiki uses 25 playable heroes; see [Fight Of Characters](topics/fight-of-characters.md#conflicts).

## Open questions
- Difficulty choice for enemy bots' base skill? Does adaptive AI feel fair over a full match? ([source](sources/2026-11-08-ui-polish-and-phase-2.md))
- **Game build:** Phases 1–11 done; v0.10.1 released ([source](sources/2026-11-19-phase-11-title-icon-and-remaining-gaps.md)). Open: a longer Classic (4v4) balance run; real-match feel of the uphill miss and of Classic's 2:00 income switch.
- ~~An original title to replace the working title "FZFoC"~~ decided: "Fight of the Characters" ([source](sources/2026-11-19-phase-11-title-icon-and-remaining-gaps.md)).
- **Vael:** ~~how is Eruption empowered?~~ Radius ×1.5, damage ×1.2 ([source](sources/2026-11-08-vael-eruption.md)). Still open: glow placement on the final model; voice lines and Kindled sound; Eruption's crowd value in 3v3 ([source](sources/2026-11-08-hero-design-vael.md))
- ~~Heroes 2 and 3: which archetypes?~~ Ryn (Speed) and Barrow (Giant); the roster is now 24 — [Roster](topics/roster.md).
- ~~Which mechanics define Fight Of Characters' appeal and should be prototyped first?~~ Narrowed: hero transformations are the core candidate — see [Hero transformations](topics/hero-transformations.md#design-direction-for-fzfoc-mobile). Still open: what else belongs in the first prototype.
- Should the transformed bounty multiplier scale with form strength or stage? ([source](sources/2026-11-08-decision-transformed-bounty.md))
- ~~Meter tuning~~ Decided 2026-11-08: charge rule, 87.2 s measured fill ([source](sources/2026-11-08-decisions-charge-rule-and-spree.md)). Still open: does it hold in 3v3? Does the spree economy snowball too hard?
- Transformation design: ~~meter or cooldown~~ (decided: meter). Every hero or only some? Stages per match or per activation? Does a form end on death or crowd control? ([source](sources/2026-11-08-spec-hero-transformations.md))
- What setting and art style would make an original roster distinctive? ([source](sources/2026-11-08-fight-of-characters-mobile-feasibility.md))
- Target casual short sessions, or competitive ranked play? ([source](sources/2026-11-08-fight-of-characters-mobile-feasibility.md))

- ~~Which 1–2 visual styles should the game commit to?~~ Decided 2026-11-08: high-poly stylized ([source](sources/2026-11-08-decision-visual-style.md))
- ~~Toon/ramp shading or simplified PBR?~~ Decided 2026-11-08: toon ([source](sources/2026-11-08-toon-shading-and-stress-benchmark.md))
- ~~Which phone is the stress-test target?~~ The owner's Infinix NOTE 30 ([source](sources/2026-11-08-phone-benchmark-infinix-note-30.md)). Target 60 FPS, or use the phone's 90/120 Hz modes? ([source](sources/2026-11-08-phone-benchmark-infinix-note-30.md))
- ~~Godot or Unity for the project?~~ Decided 2026-11-08: Godot ([source](sources/2026-11-08-decisions-meter-and-godot.md))

- Who records the voices — friends, the user, or a hired actor? ([source](sources/2026-11-08-ui-and-audio-direction.md))
- ~~Which UI kit or style anchors the look?~~ Phase 8: Kenney RPG UI pack, tinted to stone and gold ([source](sources/2026-11-08-ui-and-audio-direction.md)) ([source](sources/2026-11-09-phase-8-assets-agents-skills.md))
- ~~**Release signing**~~ solved 2026-11-09: v0.8.2 is signed with the shared key and installs as an update.
- ~~**Reference-map gaps**~~ closed 2026-11-10: every system from the gap audit is built ([source](sources/2026-11-10-phase-9-map-gaps-and-24-heroes.md)). Still open: spoken per-hero voice lines need recorded voice acting; a longer balance run for 24 heroes.
- **Phase 8 open:** ~~a phone check of the rigged heroes and single-mesh scenery~~ done 2026-11-09: 4v4 Classic, up to 436 units, 42–56 FPS (average 47), the same as v0.7.0, no errors; whether selected toggle buttons stand out on the tinted skin; skill sound effects (slam, transform) still generated; skill icons and 2D sprites not taken from packs (original icons kept) ([source](sources/2026-11-09-phase-8-assets-agents-skills.md))

## Wanted sources
- Sketchfab's official licence documentation and the Creative Commons licence texts (to confirm the licence table).
- Godot high-level multiplayer and Unity Netcode documentation for LAN play.
- Technical documentation of the MPQ archive and Warcraft III map file formats (would back the unsourced claims above).
- Mobile hero-arena / MOBA design references: match length, control schemes and monetisation in successful titles.
- Unity vs Godot for real-time mobile multiplayer; Photon vs Nakama comparisons.
- A plain-language guide to copyright and game mechanics (e.g. how courts have treated game rules versus expression).
