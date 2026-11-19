---
title: Phase 11 — "Fight of the Characters": title, icon, rule changes and the remaining gaps
date: 2026-11-19
type: design + implementation
decided-by: owner asked to rename the game "Fight of the Characters" and use a supplied picture as the icon; to let players buy while dead; to give Classic 10 gold a second after 2 minutes; and to fill every remaining gap
---
# Phase 11 — title, icon, rules and the remaining gaps

## Owner decisions
- **Title:** "Fight of the Characters".
  - Shown on the main menu and as the app's name.
  - The Android package ID stays `org.fzfoc.prototype` and the download file stays `FZFoC.apk`, so updates still install over earlier versions.
- **Icon:**
  - The owner supplied a picture to use as the game icon. It is official artwork of a character from a copyrighted anime series.
  - Because the repository and the APK are public, and the project uses only original characters and art, it was not used.
  - Instead, an original icon in the same layout was made:
    - one of the game's own heroes (Tamsin, a CC0-based model), framed;
    - a magenta-to-purple backdrop;
    - the title in a script typeface.
  - `tools/render_icon.gd` renders it, including the Android adaptive layers.
- **Title typeface:** Dancing Script (SIL Open Font License 1.1, from Google's official fonts repository), with its licence beside it. Credited in `CREDITS.md` and on the Credits screen.
- **Buying while dead:** a dead hero can shop anywhere while waiting to respawn. Otherwise heroes still shop at their fountain. Bots shop on death too.
- **Classic income:** no passive gold for the first 2:00, then 10 gold a second for every hero. The kill feed announces it.

## The economy's actual values (recorded here for the first time)
- **The scale change:** Phase 6 (commit `6a96f13`, 2026-11-08) multiplied the whole economy by ten to match the reference map's prices. Phase 6's record did not list the numbers.
- **Mobile:**
  - 20 gold a second passive income;
  - +20 gold a second per kill-spree step;
  - kill gold 1,000, +50% per spree step;
  - hero bounty 500 (×1.75 while transformed).
- **Classic:** no spree income. Passive income is 0 until 2:00, then 10 gold a second.
- The earlier decision record (2 gold a second, +2 per spree step) describes the pre-Phase-6 scale.

## Gaps filled
- **Bots use the utility items.**
  - **Role builds:**
    - bruisers and giants carry a recall scroll;
    - speed heroes carry a Shadow Cloak and a Hushstone;
    - ranged heroes carry a Hushstone;
    - casters carry a Hushstone and build the Titan Pact (seeing stone + ember idol).
  - **When they use them:**
    - a potion below 45% health;
    - throwing knives to finish an enemy hero under 380 HP;
    - the Hushstone on an enemy hero above 30% health (chance scales with bot skill);
    - the Bog Titan in a hero fight;
    - the cloak when retreating below 35% health with an enemy hero within 6;
    - the recall scroll when retreating more than 25 from base with no enemy hero within 10.
  - **Shopping:** bots buy true sight (Watcher's Eye) once an enemy carries a Shadow Cloak, and a potion from level 4 when they have 3,400 gold or more.
- **North pit:** the map's terrain has sunken ground north as well as south.
  - A pit now sits at the north centre (x −9…9, z −28.5…−17, depth −1.2). The win boss waits there, reached by two ramps from the field.
  - The ground mesh grows to 13.4k triangles.
- **Uphill warning:** while the hero's attack target stands on higher ground, the status line shows "▲ Uphill — 25% miss". While dead, it reads "Respawning… · you can shop".
- **Release workflow:** the GitHub Actions steps were updated from deprecated Node 20 versions to Node 24 releases:
  - checkout v7;
  - setup-java v6;
  - upload-artifact v7;
  - action-gh-release v3.

  Every input the workflow uses still exists in the new versions. They first run on the next release tag.

## Phone: a full match on a warm phone
- **Setup:** Infinix NOTE 30; an 8-minute crowded Classic match on the v0.10.1 graphics settings (90% resolution, 2 shadow cascades, detailed creeps). The creep limit was the map's own (uncapped).
- **Phone temperature:** started at 39 °C and ended at 41 °C.
- **The last ~3 minutes** (the log buffer kept 96 samples, all with 250+ units):
  - 32.4 FPS on average, 20 at the lowest;
  - GPU 22.3 ms per frame;
  - up to 676 units on the field;
  - no script errors.
- **The menu** shows the new title; no script errors at launch.

## Gaps that need the owner
- **Voice lines:** spoken per-hero lines need recordings (heroes have battle cries and death grunts from free packs).
- **Art style:** the recorded decision ("high-poly stylized") differs from the low-poly CC0 models in use.
- **Online play:** internet multiplayer needs matchmaking servers.
- **Audience and frame-rate target:** casual or competitive play; whether to aim for 60 FPS.
- **Hero pick:** the wisp hero pick stays a menu, as decided for touch screens.

## Tests
- `map_systems_test` adds checks for:
  - Classic income after 2:00;
  - shopping while dead away from the fountain;
  - bots silencing, finishing with knives, drinking a potion and buying true sight;
  - the caster build's Titan Pact parts;
  - the north pit and its ramps.
