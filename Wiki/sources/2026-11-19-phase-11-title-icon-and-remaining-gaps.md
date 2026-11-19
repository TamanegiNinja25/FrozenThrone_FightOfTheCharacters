---
type: source
raw: ../../RAW/2026-11-19-phase-11-title-icon-and-remaining-gaps.md
added: 2026-11-19
why: Owner renamed the game "Fight of the Characters", asked for a supplied picture as the icon, for buying while dead and Classic income after 2:00, and to fill every remaining gap.
---
# Phase 11 — title, icon, rules and the remaining gaps
Record of Phase 11.
- **Name:** the game is now "Fight of the Characters".
- **Icon:** original, after a supplied picture of a copyrighted anime character was declined for the public build.
- **Rules:** dead heroes can shop; Classic pays 10 gold a second from 2:00.
- **Gaps closed:** bots use every utility item, the north pit, an uphill warning and updated CI actions. The economy's actual (×10) values are recorded for the first time.

## Key points
- **Title:**
  - "Fight of the Characters" on the menu (Dancing Script, SIL OFL) and as the app name.
  - The package ID and `FZFoC.apk` stay, so updates still install.
- **Icon:**
  - The supplied picture was official anime artwork, so it wasn't used in the public repository and APK.
  - Instead, Tamsin (the game's own hero) is framed under a magenta-to-purple sky with the title, rendered by `tools/render_icon.gd`.
- **Shopping while dead:** anywhere, until respawn; bots too.
- **Classic income:** 0 until 2:00, then 10 gold a second; the kill feed announces it.
- **Economy values:** Phase 6 scaled everything ×10.
  - Mobile: 20 gold/s, +20/s per spree step, 1,000 kill gold (+50% per step), 500-gold hero bounty (×1.75 transformed).
  - Classic: no spree income.
- **Bot items:**
  - Role builds carry recall, cloak, Hushstone or the Titan Pact.
  - Use rules:
    - potion below 45% health;
    - knives on heroes under 380 HP;
    - Hushstone on heroes above 30% health;
    - Titan in hero fights;
    - cloak when hurt and chased;
    - recall when far from base and safe.
  - Purchases: true sight against an enemy cloak, potions with spare gold.
- **North pit:** x −9…9, z −28.5…−17, depth −1.2, with the win boss inside and two ramps. The ground mesh is now 13.4k triangles.
- **Uphill warning:** "▲ Uphill — 25% miss" while the target is higher; "Respawning… · you can shop" while dead.
- **CI:** Node 24 versions of checkout (v7), setup-java (v6), upload-artifact (v7) and action-gh-release (v3); every input checked.
- **Phone, full match (8 min, warm phone at 39–41 °C, uncapped creeps):** the last ~3 minutes averaged 32.4 FPS (lowest 20), GPU 22 ms, up to 676 units; no script errors.
- **Needs the owner:** voice recordings, the art-style decision, online play, audience and frame-rate target. The menu hero pick stays.

## Topics
- [Itemization](../topics/itemization.md) — shopping while dead
- [Arena map](../topics/arena-map.md) — the north pit, uphill warning
- [Bot AI](../topics/bot-ai.md) — utility items, shopping while dead
- [Hero arena genre](../topics/hero-arena-genre.md) — economy values, Classic income
- [Assets and licensing](../topics/assets-and-licensing.md) — the font, the declined picture
- [Copyright vs game mechanics](../topics/copyright-vs-game-mechanics.md) — the icon decision

## Open questions
- Does Classic's 2:00 income switch change match pacing in real 4v4 games?
- Is the uphill warning enough, or should high ground also be marked on the field?
