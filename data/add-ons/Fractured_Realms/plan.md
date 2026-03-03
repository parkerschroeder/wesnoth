# Plan: Mushroom Faction for Wesnoth

## Concept
A mushroom-themed faction focused on status effects (single-target at L1) that upgrade into AoE abilities at L2+. Each unit type is based on a real mushroom species, and its abilities match the mushroom's real-world properties.

**Core mechanic — Fungal Spread:** Mushroom units convert the hex they stand on into Mushroom Grove terrain at the start of each turn (using WML `[terrain]` events). Mushroom Grove gives the faction enhanced defense and movement, while being neutral or slightly penalizing for other factions. This creates a "creeping territory" mechanic where the Mycelium gradually transforms the battlefield.

## Current State
- Forked War of Legends add-on into `Fractured_Realms` in userdata add-ons folder
- All WoL paths renamed to Fractured_Realms
- Custom faction placeholder (Rebels clone) already added to the WoL era definition
- Next: Replace the placeholder with the mushroom faction units

## Faction Identity
- **Name**: The Mycelium
- **Alignment**: Chaotic (mushrooms thrive in darkness/decay)
- **Terrain affinity**: Caves, Swamp, Mushroom Grove (terrain_liked = Uu, Ss, Ff)
- **Playstyle**: Debuff + outlast + terrain control. Weak individual units that weaken enemies through status effects and gradually convert the map into home territory. Rewards keeping units alive to L2 where AoE unlocks.
- **Racial immunities**: Poison, Plague (fungi produce toxins and decompose the dead — they can't be poisoned or reanimated)

## Fungal Spread Mechanic
Two core mechanics create a self-reinforcing territorial loop:

### 1. Passive Spread (turn start)
- Every Mycelium unit converts its hex to Mushroom Grove at turn start (via `[terrain]` WML action in a side turn event)
- Slow, defensive spread — rewards keeping units alive and positioned
- L2+ units could convert adjacent hexes too (larger radius)

### 2. ~~Kill Spread~~ (removed)
- Removed to simplify the faction and avoid timing conflicts with plague

### 3. Fungal Plague (Sporecap, Cordyceps, Puffball, Fungal Spore)
- Unconditional plague — when these units kill an enemy, it rises as a Fungal Spore
- Uses the engine's built-in plague system (doesn't work on undead, mechanical, or villages)
- Spores are L0, fragile, and expendable — designed to die

### 4. Death Bloom (Fungal Spore + Puffball)
- When a unit with death bloom dies, ALL nearby hexes are converted to Mushroom Grove and adjacent enemies are poisoned
- This is the faction's primary territory expansion tool
- Creates the core loop: plague spawns spore → spore dies → death bloom spreads groves → more favorable terrain
- Fungal Spore (L0) advances to Puffball (L1) — same death bloom identity, upgraded body with skirmisher
- Strategic choice: protect the spore for its plague attack, or sacrifice it to infect new ground
- **Counterplay**: enemies can kill spores in locations where grove spread is harmless, or avoid killing them entirely

### Mushroom Grove Terrain Stats
- High defense for Mycelium (60-70%), lower for others (~40%)
- Good movement for Mycelium (1 MP), slightly costly for others (2 MP)
- Visually could overlay existing forest terrain
- Terrain conversion is permanent — the battlefield gets progressively more favorable

### Strategic Tension
- Spread out to claim territory vs. cluster for AoE synergy at L2+
- Push forward aggressively with plague units to spawn spores
- Spores are worth more dead than alive — sacrifice decisions
- Enemies face a dilemma: kill the spore and spread groves, or leave it alive and let it plague more units

## L1 Recruits (single-target status effects)

### 1. Sporecap (Fighter) — 15g
- **Mushroom**: Generic toadstool warrior
- **HP**: 38 | **Mov**: 4 | **Align**: Chaotic
- **Melee**: Club 6×2 (impact) — **slow**
- **Ranged**: Spore Puff 3×2 (impact)
- **Role**: Faction tank. Tough and slow, holds the line while grove spreads. Slows enemies in melee to match its pace.
- **Advances to**: Sporeguard (L2) → Sporewarden (L3)

### 2. Deathcap (Poisoner) — 16g
- **Mushroom**: Amanita (deadly poisonous)
- **HP**: 24 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Toxic Touch 4×2 (blade) — **poison**
- **Ranged**: Poison Dart 5×2 (pierce) — **poison**
- **Role**: Glass cannon poisoner. Fragile but poisons everything it touches.
- **Advances to**: Destroying Angel (L2) → Angel of Death (L3)

### 3. Lion's Mane (Healer) — 16g ✅ BUILT
- **Mushroom**: Lion's Mane (shaggy, cascading mushroom known for nerve regeneration)
- **HP**: 26 | **Mov**: 5 | **Align**: Neutral
- **Melee**: Staff 3×2 (impact)
- **Ranged**: Restorative Spores 4×2 (impact)
- **Ability**: Heals +4 (adjacent allies)
- **Role**: Faction healer. Restorative mushroom that mends wounded allies.
- **Advances to**: Morel (L2) → King Bolete (L3)
- **Unit ID**: Mycelium_Lions_Mane

### 4. Mycelium Runner (Scout) — 17g
- **Mushroom**: Mycelium network (underground fungal threads)
- **HP**: 28 | **Mov**: 8 | **Align**: Chaotic
- **Melee**: Tendril Lash 5×3 (blade)
- **Ranged**: —
- **Ability**: Ambush (hides in forest/cave)
- **Role**: Fast scout. Represents the underground mycelium spreading.
- **Advances to**: Mycelium Weaver (L2) → Mycelium Overmind (L3)

### 5. Puffball (Skirmisher) — 14g
- **Mushroom**: Puffball (releases spore cloud when disturbed)
- **HP**: 22 | **Mov**: 6 | **Align**: Chaotic
- **Melee**: Bump 3×3 (impact) — **plague**
- **Ability**: Skirmisher (ignores ZoC), Death Bloom
- **Role**: Cheap kamikaze flanker. Slips through lines via skirmisher, spreads plague on melee, detonates into grove spread on death. Advancement from Fungal Spore (L0).
- **Advances to**: Giant Puffball (L2) → Earthstar (L3)

### 6. Glowcap (Mage) — 19g
- **Mushroom**: Bioluminescent fungus (channels bioelectric energy)
- **HP**: 22 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Shock Touch 3×1 (electric)
- **Ranged**: Spark Bolt 7×2 (electric) — **magical**
- **Role**: Ranged damage dealer. Expensive but hits hard with electric/magical.
- **Advances to**: Shaggy Mane (L2) → Black Morel (L3)

### 7. Cordyceps (Parasite) — 19g
- **Mushroom**: Cordyceps (parasitic, mind-controlling fungus)
- **HP**: 25 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Parasitic Touch 4×3 (blade) — **drain**
- **Ranged**: Mind Spore 3×3 (arcane) — **plague**
- **Role**: Parasitic survivor. Drains life in melee to stay alive despite fragile stats, spreads plague at range. Benefits from grove terrain like all Mycelium units.
- **Advances to**: Puppeteer (L2) → Hivemind (L3)

### 8. Madcap (Berserker) — 17g ✅ BUILT
- **Concept**: A crazed dwarf hermit who discovered the rage-inducing fly agaric mushroom (*Amanita muscaria*) deep in the caves. Exiled by their clan, they now fight alongside the Mycelium — consuming grove mushrooms to fuel devastating berserk frenzies.
- **Race**: Dwarf (not mushroom — uses dwarf names, traits, movetype)
- **HP**: 32 | **Mov**: 5 | **Align**: Chaotic
- **Melee 1**: Mushroom Frenzy 5×3 (blade) — **berserk, grove bound** (consumes the grove)
- **Melee 2**: Hand Axe 4×3 (blade) — fallback when not on a grove
- **Role**: Conditional berserker. Devastating on a mushroom grove, average without one. Creates faction synergy — mushroom units spread groves, the Madcap consumes them for explosive burst damage. Does NOT spread groves passively (dwarf, no fungal_growth trait).
- **Advances to**: Mad Prince (L2, chaotic, terror) → Mad Lord (L3) | Grove Warden (L2, neutral, leadership) → Old Growth (L3)
- **Unit ID**: Mycelium_Madcap

## L2 Advancements

### Built

#### Sporeguard (from Sporecap) — 32g ✅ BUILT
- **HP**: 52 | **Mov**: 4 | **Align**: Chaotic
- **Melee**: Club 9×3 (impact) — **plague**
- **Ranged**: Spore Puff 6×2 (impact) — **slow**
- **Ability**: Spore Cloud — when this unit hits with its ranged attack, all enemy units adjacent to the **target** are also **slowed** (via `attacker_hits` event + dummy ability filter)
- **Role**: Crowd-control tank. Lands a ranged hit and the spore cloud billows out, slowing enemies clustered around the target. Forces a choice: plague one enemy in melee, or slow a group at range.

#### Blightcap (from Sporecap) — 32g ✅ BUILT
- **HP**: 52 | **Mov**: 4 | **Align**: Chaotic
- **Melee**: Club 8×3 (impact) — **plague**
- **Ranged**: Toxic Puff 5×3 (impact) — **poison**
- **Ability**: Toxic Spores — attackers are **poisoned** after combat (retaliatory, via `attack_end` event + dummy ability filter)
- **Role**: Offensive tank. Trades some bulk for poison pressure. Attackers take ongoing damage after engaging.

#### Mad Prince (from Madcap) — 28g ✅ BUILT
- **Race**: Dwarf
- **HP**: 44 | **Mov**: 5 | **Align**: Chaotic
- **Melee 1**: Mushroom Frenzy 7×4 (blade) — **berserk, grove bound**
- **Melee 2**: Hand Axe 6×3 (blade)
- **Ability**: Terror — adjacent enemies of lower level deal reduced damage (adapted from WoL Nightmares)
- **Role**: Enhanced berserker. Frenzy matches the Dwarvish Berserker's 7×4 pattern but remains grove-bound. Radiates a terror aura from the fly agaric psychoactive toxins, debuffing nearby lower-level enemies. AMLA advancement.

#### Mad Lord (from Mad Prince) — 46g ✅ BUILT
- **Race**: Dwarf
- **HP**: 56 | **Mov**: 5 | **Align**: Chaotic
- **Melee 1**: Mushroom Frenzy 9×4 (blade) — **berserk, grove bound, fungal plague**
- **Melee 2**: Hand Axe 9×4 (blade) — **fungal plague**
- **Ability**: Terror
- **Role**: Plague berserker lord. Kills raise Fungal Spores while terror aura suppresses nearby enemies. The culmination of the Madcap line — a tyrant of madness whose victims fuel the mycelium's spread.

#### Grove Warden (from Madcap) — 28g ✅ BUILT
- **Race**: Dwarf
- **HP**: 44 | **Mov**: 5 | **Align**: Neutral
- **Melee 1**: Mushroom Frenzy 7×4 (blade) — **berserk, grove bound**
- **Melee 2**: Hand Axe 7×4 (blade)
- **Ability**: Leadership — adjacent allies of lower level deal more damage
- **Role**: Guardian path. Where the Mad Prince descends deeper into madness, the Grove Warden channels mushroom visions into fierce protectiveness of the groves. Neutral alignment and leadership make it a support berserker that boosts the Mycelium's L1 units.

#### Old Growth (from Grove Warden) — 46g ✅ BUILT
- **Race**: Dwarf
- **HP**: 60 | **Mov**: 5 | **Align**: Neutral
- **Melee 1**: Mushroom Frenzy 8×4 (blade) — **berserk, grove bound**
- **Melee 2**: Hand Axe 8×4 (blade)
- **Ranged**: Spore Toss 6×3 (impact)
- **Abilities**: Leadership, Regeneration
- **Role**: The living heart of the grove. Leadership rallies allies while regeneration keeps the Old Growth standing through prolonged engagements. The boundary between dwarf and fungus has blurred — mycelial threads wind through their veins, granting unnatural resilience.

### Planned

| L1 Unit | L2 Name | Ability Gained |
|---------|---------|---------------|
| Deathcap | **Destroying Angel** | Death Cloud: AoE poison to adjacent enemies (aura) |
| Lion's Mane | **Morel** | Heals +8, Cures poison (adjacent allies) |
| Mycelium Runner | **Mycelium Weaver** | Fungal Network: AoE fungal spread (converts adjacent hexes each turn, not just the hex it stands on). Fast territory raider — dashes deep and leaves groves behind. |
| Puffball | **Giant Puffball** | Spore Explosion: AoE impact damage to adjacent enemies |
| Glowcap | **Shaggy Mane** | Lightning Storm: AoE electric damage to adjacent enemies on attack |
| Cordyceps | **Puppeteer** | AoE drain aura + Fungal Domination (-10% damage) |

#### Broodcap (from Cordyceps) — 34g ✅ BUILT
- **HP**: 40 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Parasitic Touch 6×3 (blade) — **drain**
- **Ranged**: Domination Spore 5×4 (arcane) — **plague, magical**
- **Role**: Glass cannon plague engine. Low HP for L2 but devastating magical ranged — ignores terrain defense and converts kills into Fungal Spores. Drain melee keeps it alive when cornered.

## L3 Advancements (enhanced AoE + combos)

| L2 Unit | L3 Name | Enhanced Ability |
|---------|---------|-----------------|
| Sporeguard | **Sporewarden** | AoE slow + reduces enemy damage |
| Destroying Angel | **Angel of Death** | AoE poison + kills on grove spawn 2 Fungal Spores instead of 1 |
| Morel | **King Bolete** | AoE heal 8 + cures + self-regeneration |
| Mycelium Weaver | **Mycelium Overmind** | Teleport between caves/forests + entangle aura |
| Giant Puffball | **Earthstar** | Massive AoE burst: damage + slow within 2 hexes |
| Shaggy Mane | **Black Morel** | AoE cold + slow combo on attack |
| Puppeteer | **Hivemind** | Enhanced AoE drain aura + Fungal Domination (adjacent enemies -20% damage + slow) |

## Leaders (L2 units as starting leaders)

- **Sporeguard** — Defensive leader, slows attackers around keep
- **Destroying Angel** — Aggressive leader, poisons everything nearby
- **Morel** — Support leader (Lion's Mane L2), heals recruits immediately
- **Puppeteer** — Control leader, drains enemies and weakens them with Fungal Domination

## Balance Notes
- **Weakness**: Low raw damage. Loses straight 1v1 fights.
- **Strength**: Status effects compound. Slowed + poisoned enemies are dramatically weaker.
- **Counter-play**: Curing units (White Mage, Elvish Druid) hard-counter this faction.
- **Average L1 cost**: ~16g (comparable to other factions)
- **Average L1 HP**: ~25 (below average — fragile)
- **Chaotic alignment** means they fight best at night.

## Implementation Todos (Phase 1 — L1 units only)
1. Define custom Mushroom Grove terrain type (terrain graphics, movement/defense tables)
2. Define mushroom race in WML
3a. Create passive Fungal Spread event (side turn event that converts hexes under Mycelium units)
3b. Create kill-based Fungal Spread event ([die] event that converts death hex when Mycelium unit gets the kill)
3c. Create Grove Reanimation event ([die] event: enemy killed on Mushroom Grove hex by Mycelium unit → spawns Fungal Spore)
4. Create L1 unit type .cfg files (7 units)
5. Define L1 weapon specials/abilities in macros (slow, poison, drain, heals, ambush, skirmisher, magical)
5b. Create Fungal Spore unit type (spawned by plague)
6. Create faction [multiplayer_side] definition
7. Add faction to Fractured_Realms era (replace Rebels clone placeholder)
8. Test in-game for loading
9. Add placeholder art (reuse existing sprites)

## Future Phases (general ideas, not implemented yet)
- **Phase 2**: L2 units with AoE abilities (death cloud, spore cloud, frost nova, enhanced healing)
- **Phase 3**: L3 units with combo AoE effects + expanded fungal spread radius
- **Phase 4**: ✅ DONE — Mushroom Forest overlay (`^Tff`, aliasof=_bas,Tt,Ft). Fungal Spread now converts forest overlays into Mushroom Forest instead of skipping them. Defined in `macros/mycelium-terrain.cfg`.

## Backlog
- [ ] Create custom sprite for Mushroom Forest (`^Tff`) — currently reuses `forest/mushrooms-tile` from Mushroom Grove. Needs a unique look that blends tree trunks with giant mushroom caps growing among/over branches.
- [x] Update unit internal naming convention — replaced `{HUMAN_NAMES}` with custom mushroom-themed name lists (mycological Latin-inspired names like Agarum, Boleth, Mycenae, etc.)