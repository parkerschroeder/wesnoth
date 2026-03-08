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
- **Based on**: Heavy Infantryman (high HP tank, slow movement, impact damage)
- **Advances to**: Sporeguard (L2) → Sporewarden (L3)

### 2. Deathcap (Archer) — 15g
- **Mushroom**: Amanita (deadly poisonous)
- **HP**: 24 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Toxic Touch 3×2 (blade) — **poison**
- **Ranged**: Poison Dart 5×3 (pierce) — **poison**
- **Role**: Ranged poisoner/archer. Fragile but peppers enemies with venomous barbs from range. Poison is the real damage. Fast leveling at 24 XP.
- **Based on**: Elvish Archer (ranged-focused, but with poison instead of raw damage)
- **Advances to**: Nightcap (L2) / Double Truffle (L2) → Angel of Death (L3) / Trufflemaker (L3)

### 3. Lion's Mane (Healer) — 14g ✅ BUILT
- **Mushroom**: Lion's Mane (shaggy, cascading mushroom known for nerve regeneration)
- **HP**: 26 | **Mov**: 5 | **Align**: Neutral
- **Melee**: Staff 3×2 (impact)
- **Ranged**: Restorative Spores 4×2 (impact) — **slow**
- **Ability**: Heals +4 (adjacent allies)
- **Role**: Faction healer. Restorative mushroom that mends wounded allies.
- **Based on**: Elvish Shaman (L1 healer, similar HP/mov)
- **Advances to**: Morel (L2, healer) / Ergot (L2, blight) → King Bolete (L3) / Blightcrown (L3)
- **Unit ID**: Mycelium_Lions_Mane

### 4. Mycelium Runner (Scout) — 17g
- **Mushroom**: Mycelium network (underground fungal threads)
- **HP**: 28 | **Mov**: 8 | **Align**: Chaotic
- **Melee**: Tendril Lash 5×3 (blade)
- **Ranged**: —
- **Ability**: Ambush (hides in forest/cave)
- **Role**: Fast scout. Represents the underground mycelium spreading.
- **Based on**: Elvish Scout (high movement, melee-only, ambush)
- **Advances to**: Mycelium Weaver (L2) → Mycelium Overmind (L3)

### 5. Puffball (Skirmisher) — 14g
- **Mushroom**: Puffball (releases spore cloud when disturbed)
- **HP**: 22 | **Mov**: 6 | **Align**: Chaotic
- **Melee**: Bump 3×3 (impact) — **plague**
- **Ability**: Skirmisher (ignores ZoC), Death Bloom
- **Role**: Cheap kamikaze flanker. Slips through lines via skirmisher, spreads plague on melee, detonates into grove spread on death. Advancement from Fungal Spore (L0).
- **Based on**: Footpad (cheap skirmisher, 14g, fragile)
- **Advances to**: Giant Puffball (L2) → Earthstar (L3)

### 6. Glowcap (Mage) — 19g
- **Mushroom**: Bioluminescent fungus (channels bioelectric energy)
- **HP**: 22 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Shock Touch 3×1 (electric)
- **Ranged**: Spark Bolt 7×2 (electric) — **magical**
- **Role**: Ranged damage dealer. Expensive but hits hard with electric/magical.
- **Based on**: Dark Adept / Mage (fragile magical ranged, 19g)
- **Advances to**: Shaggy Mane (L2) → Black Morel (L3)

### 7. Cordyceps (Parasite) — 16g
- **Mushroom**: Cordyceps (parasitic, mind-controlling fungus)
- **HP**: 30 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Parasitic Touch 5×3 (blade) — **drain**
- **Ranged**: —
- **Role**: Melee-only drain fighter. Cheap and self-sustaining through drain, the only drain unit in the faction. Specializes at L2 into plague support (Broodcap) or drain support (Puppeteer).
- **Based on**: Dune Rover (14g, 32 HP, 5 mov, liminal; axe 4×3 blade, bow 5×3 pierce). Cordyceps trades ranged and 2 HP for drain sustain at +2g.

### 8. Madcap (Berserker) — 17g ✅ BUILT
- **Concept**: A crazed dwarf hermit who discovered the rage-inducing fly agaric mushroom (*Amanita muscaria*) deep in the caves. Exiled by their clan, they now fight alongside the Mycelium — consuming grove mushrooms to fuel devastating berserk frenzies.
- **Race**: Dwarf (not mushroom — uses dwarf names, traits, movetype)
- **HP**: 32 | **Mov**: 5 | **Align**: Chaotic
- **Melee 1**: Mushroom Frenzy 5×3 (blade) — **berserk, grove bound** (consumes the grove)
- **Melee 2**: Hand Axe 4×3 (blade) — fallback when not on a grove
- **Role**: Conditional berserker. Devastating on a mushroom grove, average without one. Creates faction synergy — mushroom units spread groves, the Madcap consumes them for explosive burst damage. Does NOT spread groves passively (dwarf, no fungal_growth trait).
- **Based on**: Dwarvish Guardsman / Berserker (dwarf chassis, berserk mechanic)
- **Advances to**: Mad Prince (L2, chaotic, terror) → Mad Lord (L3) | Grove Warden (L2, neutral, leadership) → Old Growth (L3)
- **Unit ID**: Mycelium_Madcap

## L2 Advancements

### Built

#### Sporeguard (from Sporecap) — 32g ✅ BUILT
- **HP**: 52 | **Mov**: 4 | **Align**: Chaotic
- **Melee**: Club 9×3 (impact) — **slow**
- **Ranged**: Spore Puff 6×2 (impact) — **slow**
- **Ability**: Spore Cloud — when this unit hits with its ranged attack, all enemy units adjacent to the **target** are also **slowed** (via `attacker_hits` event + dummy ability filter)
- **Role**: Crowd-control tank. Slows enemies in melee and at range. Can unleash AoE slow eruptions from groves.
- **Based on**: Iron Mauler (heavy L2 tank with CC)

#### Chaga (from Sporecap) — 32g ✅ BUILT
- **HP**: 59 | **Mov**: 4 | **Align**: Neutral
- **Melee**: Club 8×3 (impact)
- **Ranged**: Spore Puff 9×1 (impact)
- **Ability**: Steadfast — halves damage when not moving, 70% blade/pierce, 80% impact, 100% fire/arcane resistance
- **Role**: Pure wall. Dense, rock-hard fungus that absorbs punishment. The faction's anchor against both physical and elemental threats.
- **Based on**: Dwarvish Stalwart (30g, 59 HP, 4 mov, neutral, steadfast; spear 8×3 pierce, javelin 9×1 pierce; blade/pierce 20%, impact 20%, fire/cold/arcane 10%). Chaga matches HP and ranged exactly, trades pierce for impact damage, has +10% blade/pierce resist but 0% fire/arcane (vs Stalwart's 10%).
- **Advances to**: Heartwood (L3)

#### Mad Prince (from Madcap) — 28g ✅ BUILT
- **Race**: Dwarf
- **HP**: 44 | **Mov**: 5 | **Align**: Chaotic
- **Melee 1**: Mushroom Frenzy 7×4 (blade) — **berserk, grove bound**
- **Melee 2**: Hand Axe 6×3 (blade)
- **Ability**: Terror — adjacent enemies of lower level deal reduced damage (adapted from WoL Nightmares)
- **Role**: Enhanced berserker. Frenzy matches the Dwarvish Berserker's 7×4 pattern but remains grove-bound. Radiates a terror aura from the fly agaric psychoactive toxins, debuffing nearby lower-level enemies. AMLA advancement.
- **Based on**: Dwarvish Berserker (7×4 berserk, similar HP)

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
- **Based on**: Dwarvish Steelclad (sturdy L2 dwarf, support role)

#### Old Growth (from Grove Warden) — 46g ✅ BUILT
- **Race**: Dwarf
- **HP**: 60 | **Mov**: 5 | **Align**: Neutral
- **Melee 1**: Mushroom Frenzy 8×4 (blade) — **berserk, grove bound**
- **Melee 2**: Hand Axe 8×4 (blade)
- **Ranged**: Spore Toss 6×3 (impact)
- **Abilities**: Leadership, Regeneration
- **Role**: The living heart of the grove. Leadership rallies allies while regeneration keeps the Old Growth standing through prolonged engagements. The boundary between dwarf and fungus has blurred — mycelial threads wind through their veins, granting unnatural resilience.

### Planned

| L1 Unit | L2 Name | Ability Gained | Status |
|---------|---------|---------------|--------|
| Deathcap | **Nightcap** | Poison Cloud: AoE poison attack (grove bound) | ✅ BUILT |
| Deathcap | **Double Truffle** | Venom Strike: double damage vs poisoned (offense only) | ✅ BUILT |
| Lion's Mane | **Morel** | Heals +8, Cures — pure healer path | ✅ BUILT |
| Lion's Mane | **Ergot** | Blight (unhealable), AoE blight (grove bound) — offensive blight path | ✅ BUILT |
| Mycelium Runner | **Mycelium Weaver** | Overgrowth (adjacent grove spread), Ambush, Entangle (slow) | ✅ BUILT |
| Puffball | **Giant Puffball** | Spore Explosion: AoE impact damage to adjacent enemies | |
| Glowcap | **Shaggy Mane** | Lightning Storm: AoE electric damage to adjacent enemies on attack | |
| Cordyceps | **Puppeteer** | Parasitic Link: drain aura for adjacent allies | ✅ BUILT |

#### Broodcap (from Cordyceps) — 34g ✅ BUILT
- **HP**: 45 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Parasitic Touch 6×3 (blade) — **drain**
- **Ranged**: Domination Spore 5×4 (arcane) — **plague, magical**
- **Ability**: Fungal Brood — adjacent allies' attacks spawn Fungal Spores from slain enemies (plague aura)
- **XP**: 75
- **Role**: Plague support. Turns every allied kill nearby into Fungal Spore reinforcements. Drain melee keeps it alive when cornered, magical ranged handles its own kills.
- **Based on**: Dune Explorer (31g, 46 HP, 6 mov, liminal; axe 6×4 blade, bow 8×3 pierce). Broodcap trades 1 HP, 1 movement and raw damage for drain + plague aura at +3g.

#### Puppeteer (from Cordyceps) — 32g ✅ BUILT
- **HP**: 43 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Parasitic Touch 6×3 (blade) — **drain**
- **Ranged**: Mind Spore 5×3 (arcane)
- **Ability**: Parasitic Link — adjacent allies drain health from their attacks
- **XP**: 75
- **Role**: Drain support. Nearby allies self-sustain through combat. Complements the Broodcap's army-building with army-sustaining.
- **Based on**: Dune Explorer (31g, 46 HP, 6 mov, liminal; axe 6×4 blade, bow 8×3 pierce). Puppeteer trades 3 HP, 1 movement and raw damage for drain + drain aura at +1g.

#### Nightcap (from Deathcap) — 32g ✅ BUILT
- **HP**: 36 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Toxic Touch 6×2 (blade) — **poison**
- **Ranged 1**: Poison Dart 7×2 (pierce) — **poison**
- **Ranged 2**: Poison Cloud 5×3 (impact) — **poison, AoE poison (poison_cloud), grove bound**
- **Role**: Glass cannon AoE poisoner. Still fragile for L2 but now poisons clusters of enemies by channeling the grove network. Three attack options: safe ranged poison, melee poison, or devastating grove-powered poison cloud that poisons both the target and all adjacent enemies.
- **Based on**: Lich (fragile AoE caster, status effects)

#### Double Truffle (from Deathcap) — 30g ✅ BUILT
- **HP**: 40 | **Mov**: 6 | **Align**: Chaotic
- **Melee**: Toxic Touch 4×2 (blade) — **poison**
- **Ranged**: Catalyst Spore 6×3 (pierce) — **toxic strike** (double damage vs poisoned enemies, offense only)
- **Role**: Ranged assassin/sniper. Melee poisons the target, then catalyst spores finish from range at 12×3 (36 damage) vs poisoned enemies. Works best with Deathcap or Nightcap to pre-poison targets. The attack has no poison itself — it's a pure finisher.
- **Based on**: Elvish Marksman (ranged-focused, conditional damage)

## L3 Advancements (enhanced AoE + combos)

| L2 Unit | L3 Name | Enhanced Ability |
|---------|---------|-----------------|
| Sporeguard | **Sporewarden** | AoE slow + reduces enemy damage |
| Nightcap | **Angel of Death** | AoE poison + kills on grove spawn 2 Fungal Spores instead of 1 |
| Morel | **King Bolete** | AoE heal 8 + cures + self-regeneration |
| Ergot | **Blightcrown** | Enhanced AoE blight + stronger unhealable |
| Double Truffle | **Trufflemaker** | Marksman + enhanced catalyst spore (8×3, 16×3 vs poisoned) |
| Mycelium Weaver | **Mycelium Overmind** | Teleport between caves/forests + entangle aura |
| Giant Puffball | **Earthstar** | Massive AoE burst: damage + slow within 2 hexes |
| Shaggy Mane | **Black Morel** | AoE cold + slow combo on attack |
| Puppeteer | **Hivemind** | Enhanced drain aura + Leadership | ✅ BUILT |

#### Heartwood (from Chaga) — 63g ✅ BUILT
- **HP**: 68 | **Mov**: 4 | **Align**: Neutral
- **Melee**: Club 10×3 (impact)
- **Ranged**: Spore Puff 12×1 (impact)
- **Ability**: Steadfast — 70% blade/pierce, 80% impact, 90% fire/arcane resistance
- **Role**: Ultimate wall. Matches the Sentinel in every stat, with earned fire/arcane resistance.
- **Based on**: Dwarvish Sentinel (63g, 68 HP, 4 mov, neutral, steadfast; spear 10×3 pierce, javelin 11×2 pierce; blade/pierce 30%, impact 20%, fire/cold/arcane 10%). Heartwood matches cost/HP/resists exactly, trades pierce for impact and 11×2 ranged for 12×1.

#### Hivemind (from Puppeteer) — 50g ✅ BUILT
- **HP**: 55 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Parasitic Touch 7×3 (blade) — **drain**
- **Ranged**: Mind Spore 7×3 (arcane)
- **Abilities**: Leadership + Parasitic Link (drain aura for adjacent allies)
- **Role**: Force multiplier. Adjacent allies deal +25% damage AND drain health. Glass cannon support — needs a tank in front.
- **Based on**: Dune Wayfarer (58g, 62 HP, 6 mov, liminal; axe 8×4 blade, bow 8×4 pierce). Hivemind trades 7 HP, 1 movement and raw damage for leadership + drain aura at -8g.

## Leaders (L2 units as starting leaders)

- **Sporeguard** — Defensive leader, slows attackers around keep ✅
- **Nightcap** — Aggressive leader, poisons everything nearby
- **Morel** — Support leader (Lion's Mane L2), heals recruits immediately ✅
- **Puppeteer** — Control leader, grants adjacent allies drain via parasitic link

## Balance Notes
- **Weakness**: Low raw damage. Loses straight 1v1 fights.
- **Strength**: Status effects compound. Slowed + poisoned enemies are dramatically weaker.
- **Counter-play**: Curing units (White Mage, Elvish Druid) hard-counter this faction.
- **Average L1 cost**: ~16g (comparable to other factions)
- **Average L1 HP**: ~25 (below average — fragile)
- **Chaotic alignment** means they fight best at night.

## Implementation Todos (Phase 1 — L1 units only)
1. [x] Define custom Mushroom Grove terrain type (terrain graphics, movement/defense tables)
2. [x] Define mushroom race in WML
3a. [x] Create passive Fungal Spread event (side turn event that converts hexes under Mycelium units)
3b. [x] Create kill-based Fungal Spread event (removed — replaced by plague system)
3c. [x] Create Grove Reanimation event (removed — replaced by plague system)
4. [x] Create L1 unit type .cfg files (8 units: Sporecap, Deathcap, Lion's Mane, Runner, Puffball, Glowcap, Cordyceps, Madcap)
5. [x] Define L1 weapon specials/abilities in macros (slow, poison, drain, heals, ambush, skirmisher, magical)
5b. [x] Create Fungal Spore unit type (spawned by plague)
6. [x] Create faction [multiplayer_side] definition
7. [x] Add faction to Fractured_Realms era (replace Rebels clone placeholder)
8. [ ] Test in-game for loading
9. [x] Add placeholder art (reuse existing sprites)

## Future Phases (general ideas, not implemented yet)
- **Phase 2**: L2 units with AoE abilities (death cloud, spore cloud, frost nova, enhanced healing)
- **Phase 3**: L3 units with combo AoE effects + expanded fungal spread radius
- **Phase 4**: ✅ DONE — Mushroom Forest overlay (`^Tff`, aliasof=_bas,Tt,Ft). Fungal Spread now converts forest overlays into Mushroom Forest instead of skipping them. Defined in `macros/mycelium-terrain.cfg`.

## Backlog
- [ ] Create custom sprite for Mushroom Forest (`^Tff`) — currently reuses `forest/mushrooms-tile` from Mushroom Grove. Needs a unique look that blends tree trunks with giant mushroom caps growing among/over branches.
- [x] Update unit internal naming convention — replaced `{HUMAN_NAMES}` with custom mushroom-themed name lists (mycological Latin-inspired names like Agarum, Boleth, Mycenae, etc.)
- [x] Healer unit idea: a support unit that grants adjacent allies **drain** on their attacks. → Implemented as Puppeteer's Parasitic Link aura.
- [x] Aura unit idea: a support unit that grants adjacent allies **plague** on their attacks. → Implemented as Broodcap's Fungal Brood aura.
- [ ] AoE attacks should have a custom icon so the player can tell at a glance which attack has splash damage.