# Plan: Werefolk Faction for Wesnoth

## Concept
A werefolk-themed faction focused on aggressive melee combat and spreading lycanthropy through the enemy army. Fast, hard-hitting units that overwhelm through pack coordination and enemy conversion. Where the Mycelium controls territory, the Werefolk control the enemy army itself — turning fallen foes into new packmates.

**Core mechanic — Lycanthropy:** Werefolk units with "Lycanthropic Bite" mark enemies with a cursed status when they land a hit. If any Werefolk unit kills a cursed enemy, it rises as a Thrall (L0 werefolk). This two-step plague rewards coordinated pack hunting — one unit bites, another finishes the kill, and the pack grows.

## Current State
- Mycelium faction complete in Fractured_Realms add-on
- Next: Build the Werefolk as a second custom faction in the same era

## Faction Identity
- **Name**: The Werefolk
- **Alignment**: Chaotic (creatures of the night, strongest in darkness)
- **Terrain affinity**: Forest, Hills, Cave (terrain_liked = Ww, Hh, Uu — wolves are woodland/highland predators)
- **Playstyle**: Aggressive melee swarm with enemy conversion. Fast units close distance quickly and spread lycanthropy through combat. Strong at night, vulnerable to fire and arcane. Rewards aggressive play, punishes passive opponents who let cursed units die.
- **Racial weaknesses**: Fire 130%, Arcane 110% (silver/holy — classic werefolk vulnerability)
- **Racial immunities**: None (unlike Mycelium's poison immunity — werefolk are flesh and blood)

## Faction Contrast: Mycelium vs Werefolk
| Dimension | Mycelium | Werefolk |
|-----------|----------|------|
| Core mechanic | Terrain conversion (groves) | Enemy conversion (lycanthropy) |
| Spread type | Passive (turn start) | Active (through combat) |
| Playstyle | Defensive, outlast | Aggressive, swarm |
| Speed | Slow (4-5 mov) | Fast (6-8 mov) |
| HP | Low (~25 avg L1) | Medium (~28 avg L1) |
| Ranged | Decent | Weak (melee-focused) |
| Status effects | Poison, slow, blight | Lycanthropy, fear |
| Weakness | Fire | Fire, Arcane |
| Spawn mechanic | Plague (instant on kill) | Lycanthropy (bite → nightfall transformation) |

## Lycanthropy Mechanic

### 1. Lycanthropic Bite (weapon special)
- Applied as a weapon special on specific melee attacks (like poison)
- When the attack hits, marks the enemy with "lycanthropy" status
- Visual indicator on the cursed unit (like the poison vial but wolf-themed)
- Does NOT deal damage over time like poison — it's a strategic marker
- Implementation: custom WML weapon special that sets a unit variable (`lycanthropy_cursed=yes`) via `attacker_hits` event
- Does NOT work on: undead, mechanical (same restrictions as plague)

### 2. Nightfall Transformation (time of day event)
- At dusk (transition to night), ALL cursed enemy units temporarily transform into Thralls
- The original unit is stored in a WML variable (full state: HP, XP, status effects, etc.)
- The Thrall spawns on the same hex, loyal to the Werefolk player's side
- The Thrall is a fixed L0 body — no XP gain or advancement while transformed
- Implementation: `time_of_day` event (or `turn_refresh` checking ToD) stores cursed units via `[store_unit]`, replaces them with Thralls via `[unstore_unit]`

### 3. Dawn Reversion (time of day event)
- At dawn (transition to day), ALL transformed Thralls revert to their original units
- The original unit is restored from the WML variable on the same hex, still cursed
- HP damage carries over proportionally — if the Thrall took 50% of its HP in damage, the original reverts at 50% HP
- If the Thrall dies during the night → the original unit is permanently dead (the curse consumed them)
- Implementation: `time_of_day` event restores stored units via `[unstore_unit]`, kills any Thralls that were transformed

### 4. Curing Lycanthropy
- Village healing removes the curse (like poison) — must happen during daytime before nightfall
- Healer units with "cures" ability (L2+) remove the curse
- This provides clear counterplay — White Mage, Elvish Druid, etc. hard-counter the mechanic
- The curse persists across night/day cycles until cured — a unit will keep transforming every night

### 5. Strategic Depth
- **Ticking clock**: Every bite starts a countdown to nightfall. The enemy must cure before dusk or lose control of that unit for the entire night phase.
- **Night chaos**: During night, the Werefolk player gets a swarm of bonus Thralls fighting alongside their army. The enemy's own units are turned against them.
- **Dawn recovery**: Cursed units return at dawn, but weakened by any damage the Thrall took. A rough night can leave the enemy's army crippled even after reversion.
- **Permanent death risk**: If the enemy (or anyone) kills the Thrall form at night, the original unit is gone forever. The enemy must be careful not to kill their own transformed allies.
- **Counterplay**: Cure before nightfall (villages, healers). Kill the biters before they spread the curse. Undead/mechanical are immune. Fight primarily during the day to minimize transformation windows.
- **Snowball potential**: More bites → more Thralls at night → more biters → more bites. Balanced by the fact that Thralls revert at dawn and curing is accessible.

## Pack Tactics Mechanic
- L2+ alpha-tier units gain "Pack Leader" (leadership variant) — adjacent lower-level allies deal more damage
- This replaces the Mycelium's territorial buff with a positional buff — the pack must stay clustered
- Creates tension: spread out to bite more enemies vs. cluster for pack leader bonuses

## Movement Type: wolfpaw
- Fast on flat terrain (1 MP), forest (1 MP), hills (2 MP)
- Decent in caves (2 MP), sand (2 MP)
- Slow in water (3 MP), swamp (3 MP), mountains (4 MP)
- Impassable: deep water, lava
- Defense: forest 40%, hills 40%, cave 40%, flat 40%, village 50%
- Generally mobile but not exceptionally defensive anywhere — wolves survive by speed, not by holding ground

## Race: Werefolk
- Custom race with themed name generator
- Traits: Strong, Quick, Resilient, Dextrous (standard pool)
- Not undead, not mechanical — fully living (susceptible to poison, plague)

## Thrall (L0 Transformed Unit)
- **HP**: 16 | **Mov**: 6 | **Align**: Chaotic | **XP**: — | **Cost**: 8
- **Melee**: Claws 3×3 (blade) — **lycanthropic bite**
- **Role**: Temporary werefolk form of a cursed enemy unit. Appears at nightfall, reverts at dawn. Fragile but carries the curse — can bite more enemies during the night to spread lycanthropy further. Cannot gain XP or advance (it's a temporary body, not a permanent unit). If killed at night, the original unit dies permanently.
- **Advances to**: — (temporary form, no advancement)
- **Note**: The Thrall is also used as a recruitable unit. When recruited directly (not transformed), it functions as a normal L0 with XP gain and advances to Feral (L1).

---

## L1 Recruits

### 1. Warg (Fighter) — 15g
- **Concept**: Massive wolf, the pack's warhound. Not a rider — the wolf IS the unit.
- **HP**: 34 | **Mov**: 7 | **XP**: 38 | **Align**: Chaotic
- **Melee**: Fangs 6×3 (blade) — **lycanthropic bite**
- **Role**: Core fighter. Fast, tough, spreads lycanthropy. The backbone of the faction — gets in, bites, holds the line. High movement lets it reach enemies that other factions' fighters can't.
- **Based on**: Wolf Rider (fast melee, mounted-speed movement). Warg trades the rider for tankier stats and lycanthropic bite.
- **Advances to**: Dire Warg (L2, tankier + first strike), Alpha Warg (L2, leadership + howl)

### 2. Howler (Debuffer/Support) — 15g
- **Concept**: A gaunt, grey wolf that weaponizes its howl as a supernatural ranged attack.
- **HP**: 28 | **Mov**: 6 | **XP**: 34 | **Align**: Chaotic
- **Melee**: Claws 4×2 (blade)
- **Ranged**: Howl 5×2 (cold) — **slow**
- **Role**: The faction's primary ranged option. Slows enemies from range so melee biters can close in. Fragile — stays behind the Wargs. Cold damage punishes fire-resistant units that counter the pack's melee.
- **Based on**: Elvish Shaman ranged (slow support, similar stat line). Howler trades healing for cold ranged damage + slow.
- **Advances to**: Dread Howler (L2, AoE slow), Wailing Wolf (L2, cold damage specialist)

### 3. Herbalist (Healer) — 14g
- **Concept**: A human herb-woman who lives among the werefolk. Not a werefolk herself — she chose this life, tending the pack's wounds with forest remedies and earning their trust.
- **Race**: Human (not Werefolk — uses human names, traits, movement type)
- **HP**: 24 | **Mov**: 5 | **XP**: 32 | **Align**: Neutral
- **Melee**: Staff 4×2 (impact)
- **Ranged**: Herb Poultice 3×2 (impact) — **slow**
- **Ability**: Heals +4 (adjacent allies)
- **Role**: Faction healer. Like the Mycelium's Lion's Mane — essential support. Neutral alignment means she's consistent across day/night, unlike the rest of the chaotic pack. Human among wolves, similar to the Madcap's dwarf-among-mushrooms niche.
- **Based on**: Elvish Shaman (L1 healer, 15g, 26 HP, 5 mov), Village Healer. Herbalist trades 2 HP for -1g cost.
- **Advances to**: Pack Shaman (L2, heals +8 + cures), Wolfsbane Witch (L2, offensive poison/blight)

### 4. Shadow Wolf (Scout) — 14g
- **Concept**: A sleek, dark-furred wolf that moves like smoke through the trees. Invisible at night.
- **HP**: 26 | **Mov**: 8 | **XP**: 30 | **Align**: Chaotic
- **Melee**: Fangs 5×3 (blade) — **backstab**
- **Ability**: Nightstalk (invisible at night unless adjacent to enemy)
- **Role**: Fast scout and assassin. 8 movement + nightstalk makes it the faction's eyes — scouting enemy positions, grabbing undefended villages, and picking off wounded stragglers with backstab. No lycanthropic bite at L1 — pure utility. Gains it at L2.
- **Based on**: Saurian Skirmisher (15g, 26 HP, 6 mov, chaotic, skirmisher). Shadow Wolf trades skirmisher for nightstalk + 2 extra movement at -1g.
- **Advances to**: Phantom Wolf (L2, teleport + nightstalk), Dire Stalker (L2, backstab + ambush specialist)

### 5. Feral (Skirmisher) — 13g
- **Concept**: A young, impulsive werefolk — recently turned and still wild. Advancement from Thrall, also recruitable.
- **HP**: 22 | **Mov**: 7 | **XP**: 28 | **Align**: Chaotic
- **Melee**: Savage Claws 4×4 (blade) — **lycanthropic bite**
- **Ability**: Skirmisher (ignores ZoC)
- **Role**: Cheap expendable flanker. Slips through enemy lines via skirmisher to bite backline units. Similar to the Mycelium's Puffball — cheap, fast, expendable, spreads the faction mechanic. Dies easily but every bite creates conversion potential.
- **Based on**: Footpad (14g, 24 HP, 6 mov, chaotic, skirmisher). Feral trades 2 HP for lycanthropic bite + 1 movement at -1g.
- **Advances to**: (dead-end L1 — already an advancement from Thrall)

### 6. Moon Priest (Mage) — 16g
- **Concept**: A robed figure who channels the moon's cold light into destructive beams. Half-wolf, half-scholar — the pack's connection to the supernatural.
- **HP**: 24 | **Mov**: 5 | **XP**: 36 | **Align**: Chaotic
- **Melee**: Moonblade 4×2 (cold)
- **Ranged**: Moonbeam 7×2 (cold) — **magical**
- **Role**: Magical damage dealer. Expensive but necessary — hits ethereal and high-defense targets that physical melee can't touch. Cold/magical is the faction's answer to ghosts and heavy armor.
- **Based on**: Dark Adept (17g, 24 HP, 5 mov, chaotic; chill wave 5×2 cold ranged). Moon Priest matches the chassis, trades shadow wave for stronger moonbeam at -1g.
- **Advances to**: Lunar Oracle (L2, illumination control + AoE), Eclipse Seer (L2, obscure + feeding)

### 7. Blood Fang (Drain Fighter) — 16g
- **Concept**: A massive scarred werefolk that feeds on the lifeforce of its prey. The faction's most feared hunter.
- **HP**: 32 | **Mov**: 6 | **XP**: 38 | **Align**: Chaotic
- **Melee**: Draining Bite 6×3 (blade) — **drain**
- **Ranged**: —
- **Role**: Melee-only drain fighter. Self-sustaining through combat — stays healthy as long as it keeps fighting. No ranged forces aggressive positioning. The faction's answer to sustained engagements where healer support is spread thin. Similar to the Mycelium's Morel (melee drain).
- **Based on**: Dune Rover (14g, 32 HP, 5 mov, liminal; axe 4×3 blade, bow 5×3 pierce). Blood Fang trades ranged and 1 movement for drain at +2g.
- **Advances to**: Bloodlord (L2, drain + lycanthropic bite), Packbound (L2, drain aura for allies)

### 8. Ravager (Berserker) — 19g
- **Concept**: A werefolk consumed by bloodlust — permanently stuck mid-transformation, a towering horror of fur and fury. The faction's most dangerous weapon, and its most unpredictable.
- **HP**: 36 | **Mov**: 5 | **XP**: 44 | **Align**: Chaotic
- **Melee**: Rend 7×3 (blade) — **berserk**
- **Role**: High-risk melee powerhouse. Berserk fights until one combatant drops — devastating against low-HP targets, suicidal against tanks. The faction's burst damage option. Expensive but worth it when it connects.
- **Based on**: Dwarvish Ulfserker (15g, 32 HP, 5 mov, neutral, berserk; hammer 9×3 impact). Ravager matches chassis, trades neutral for chaotic and impact for blade at +4g (reflecting higher HP and faction tax).
- **Advances to**: Abomination (L2, berserk + regeneration), Primal Alpha (L2, berserk + leadership)

---

## L2 Advancements

### From Warg

#### Dire Warg — ~32g
- **HP**: 48 | **Mov**: 7 | **Align**: Chaotic
- **Melee**: Fangs 8×3 (blade) — **lycanthropic bite, first strike**
- **Role**: Enhanced fighter. Tankier, hits harder, strikes first. A massive wolf that can bite and kill in the same engagement. First strike makes it dangerous to engage in melee.
- **Advances to**: Fenrir (L3)

#### Alpha Warg — ~32g
- **HP**: 44 | **Mov**: 7 | **Align**: Chaotic
- **Melee**: Fangs 7×3 (blade) — **lycanthropic bite**
- **Ranged**: Rallying Howl 5×2 (cold)
- **Ability**: Leadership (adjacent lower-level allies deal bonus damage)
- **Role**: Alpha leader. Trades raw combat power for army-wide buff. Positions in the center of the group to maximize leadership radius. The faction's force multiplier.
- **Advances to**: Pack Lord (L3)

### From Howler

#### Dread Howler — ~30g
- **HP**: 38 | **Mov**: 6 | **Align**: Chaotic
- **Melee**: Claws 6×2 (blade)
- **Ranged**: Dread Howl 7×2 (cold) — **slow, AoE slow** (slows adjacent enemies on hit, similar to Oyster Vizier's Spore Cloud)
- **Role**: AoE crowd control. The howl reverberates, slowing multiple enemies. Makes the faction's melee rush devastating — a slowed enemy can't escape.
- **Advances to**: Howl of Doom (L3)

#### Wailing Wolf — ~30g
- **HP**: 36 | **Mov**: 6 | **Align**: Chaotic
- **Melee**: Frost Claws 5×3 (cold)
- **Ranged**: Wail 9×3 (cold) — **magical**
- **Role**: Ranged damage specialist. Sacrifices the Dread Howler's crowd control for raw cold/magical damage output. The pack's answer to ethereal threats and heavy armor.
- **Advances to**: Banshee Wolf (L3)

### From Herbalist

#### Pack Shaman — ~28g
- **Race**: Human
- **HP**: 36 | **Mov**: 5 | **Align**: Neutral
- **Melee**: Staff 5×2 (impact)
- **Ranged**: Herb Poultice 5×2 (impact)
- **Abilities**: Heals +8, Cures (removes poison AND lycanthropy from allies)
- **Role**: Upgraded healer. Cures is critical — both for removing poison from your own units and as a flavor element (the Shaman understands the curse well enough to manage it). Essential support.
- **Advances to**: Elder Shaman (L3)

#### Wolfsbane Witch — ~28g
- **Race**: Human
- **HP**: 34 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Toxic Touch 5×2 (blade) — **poison**
- **Ranged**: Hex Bolt 7×3 (arcane)
- **Role**: Offensive caster path. The herbalist who delved too deep into the faction's dark magic. Poison melee + arcane ranged provides damage types the pack otherwise lacks. Chaotic alignment (unlike the neutral Pack Shaman) — she's fully embraced the darkness.
- **Advances to**: Crone (L3)

### From Shadow Wolf

#### Phantom Wolf — ~30g
- **HP**: 34 | **Mov**: 8 | **Align**: Chaotic
- **Melee**: Fangs 7×3 (blade) — **backstab, lycanthropic bite**
- **Abilities**: Nightstalk, Teleport (between forest tiles at night — WML event on move, similar to Portalbello's Fungal Tunnel but restricted to nighttime)
- **Role**: Nighttime assassin. Teleports between forests at night to strike deep behind enemy lines, biting high-value targets. Terrifying during night phases, manageable during day.
- **Advances to**: Specter Wolf (L3)

#### Dire Stalker — ~30g
- **HP**: 38 | **Mov**: 7 | **Align**: Chaotic
- **Melee**: Fangs 8×3 (blade) — **backstab**
- **Ability**: Nightstalk, Ambush (hides in forest)
- **Role**: Ambush predator. Sits hidden in forest, waits for enemies to walk past, then strikes with backstab. More defensive/patient than the Phantom Wolf's aggressive teleporting.
- **Advances to**: Apex Predator (L3)

### From Moon Priest

#### Lunar Oracle — ~34g
- **HP**: 34 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Moonblade 6×2 (cold)
- **Ranged**: Lunar Cascade 9×3 (cold) — **magical**
- **Ability**: Illuminates -1 (dims surrounding hexes — makes it darker, benefiting chaotic allies)
- **Role**: Darkness manipulator. Shifts the local time of day one step darker, boosting the entire chaotic pack while hindering lawful enemies. A walking eclipse.
- **Advances to**: Blood Moon (L3)

#### Eclipse Seer — ~34g
- **HP**: 32 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Void Claw 6×2 (arcane)
- **Ranged**: Eclipse Bolt 8×3 (arcane) — **magical**
- **Abilities**: Obscure (adjacent units fight as if one step darker), Feeding (+1 max HP per kill)
- **Role**: Arcane void path. Trades cold for arcane damage and gains sustain through feeding. Obscure aura protects adjacent allies by darkening their hexes.
- **Advances to**: Void Moon (L3)

### From Blood Fang

#### Bloodlord — ~34g
- **HP**: 46 | **Mov**: 6 | **Align**: Chaotic
- **Melee**: Draining Bite 8×3 (blade) — **drain, lycanthropic bite**
- **Role**: Ultimate individual fighter. Drain keeps it alive, lycanthropic bite ensures kills generate Thralls. A self-sustaining conversion engine. No ranged — must be in melee to function.
- **Advances to**: Lycan King (L3)

#### Packbound — ~32g
- **HP**: 42 | **Mov**: 6 | **Align**: Chaotic
- **Melee**: Parasitic Bite 6×3 (blade) — **drain**
- **Ranged**: Blood Howl 5×2 (cold)
- **Ability**: Parasitic Link (drain aura — adjacent allies' attacks drain health)
- **Role**: Drain support. Like the Mycelium's Morel Support — nearby allies self-sustain through combat. Gains a ranged attack for safer positioning. The faction's sustain engine.
- **Advances to**: Blood Alpha (L3)

### From Ravager

#### Abomination — ~36g
- **HP**: 52 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Rend 9×3 (blade) — **berserk**
- **Ability**: Regeneration (+8 HP per turn)
- **Role**: Unstoppable horror. Berserk + regeneration means it can fight recklessly and heal between engagements. A relentless meat grinder that's nearly impossible to trade efficiently against.
- **Advances to**: Lycanthrope (L3)

#### Primal Alpha — ~36g
- **HP**: 48 | **Mov**: 6 | **Align**: Chaotic
- **Melee**: Rend 8×3 (blade) — **berserk, lycanthropic bite**
- **Ability**: Leadership
- **Role**: Berserker + pack leader hybrid. Lower raw stats than Abomination but provides leadership and lycanthropic bite. Leads from the front — berserk charges spread the curse while leadership buffs adjacent allies.
- **Advances to**: Primal Lord (L3)

---

## L3 Advancements (enhanced abilities + combos)

| L2 Unit | L3 Name | Enhanced Ability |
|---------|---------|-----------------|
| Dire Warg | **Fenrir** | First strike + charge, massive HP pool |
| Alpha Warg | **Pack Lord** | Leadership + AoE lycanthropic bite aura (adjacent allies' attacks spread lycanthropy) |
| Dread Howler | **Howl of Doom** | AoE slow + fear (enemies deal reduced damage) |
| Wailing Wolf | **Banshee Wolf** | Marksman cold ranged + drains |
| Pack Shaman | **Elder Shaman** | Heals +12, Cures, regeneration aura |
| Wolfsbane Witch | **Crone** | Poison + arcane + curse amplification (cursed enemies transform into stronger werefolk forms at night) |
| Phantom Wolf | **Specter Wolf** | Teleport at any time of day + backstab + bite |
| Dire Stalker | **Apex Predator** | Enhanced backstab (3× damage) + ambush + nightstalk |
| Lunar Oracle | **Blood Moon** | Illuminates -2 (deeper darkness) + AoE cold |
| Eclipse Seer | **Void Moon** | Enhanced obscure + feeding + arcane AoE |
| Bloodlord | **Lycan King** | Drain + bite + leadership — the ultimate alpha |
| Packbound | **Blood Alpha** | Enhanced drain aura + leadership |
| Abomination | **Lycanthrope** | Berserk + regeneration + fearless + massive stats |
| Primal Alpha | **Primal Lord** | Leadership + berserk + bite + AoE howl |

(L3 details to be designed after L1 and L2 are built and balanced.)

---

## Leaders (L2 units as starting leaders)

5 leaders to match Mycelium leader count:

- **Alpha Warg** — Leadership from the keep, buffs recruits immediately. Aggressive leader choice.
- **Pack Shaman** — Healer leader, keeps recruits alive. Defensive leader choice.
- **Lunar Oracle** — Darkness manipulation from the keep, benefits all chaotic recruits. Mage leader.
- **Bloodlord** — Self-sustaining drain fighter. Solo leader for aggressive play.
- **Primal Alpha** — Leadership + berserk + bite. High-risk high-reward leader.

**Faction icon**: Alpha Warg or Bloodlord (TBD based on sprite)

---

## Balance Notes
- **Weakness**: Very limited ranged options. Howler and Moon Priest are the only ranged units. Archers and mages can kite the faction.
- **Weakness**: Fire 130% and Arcane 110% — Drake and Holy/Mage factions counter the faction.
- **Strength**: Speed. Most units have 6-8 movement, closing distance quickly and forcing engagements.
- **Strength**: Lycanthropy snowball. Once the curse spreads, the enemy faces impossible choices every night cycle — cure before dusk (spend tempo on villages/healers) or lose control of cursed units until dawn.
- **Strength**: Night dominance. Chaotic damage bonus + nightfall transformations make night phases devastating. The faction effectively gets free units every night.
- **Counterplay**: Healer units with "cures" (White Mage, Elvish Druid, Pack Shaman mirror) negate lycanthropy entirely. Fighting primarily during the day minimizes transformation windows. Undead/mechanical are immune.
- **Average L1 cost**: ~15.25g (comparable to other factions)
- **Average L1 HP**: ~28.25 (slightly above average — wolves are tough)
- **Chaotic alignment** means night phases are doubly critical — both damage bonus AND lycanthropy transformations activate.

---

## Implementation Todos (Phase 1 — L1 units only)
1. [ ] Define `werefolk` race in WML (race definition, name generators, traits)
2. [ ] Define `wolfpaw` movement type (movement costs, defense, resistances)
3. [ ] Create lycanthropy events macro file:
   - [ ] `WEAPON_SPECIAL_LYCANTHROPIC_BITE` — weapon special that marks enemies via `attacker_hits` event
   - [ ] Nightfall transformation event — `time_of_day` event at dusk stores cursed enemy units, replaces with Thralls loyal to Werefolk player
   - [ ] Dawn reversion event — `time_of_day` event at dawn restores original units from stored variables, applies proportional HP damage
   - [ ] Thrall death handler — if Thrall (transformed) dies at night, permanently kill the stored original
   - [ ] Lycanthropy cure event — villages and healers with "cures" remove the curse during daytime
   - [ ] Visual indicator for cursed status
4. [ ] Create L1 unit type .cfg files (8 units + Thrall):
   - [ ] Thrall (L0 — dual-purpose: transformed form at night + recruitable unit)
   - [ ] Warg (Fighter)
   - [ ] Howler (Debuffer)
   - [ ] Herbalist (Healer)
   - [ ] Shadow Wolf (Scout)
   - [ ] Feral (Skirmisher)
   - [ ] Moon Priest (Mage)
   - [ ] Blood Fang (Drain)
   - [ ] Ravager (Berserker)
5. [ ] Create faction .cfg file (leader list, recruit list, AI recruitment pattern)
6. [ ] Add faction to Fractured_Realms era definition
7. [ ] Playtest L1 balance — especially lycanthropy transformation timing and Thrall strength

## Implementation Todos (Phase 2 — L2 units)
8. [ ] Create L2 unit type .cfg files (14 units)
9. [ ] Implement L2 abilities:
   - [ ] AoE slow howl (Dread Howler)
   - [ ] Leadership (Alpha Warg, Primal Alpha)
   - [ ] Teleport between forests at night (Phantom Wolf)
   - [ ] Illuminates -1 (Lunar Oracle)
   - [ ] Obscure + Feeding (Eclipse Seer)
   - [ ] Parasitic Link / drain aura (Packbound)
   - [ ] Cures (Pack Shaman)
10. [ ] Playtest L2 balance

## Implementation Todos (Phase 3 — L3 units)
11. [ ] Design L3 unit details (stats, abilities, costs)
12. [ ] Create L3 unit type .cfg files (14 units)
13. [ ] Implement L3 abilities
14. [ ] Final balance pass across all levels
