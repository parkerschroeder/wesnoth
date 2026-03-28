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

### 3. Fungal Plague (Oyster Squire, Morel, Puffball, Spore)
- Unconditional plague — when these units kill an enemy, it rises as a Spore
- Uses the engine's built-in plague system (doesn't work on undead, mechanical, or villages)
- Spores are L0, fragile, and expendable — designed to die

### 4. Death Bloom (Spore + Puffball)
- When a unit with death bloom dies, ALL nearby hexes are converted to Mushroom Grove and adjacent enemies are poisoned
- This is the faction's primary territory expansion tool
- Creates the core loop: plague spawns spore → spore dies → death bloom spreads groves → more favorable terrain
- Spore (L0) advances to Puffball (L1) — same death bloom identity, upgraded body with skirmisher
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

### 1. Oyster Squire (Fighter) — 15g
- **Mushroom**: Generic toadstool warrior
- **HP**: 32 | **Mov**: 4 | **Align**: Chaotic
- **Melee**: Club 6×2 (impact) — **slow**
- **Ranged**: Spore Puff 3×2 (impact)
- **Role**: Faction tank. Tough and slow, holds the line while grove spreads. Slows enemies in melee to match its pace.
- **Based on**: Heavy Infantryman (high HP tank, slow movement, impact damage)
- **Sprite**: Custom (oystersquire.png)
- **Advances to**: Oyster Vizier (L2), Oyster Knight (L2)

### 2. Deathcap (Archer) — 15g
- **Mushroom**: Amanita (deadly poisonous)
- **HP**: 24 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Toxic Touch 3×2 (blade) — **poison**
- **Ranged**: Poison Dart 5×3 (pierce) — **poison**
- **Role**: Ranged poisoner/archer. Fragile but peppers enemies with venomous barbs from range. Poison is the real damage. Fast leveling at 24 XP.
- **Based on**: WoL Legion Archer (chaotic archer, poison variant)
- **Sprite**: Legion Archer
- **Advances to**: Stinking Dapperling (L2) / Inkcap (L2)

### 3. Lion's Mane (Healer) — 14g ✅ BUILT
- **Mushroom**: Lion's Mane (shaggy, cascading mushroom known for nerve regeneration)
- **HP**: 26 | **Mov**: 5 | **Align**: Neutral
- **Melee**: Staff 3×2 (impact)
- **Ranged**: Spore Puff 4×2 (impact) — **slow**
- **Ability**: Heals +4 (adjacent allies)
- **Role**: Faction healer. Restorative mushroom that mends wounded allies.
- **Based on**: Elvish Shaman (L1 healer, similar HP/mov)
- **Sprite**: Elvish Shaman
- **Advances to**: Shaggy Mane (L2, healer) / Bear's Head (L2, blight)
- **Unit ID**: Mycelium_Lions_Mane

### 4. Truffle (Scout) — 14g
- **Mushroom**: Mycelium network (underground fungal threads)
- **HP**: 26 | **Mov**: 8 | **Align**: Chaotic
- **Melee**: Tendril Lash 5×3 (blade)
- **Ranged**: —
- **Ability**: Ambush (hides in forest/cave)
- **Role**: Fast scout. Represents the underground mycelium spreading.
- **Based on**: Saurian Skirmisher (15g, 26 HP, 6 mov, chaotic, skirmisher; spear 4×4 pierce, spear 4×2 pierce ranged). Truffle matches HP/XP exactly, trades skirmisher + ranged for ambush + 2 extra movement at -1g.
- **Advances to**: Double Truffle (L2, overgrowth) / Portalbello (L2, teleport)

### 5. Puffball (Skirmisher) — 14g
- **Mushroom**: Puffball (releases spore cloud when disturbed)
- **HP**: 22 | **Mov**: 6 | **Align**: Chaotic
- **Melee**: Bump 3×3 (impact) — **plague**
- **Ability**: Skirmisher (ignores ZoC), Death Bloom
- **Role**: Cheap kamikaze flanker. Slips through lines via skirmisher, spreads plague on melee, detonates into grove spread on death. Advancement from Spore (L0).
- **Based on**: Footpad (cheap skirmisher, 14g, fragile)
- **Sprite**: WoL Greater Wisp (scaled-up wisp)
- **Advances to**: (dead-end L1)

### 6. Glowcap (Mage) — 16g
- **Mushroom**: Bioluminescent fungus (channels bioelectric energy)
- **HP**: 26 | **Mov**: 5 | **Align**: Neutral
- **Ranged**: Spark Bolt 9×2 (electric) — **magical**
- **Role**: Ranged damage dealer. Expensive but hits hard with electric/magical.
- **Based on**: Dark Adept / Mage (fragile magical ranged, 19g)
- **Sprite**: Custom (glowcap.png)
- **Advances to**: Earth Star (L2), Black Hole (L2)

### 7. Morel (Parasite) — 16g
- **Mushroom**: Cordyceps (parasitic, mind-controlling fungus)
- **HP**: 30 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Parasitic Touch 5×3 (blade) — **drain**
- **Ranged**: —
- **Role**: Melee-only drain fighter. Cheap and self-sustaining through drain, the only drain unit in the faction. Specializes at L2 into plague support (Morel Dilemma) or drain support (Morel Support).
- **Based on**: Dune Rover (14g, 32 HP, 5 mov, liminal; axe 4×3 blade, bow 5×3 pierce). Morel trades ranged and 2 HP for drain sustain at +2g.
- **Sprite**: Custom (morel.png)

### 8. Madcap (Berserker) — 19g ✅ BUILT
- **Concept**: A crazed dwarf hermit who discovered the rage-inducing fly agaric mushroom (*Amanita muscaria*) deep in the caves. Exiled by their clan, they now fight alongside the Mycelium — consuming grove mushrooms to fuel devastating berserk frenzies.
- **Race**: Dwarf (not mushroom — uses dwarf names, traits, movetype)
- **HP**: 34 | **Mov**: 5 | **Align**: Chaotic
- **Melee 1**: Mushroom Frenzy 4×4 (blade) — **berserk, grove bound** (consumes the grove)
- **Melee 2**: Hand Axe 4×4 (blade) — fallback when not on a grove
- **Role**: Conditional berserker. Devastating on a mushroom grove, average without one. Creates faction synergy — mushroom units spread groves, the Madcap consumes them for explosive burst damage. Does NOT spread groves passively (dwarf, no fungal_growth trait).
- **Based on**: Dwarvish Ulfserker (15g, 32 HP, 5 mov, neutral, berserk; hammer 9×3 impact; 30% blade/pierce, 10% impact/fire/cold/arcane). Madcap matches chassis, trades neutral for chaotic and adds grove-bound condition.
- **Sprite**: Dwarvish Ulfserker
- **Advances to**: Mad Prince (L2, chaotic, terror) → Mad Lord (L3) | Fungi (L2, neutral, leadership) → Fun Grandpa (L3)
- **Unit ID**: Mycelium_Madcap

## L2 Advancements

### Built

#### Oyster Vizier (from Oyster Squire) — 32g ✅ BUILT
- **HP**: 46 | **Mov**: 4 | **Align**: Chaotic
- **Melee**: Club 9×3 (impact) — **slow**
- **Ranged**: Spore Puff 6×2 (impact) — **slow**
- **Ability**: Spore Cloud — when this unit hits with its ranged attack, all enemy units adjacent to the **target** are also **slowed** (via `attacker_hits` event + dummy ability filter)
- **Role**: Crowd-control tank. Slows enemies in melee and at range. Can unleash AoE slow eruptions from groves.
- **Based on**: Iron Mauler (heavy L2 tank with CC)
- **Sprite**: Custom (oystervizier.png)

#### Oyster Knight (from Oyster Squire) — 32g ✅ BUILT
- **HP**: 53 | **Mov**: 4 | **Align**: Neutral
- **Melee**: Club 8×3 (impact)
- **Ranged**: Spore Puff 9×1 (impact)
- **Ability**: Steadfast — halves damage when not moving, 70% blade/pierce, 80% impact, 100% fire/arcane resistance
- **Role**: Pure wall. Dense, rock-hard fungus that absorbs punishment. The faction's anchor against both physical and elemental threats.
- **Based on**: Dwarvish Stalwart (30g, 59 HP, 4 mov, neutral, steadfast; spear 8×3 pierce, javelin 9×1 pierce; blade/pierce 20%, impact 20%, fire/cold/arcane 10%). Oyster Knight matches HP and ranged exactly, trades pierce for impact damage, has +10% blade/pierce resist but 0% fire/arcane (vs Stalwart's 10%).
- **Sprite**: Custom (oysterknight.png)
- **Advances to**: King Oyster (L3)

#### Mad Prince (from Madcap) — 28g ✅ BUILT
- **Race**: Dwarf
- **HP**: 44 | **Mov**: 5 | **Align**: Chaotic
- **Melee 1**: Mushroom Frenzy 7×4 (blade) — **berserk, grove bound**
- **Melee 2**: Hand Axe 7×4 (blade)
- **Ability**: Terror — adjacent enemies of lower level deal reduced damage (adapted from WoL Nightmares)
- **Role**: Enhanced berserker. Frenzy matches the Dwarvish Berserker's 7×4 pattern but remains grove-bound. Radiates a terror aura from the fly agaric psychoactive toxins, debuffing nearby lower-level enemies. AMLA advancement.
- **Based on**: Dwarvish Berserker (30g, 52 HP, 5 mov, neutral, berserk; hammer 7×4 impact). Mad Prince matches attack pattern exactly, trades neutral for chaotic and adds terror aura + grove-bound condition.
- **Sprite**: Dwarvish Berserker

#### Mad Lord (from Mad Prince) — 46g ✅ BUILT
- **Race**: Dwarf
- **HP**: 60 | **Mov**: 5 | **Align**: Chaotic
- **Melee 1**: Mushroom Frenzy 9×4 (blade) — **berserk, grove bound, fungal plague**
- **Melee 2**: Hand Axe 9×4 (blade) — **fungal plague**
- **Ability**: Terror
- **Role**: Plague berserker lord. Kills raise Spores while terror aura suppresses nearby enemies. The culmination of the Madcap line — a tyrant of madness whose victims fuel the mycelium's spread.
- **Based on**: Dwarvish Lord (40g, 73 HP, 5 mov, neutral; hammer 15×2 impact). Mad Lord trades raw HP/damage for plague + terror aura + grove-bound berserk.
- **Sprite**: Dwarvish Lord

#### Fungi (from Madcap) — 28g ✅ BUILT
- **Race**: Dwarf
- **HP**: 44 | **Mov**: 5 | **Align**: Neutral
- **Melee 1**: Mushroom Frenzy 6×4 (blade) — **berserk, grove bound**
- **Melee 2**: Hand Axe 6×4 (blade)
- **Ranged**: Spore Toss 4×3 (impact)
- **Ability**: Leadership — adjacent allies of lower level deal more damage
- **Role**: Guardian path. Where the Mad Prince descends deeper into madness, the Fungi channels mushroom visions into fierce protectiveness of the groves. Neutral alignment and leadership make it a support berserker that boosts the Mycelium's L1 units.
- **Based on**: Dwarvish Berserker (30g, 52 HP, 5 mov, neutral, berserk; hammer 7×4 impact). Fungi matches attack pattern, swaps terror for leadership and chaos for neutral.
- **Sprite**: Dwarvish Berserker

#### Fun Grandpa (from Fungi) — 46g ✅ BUILT
- **Race**: Dwarf
- **HP**: 60 | **Mov**: 5 | **Align**: Neutral
- **Melee 1**: Mushroom Frenzy 8×4 (blade) — **berserk, grove bound**
- **Melee 2**: Hand Axe 8×4 (blade)
- **Ranged**: Spore Toss 6×3 (impact)
- **Abilities**: Leadership, Regeneration
- **Role**: The living heart of the grove. Leadership rallies allies while regeneration keeps the Fun Grandpa standing through prolonged engagements. The boundary between dwarf and fungus has blurred — mycelial threads wind through their veins, granting unnatural resilience.
- **Based on**: Dwarvish Lord (40g, 73 HP, 5 mov, neutral; hammer 15×2 impact). Fun Grandpa trades raw damage for leadership + regeneration + grove synergy.
- **Sprite**: Dwarvish Lord

### Planned

| L1 Unit | L2 Name | Ability Gained | Status |
|---------|---------|---------------|--------|
| Deathcap | **Stinking Dapperling** | Poison Cloud: AoE poison attack (grove bound) | ✅ BUILT |
| Deathcap | **Inkcap** | Venom Strike: double damage vs poisoned (offense only) | ✅ BUILT |
| Lion's Mane | **Shaggy Mane** | Heals +8, Cures, Slow ranged — pure healer path | ✅ BUILT |
| Lion's Mane | **Bear's Head** | Blight (unhealable), AoE blight (grove bound) — offensive blight path | ✅ BUILT |
| Truffle | **Double Truffle** | Overgrowth (adjacent grove spread), Ambush, Entangle (slow) | ✅ BUILT |
| Truffle | **Portalbello** | Fungal Tunnel (personal teleport between grove/forest tiles), Disengage | ✅ BUILT |

#### Portalbello (from Truffle) — 30g ✅ BUILT
- **HP**: 38 | **Mov**: 8 | **Align**: Chaotic
- **Melee 1**: Tendril Lash 7×3 (blade)
- **Melee 2**: Entangle 5×2 (impact) — **slow**
- **Ability**: Disengage (1 move after attacking) + Fungal Tunnel (personal teleport between `*^Tf,*^Tff`)
- **XP**: 55
- **Role**: Mobile flanker that introduces the fungal teleport mechanic. Teaches the player to use mushroom groves as a teleport network before the L3 Fairy Ring upgrades it into an aura for allies. Disengage + teleport combo: attack, then use the 1 remaining move to teleport to a distant grove.
- **Based on**: Saurian Ambusher (22g, 38 HP, 7 mov, chaotic, skirmisher; spear 6×4 pierce, spear 5×2 pierce ranged). Portalbello matches HP/XP exactly, trades skirmisher + ranged for disengage + teleport at +8g.
- **Advances to**: Fairy Ring (L3 — teleport aura)
| Glowcap | **Earth Star** | Lightning Storm: AoE electric damage to adjacent enemies on attack | ✅ BUILT |
| Glowcap | **Black Hole** | Obscure + Feeding, arcane_focus void damage | ✅ BUILT |
| Morel | **Morel Support** | Parasitic Link: drain aura for adjacent allies | ✅ BUILT |

#### Morel Dilemma (from Morel) — 34g ✅ BUILT
- **HP**: 45 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Parasitic Touch 8×3 (blade) — **fungal plague** (kills spawn Spores)
- **Ability**: Fungal Brood — adjacent allies' attacks spawn Spores from slain enemies (plague aura)
- **XP**: 75
- **Role**: Melee plague fighter. Pure melee — no ranged. Gets into the thick of combat to proc plague spawns from its own kills and empower adjacent allies to do the same. Trades the Morel's drain sustain for army-generating plague.
- **Based on**: Dune Explorer (31g, 46 HP, 6 mov, liminal; axe 6×4 blade, bow 8×3 pierce). Morel Dilemma trades 1 HP, 1 movement and ranged for plague aura at +3g.
- **Sprite**: Custom (moreldilemma.png)
- **Advances to**: False Morel (L3)

#### Morel Support (from Morel) — 32g ✅ BUILT
- **HP**: 43 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Parasitic Touch 6×3 (blade) — **drain**
- **Ranged**: Mind Spore 5×3 (arcane)
- **Ability**: Parasitic Link — adjacent allies drain health from their attacks
- **XP**: 75
- **Role**: Drain support. Nearby allies self-sustain through combat. Complements the Morel Dilemma's army-building with army-sustaining.
- **Based on**: Dune Explorer (31g, 46 HP, 6 mov, liminal; axe 6×4 blade, bow 8×3 pierce). Morel Support trades 3 HP, 1 movement and raw damage for drain + drain aura at +1g.
- **Sprite**: Custom (morelsupport.png)
- **Advances to**: Morel Authority (L3)

#### Stinking Dapperling (from Deathcap) — 32g ✅ BUILT
- **HP**: 36 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Toxic Touch 6×2 (blade) — **poison**
- **Ranged 1**: Poison Dart 6×3 (pierce) — **poison**
- **Ranged 2**: Poison Cloud 6×3 (impact) — **poison, AoE poison (poison_cloud), grove bound**
- **Role**: Glass cannon AoE poisoner. Still fragile for L2 but now poisons clusters of enemies by channeling the grove network. Three attack options: safe ranged poison, melee poison, or devastating grove-powered poison cloud that poisons both the target and all adjacent enemies.
- **Based on**: Lich (fragile AoE caster, status effects)
- **Sprite**: Custom (stinkingdapperling.png)

#### Black Hole (from Glowcap) — 34g ✅ BUILT
- **HP**: 36 | **Mov**: 5 | **Align**: Chaotic | **Usage**: Archer
- **Melee**: Void Touch 5×2 (arcane_focus)
- **Ranged**: Void Bolt 9×3 (arcane_focus) — **magical**
- **Abilities**: Obscure (adjacent units fight as if time of day is one step darker), Feeding (+1 max HP per kill)
- **XP**: 100
- **Role**: Dark mage path. Where Earth Star channels electric energy outward, Black Hole collapses inward — absorbing light and life. Obscure shifts nearby combat one time-of-day step darker (helping chaotic units, hindering lawful units), while feeding makes it progressively tougher through kills. Uses WoL's arcane_focus damage type (inverted arcane resistance — hits hardest against arcane-resistant units).
- **Based on**: Dark Adept → Dark Sorcerer path (fragile chaotic mage with sustain). Black Hole trades raw damage for obscure + feeding utility.
- **Sprite**: Custom (blackhole.png)
- **Advances to**: Cosmic Shroom (L3)

#### Inkcap (from Deathcap) — 30g ✅ BUILT
- **HP**: 40 | **Mov**: 6 | **Align**: Chaotic
- **Melee**: Toxic Touch 4×2 (blade) — **poison**
- **Ranged**: Catalyst Spore 6×3 (pierce) — **toxic strike** (double damage vs poisoned enemies, offense only)
- **Role**: Ranged assassin/sniper. Melee poisons the target, then catalyst spores finish from range at 12×3 (36 damage) vs poisoned enemies. Works best with Deathcap or Stinking Dapperling to pre-poison targets. The attack has no poison itself — it's a pure finisher.
- **Based on**: Elvish Marksman (ranged-focused, conditional damage)
- **Sprite**: Custom (inkcap.png)

## L3 Advancements (enhanced AoE + combos)

| L2 Unit | L3 Name | Enhanced Ability | Status |
|---------|---------|-----------------|--------|
| Oyster Vizier | **Oyster Chamberlain** | AoE slow (no grove required) | ✅ BUILT |
| Stinking Dapperling | **Deadly Dapperling** | AoE poison + marksman, grove kills spawn 2 Spores | ✅ BUILT |
| Shaggy Mane | **Lawyer's Wig** | Cures + slow ranged + regenerates | ✅ BUILT |
| Bear's Head | **Bleeding Tooth** | Enhanced AoE blight + melee blight | ✅ BUILT |
| Inkcap | **Nightcap** | Marksman + enhanced catalyst spore (8×3, 16×3 vs poisoned) | ✅ BUILT |
| Double Truffle | **Trufflemaker** | Enhanced overgrowth + strong melee | ✅ BUILT |
| Portalbello | **Fairy Ring** | Mycelial network aura — adjacent allies can teleport between any fungal terrain tiles (`*^Tf,*^Tff`). Upgrades the Portalbello's personal teleport into an aura that grants it to nearby allies. Pure disengage + teleport (no overgrowth). Based on Saurian Flanker (42g, 54 HP, 8 mov, chaotic, skirmisher; spear 8×4 pierce). Fairy Ring matches HP/XP exactly, trades skirmisher + ranged for disengage + teleport aura at +4g. | ✅ BUILT |
| Earth Star | **Milky Way** | AoE lightning L3 | ✅ BUILT |
| Black Hole | **Cosmic Shroom** | Enhanced arcane_focus void + obscure + feeding | ✅ BUILT |
| Morel Dilemma | **False Morel** | Enhanced plague aura — melee-only, spawns Puffballs instead of Spores, 7 mov | ✅ BUILT |
| Morel Support | **Morel Authority** | Enhanced drain aura + Leadership | ✅ BUILT |

#### King Oyster (from Oyster Knight) — 63g ✅ BUILT
- **HP**: 62 | **Mov**: 4 | **Align**: Neutral
- **Melee**: Club 10×3 (impact)
- **Ranged**: Spore Puff 12×1 (impact)
- **Ability**: Steadfast — 70% blade/pierce, 80% impact, 90% fire/arcane resistance
- **Role**: Ultimate wall. Matches the Sentinel in every stat, with earned fire/arcane resistance.
- **Based on**: Dwarvish Sentinel (63g, 68 HP, 4 mov, neutral, steadfast; spear 10×3 pierce, javelin 11×2 pierce; blade/pierce 30%, impact 20%, fire/cold/arcane 10%). King Oyster matches cost/HP/resists exactly, trades pierce for impact and 11×2 ranged for 12×1.
- **Sprite**: Custom (kingoyster.png)

#### Cosmic Shroom (from Black Hole) — 50g ✅ BUILT
- **HP**: 44 | **Mov**: 5 | **Align**: Chaotic | **Usage**: Archer
- **Melee**: Void Touch 7×3 (arcane_focus)
- **Ranged**: Void Bolt 12×3 (arcane_focus) — **magical**
- **Abilities**: Obscure (adjacent units fight as if time of day is one step darker), Feeding (+1 max HP per kill)
- **Role**: The culmination of the void path. A walking singularity of pure arcane force that devours everything in its path. Reality bends around this alien horror, darkness pooling in its wake. Void blasts shred through defenses that would stop conventional arcane damage — arcane_focus hits hardest against units that resist arcane.
- **Based on**: Lich / Necromancer (L3 dark caster with sustain). Cosmic Shroom trades AoE for consistent high damage + obscure + feeding.
- **Sprite**: Custom (cosmicshroom.png)

#### Morel Authority (from Morel Support) — 50g ✅ BUILT
- **HP**: 55 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Parasitic Touch 7×3 (blade) — **drain**
- **Ranged**: Mind Spore 7×3 (arcane)
- **Abilities**: Leadership + Parasitic Link (drain aura for adjacent allies)
- **Role**: Force multiplier. Adjacent allies deal +25% damage AND drain health. Glass cannon support — needs a tank in front.
- **Based on**: Dune Wayfarer (58g, 62 HP, 6 mov, liminal; axe 8×4 blade, bow 8×4 pierce). Morel Authority trades 7 HP, 1 movement and raw damage for leadership + drain aura at -8g.
- **Sprite**: Custom (morelauthority.png)

## Leaders (L2 units as starting leaders)

Current faction config uses 5 L2 leaders (comparable to Knalgans default with 5, Northerners default with 5):

- **Earth Star** — Electric mage leader, AoE lightning from the keep. Sprite: Custom (earthstar.png).
- **Oyster Knight** — Steadfast wall leader, anchors the frontline. Sprite: Custom (oysterknight.png).
- **Morel Support** — Drain support leader, allies self-sustain near the keep. Sprite: Custom (morelsupport.png).
- **Fungi** — Leadership leader, buffs adjacent recruits. Sprite: Dwarvish Berserker.
- **Shaggy Mane** — Support/healer leader, keeps recruits alive. Sprite: Custom (shaggymane.png).

**Faction icon**: Oyster Knight (oysterknight.png)

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
4. [x] Create L1 unit type .cfg files (8 units: Oyster Squire, Deathcap, Lion's Mane, Truffle, Puffball, Glowcap, Morel, Madcap)
5. [x] Define L1 weapon specials/abilities in macros (slow, poison, drain, heals, ambush, skirmisher, magical)
5b. [x] Create Spore unit type (spawned by plague)
6. [x] Create faction [multiplayer_side] definition
7. [x] Add faction to Fractured_Realms era (replace Rebels clone placeholder)
8. [ ] Test in-game for loading
9. [x] Add placeholder art (reuse existing sprites)
10. [x] Create custom sprites for all mushroom units (28 units via gen_sprite.py)
11. [x] Add unit animations via WML macros (`macros/mycelium-animations.cfg`)

## Future Phases (general ideas, not implemented yet)
- **Phase 2**: L2 units with AoE abilities (death cloud, spore cloud, frost nova, enhanced healing)
- **Phase 3**: L3 units with combo AoE effects + expanded fungal spread radius
- **Phase 4**: ✅ DONE — Mushroom Forest overlay (`^Tff`, aliasof=_bas,Tt,Ft). Fungal Spread now converts forest overlays into Mushroom Forest instead of skipping them. Defined in `macros/mycelium-terrain.cfg`.

## Backlog
- [ ] Create custom sprite for Mushroom Forest (`^Tff`) — currently reuses `forest/mushrooms-tile` from Mushroom Grove. Needs a unique look that blends tree trunks with giant mushroom caps growing among/over branches.
- [x] Update unit internal naming convention — replaced `{HUMAN_NAMES}` with custom mushroom-themed name lists (mycological Latin-inspired names like Agarum, Boleth, Mycenae, etc.)
- [x] Healer unit idea: a support unit that grants adjacent allies **drain** on their attacks. → Implemented as Morel Support's Parasitic Link aura.
- [x] Aura unit idea: a support unit that grants adjacent allies **plague** on their attacks. → Implemented as Morel Dilemma's Fungal Brood aura.
- [ ] AoE attacks should have a custom icon so the player can tell at a glance which attack has splash damage.
- Madcap line (Madcap, Mad Prince, Mad Lord, Fungi, Fun Grandpa) intentionally uses stock dwarf sprites — no custom sprites or animations planned
- Wisp units (Spore, Puffball) intentionally use stock elvish wisp sprites — no custom sprites or animations planned

## Unit Animations

All 28 mushroom-sprite units have single-image animations defined via macros in `macros/mycelium-animations.cfg`. No extra sprite frames are needed — animations use WML offset, alpha, and submerge attributes.

### Available Macros

| Macro | Effect | Used by |
|-------|--------|---------|
| `MUSHROOM_DEFEND` | Recoil backward on hit/miss | Truffle line, Morel line, Poison line, Healer/Blight line |
| `MUSHROOM_DEFEND_BLINK` | Recoil + alpha fade | Glowcap line (ethereal/glowing units) |
| `MUSHROOM_DEATH` | Fade to transparent | Most units |
| `MUSHROOM_DEATH_SINK` | Fade + sink into ground | Oyster line (heavy/rooted) |
| `MUSHROOM_ATTACK_MELEE` | Lunge forward + return | All melee attacks |
| `MUSHROOM_ATTACK_MELEE_BERSERK` | Aggressive lunge | (available, unused — Madcap line uses dwarf sprites) |
| `MUSHROOM_ATTACK_RANGED` | Rock back + projectile | (available, unused — no mushroom units have visible projectiles) |
| `MUSHROOM_ATTACK_RANGED_MAGIC` | Rock back, no projectile | All ranged attacks (spores, lightning, etc.) |
| `MUSHROOM_IDLE_GLOW` | Alpha breathing pulse | (available, unused — removed from all units) |
| `MUSHROOM_IDLE_SWAY` | Side-to-side drift | (available, unused) |

### Animation Assignments

- **Truffle line** (Truffle, Double Truffle, Trufflemaker, Portalbello, Fairy Ring): DEFEND + DEATH + MELEE lunge
- **Oyster line** (Oyster Squire/Vizier/Chamberlain, Oyster Knight, King Oyster): DEFEND + DEATH_SINK + MELEE club + RANGED_MAGIC spore
- **Glowcap line** (Glowcap, Earth Star, Milky Way, Black Hole, Cosmic Shroom): DEFEND_BLINK + DEATH + MELEE shock + RANGED_MAGIC lightning
- **Morel line** (Morel, Morel Dilemma/Support, Morel Authority, False Morel): DEFEND + DEATH + MELEE drain/plague + RANGED_MAGIC spore (Support/Authority only)
- **Poison line** (Deathcap, Stinking/Deadly Dapperling, Inkcap, Nightcap): DEFEND + DEATH + MELEE toxic + RANGED_MAGIC dart/cloud
- **Healer line** (Lion's Mane, Shaggy Mane, Lawyer's Wig): DEFEND + DEATH + MELEE staff + RANGED_MAGIC spore
- **Blight line** (Bear's Head, Bleeding Tooth): DEFEND + DEATH + MELEE staff + RANGED_MAGIC blight
- **Madcap line** (5 dwarf units): no custom animations (uses existing dwarf sprites)
- **Wisps** (Spore, Puffball): no custom animations (uses existing wisp sprites)

## Full Advancement Tree

```
Spore (L0 flying plague token)
└─ Puffball (L1 flying skirmisher, death bloom, AMLA only)

Oyster Squire (L1 slow frontline)
├─ Oyster Vizier (L2 AoE slow eruption)
│  └─ Oyster Chamberlain (L3 AoE slow, no grove required)
└─ Oyster Knight (L2 steadfast tank)
   └─ King Oyster (L3 ultimate wall)

Morel (L1 parasitic drain fighter)
├─ Morel Dilemma (L2 plague aura — allies spawn Spores from kills)
│  └─ False Morel (L3 enhanced plague — allies spawn Puffballs) — ✅ BUILT
└─ Morel Support (L2 drain aura — allies drain)
   └─ Morel Authority (L3 drain aura + leadership) — ✅ BUILT

Deathcap (L1 ranged poisoner)
├─ Stinking Dapperling (L2 AoE poison, grove bound)
│  └─ Deadly Dapperling (L3 AoE poison marksman)
└─ Inkcap (L2 toxic strike, double vs poisoned)
   └─ Nightcap (L3 marksman sniper) — ✅ BUILT

Lion's Mane (L1 healer)
├─ Shaggy Mane (L2 cures healer)
│  └─ Lawyer's Wig (L3 healer + regen)
└─ Bear's Head (L2 anti-heal blight)
   └─ Bleeding Tooth (L3 enhanced blight)

Glowcap (L1 electric mage)
├─ Earth Star (L2 AoE lightning)
│  └─ Milky Way (L3 AoE lightning)
└─ Black Hole (L2 arcane void mage)
   └─ Cosmic Shroom (L3 arcane void apex)

Truffle (L1 fast ambush scout)
├─ Double Truffle (L2 overgrowth raider)
│  └─ Trufflemaker (L3 overgrowth brute) — ✅ BUILT
└─ Portalbello (L2 teleport + disengage)
   └─ Fairy Ring (L3 teleport aura) — ✅ BUILT

Madcap (L1 dwarf berserker)
├─ Mad Prince (L2 terror berserker)
│  └─ Mad Lord (L3 plague berserker lord)
└─ Fungi (L2 leadership berserker)
   └─ Fun Grandpa (L3 leadership + regen)
```
