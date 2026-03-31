# Plan: Werefolk Faction for Wesnoth

## Concept
A lycanthropy cult that has deliberately transformed its members into werefolk hybrids. They worship the moon and view the curse as a gift — a transcendence beyond the weakness of human flesh. Where the Mycelium controls territory, the Werefolk control the enemy army itself — forcibly converting foes into new followers through the sacrament of the bite.

**Faction form — Permanent hybrids:** Werefolk units chose this. They underwent ritual transformation and now exist permanently between human and beast — claws, fangs, fur, but still upright, still thinking. They don't transform at nightfall; the ritual stabilized their forms. They benefit from chaotic alignment at night but don't mechanically change type. At L2, each cultist chooses a path: the **beast path** (surrendering more of their humanity to the wolf, gaining feral power) or the **human path** (mastering the curse through discipline, gaining technique and leadership). Both remain permanent hybrid forms — just different doctrines within the cult.

**Core mechanic — Lycanthropy:** Werefolk units with "Lycanthropic Bite" inflict a festering curse on *enemy* units when they land a hit (offensive or defensive) — a forcible initiation. Festering units are unhealable and, if not cured before nightfall, the curse takes root permanently as lycanthropy. Permanently lycanthropic enemies transform into a Cursed wolf form at nightfall, fighting for the werefolk player's side, and revert at dawn — every night, forever. Unlike the cult's controlled transformation, the forced conversion is unstable — victims lose themselves entirely when the moon rises. Festering can be cured by villages, healers with 'cures', or the unit's own regeneration ability. Permanent lycanthropy cannot be cured.

## Current State
- Mycelium faction complete in Fractured_Realms add-on
- Werefolk faction in progress:
  - Race (`werefolk`) and movement type (`wolfpaw`) defined in `units/werefolk.cfg`
  - Full lycanthropy event system implemented and tested (`macros/werefolk-events.cfg`)
  - Helper macros: APPLY_FESTERING, REMOVE_FESTERING, APPLY_LYCANTHROPY, LYCANTHROPY_APPLY_TRANSFORM, LYCANTHROPY_REMOVE_TRANSFORM, IF_TIME_OF_DAY
  - Event macros: BITE, NIGHTFALL, DAWN, FESTERING_VILLAGE_CURE, FESTERING_HEALER_CURE, FESTERING_REGENERATE_CURE + EVENTS composer
  - Werefolk_Cursed unit type (`units/werefolk/Cursed.cfg`) — hidden transformation target
  - Warg L1 unit (`units/werefolk/Warg.cfg`) — core fighter, first implemented unit
  - Lua status icon (`lua/theme.lua`) — curse indicator in unit status bar
  - Resource wiring (`fr-resource-tags.cfg`) — preload event + LYCANTHROPY_EVENTS
  - Remaining: 7 more L1 units, faction .cfg, era integration

## Faction Identity
- **Name**: The Werefolk
- **Alignment**: Chaotic (creatures of the night, moon-worshippers, strongest in darkness)
- **Terrain affinity**: Forest, Hills, Cave (terrain_liked = Ww, Hh, Uu — hidden groves, highland shrines, underground lairs)
- **Playstyle**: Aggressive melee cult with forced conversion. Fast units close distance quickly and spread lycanthropy through combat — the sacrament of the bite. Strong at night (chaotic alignment), vulnerable to fire and arcane. Rewards aggressive play, punishes passive opponents who let cursed units die. The cult's members are stable hybrids — the nightfall transform only affects their unwilling converts.
- **Racial weaknesses**: Fire 130%, Arcane 110% (fire purifies, holy magic opposes the cult's dark rituals)
- **Racial immunities**: None (unlike Mycelium's poison immunity — werefolk are flesh and blood, however transformed)

## Faction Contrast: Mycelium vs Werefolk
| Dimension | Mycelium | Werefolk |
|-----------|----------|------|
| Core mechanic | Terrain conversion (groves) | Enemy conversion (lycanthropy) |
| Spread type | Passive (turn start) | Active (through combat) |
| Playstyle | Defensive, outlast | Aggressive, swarm |
| Speed | Slow (4-5 mov) | Fast (6-8 mov) |
| HP | Low (~25 avg L1) | Medium (~28 avg L1) |
| Ranged | Decent | Weak (melee-focused) |
| Status effects | Poison, slow, blight | Lycanthropy (forced conversion), fear |
| Weakness | Fire | Fire, Arcane |
| Spawn mechanic | Plague (instant on kill) | Lycanthropy (bite → festering → nightfall transformation of *enemies*) |
| Unit form | Single form (mushroom) | Permanent hybrid (ritual transformation); cursed enemies transform uncontrollably |
| L2 split | Role specialization | Beast path (surrender to the wolf) vs. human path (master the curse) |
| Faction theme | Alien ecosystem | Moon-worshipping lycanthropy cult |

## Lycanthropy Mechanic

### 1. Lycanthropic Bite (weapon special) — IMPLEMENTED
- `[dummy]` special with `id=lycanthropic_bite` — a marker, no inherent damage effect
- Two `attacker_hits`/`defender_hits` events detect when the bite lands (covers both offensive and defensive combat)
- Applies `festering` status + `unhealable` via `APPLY_FESTERING` helper (object with two status effects)
- Stores `festering_owner` (werefolk player's side) and `festering_target=lycanthropy` on the cursed unit
- Skips undead, mechanical, and units already festering or lycanthropic via `[not]` blocks
- Shows floating purple "lycanthropy" text on hit
- Visual status icon displayed via Lua (`theme.lua` hooks `wesnoth.interface.game_display.unit_status`)
- Implementation: `WEAPON_SPECIAL_LYCANTHROPIC_BITE`, `APPLY_FESTERING`, `LYCANTHROPY_BITE_EVENT` in `macros/werefolk-events.cfg`

### 2. Nightfall Transformation (turn refresh event) — IMPLEMENTED
- Fires on `turn refresh`, scoped to `side=$side_number` (only on the unit's own turn), checks if time of day is `first_watch`
- **Phase 1**: Converts all festering units with `festering_target=lycanthropy` to permanent lycanthropy via `APPLY_LYCANTHROPY` (removes festering + unhealable, applies `lycanthropy` status)
- **Phase 2**: Transforms all units with `status=lycanthropy` that are NOT already `lycanthropy_transformed=yes`
- For each: snapshots original HP/XP/max values, saves them as unit variables, then applies `[object]` with `apply_to=type name=Werefolk_Cursed`
- After type change, restores original HP/XP/max (so stats carry over instead of using Cursed type defaults)
- Switches unit to werefolk player's side (`lycanthropy_owner`)
- `[redraw]` forces immediate visual refresh (team color orb update)
- Implementation: `APPLY_LYCANTHROPY`, `LYCANTHROPY_APPLY_TRANSFORM` helpers + `LYCANTHROPY_NIGHTFALL_EVENT` in `macros/werefolk-events.cfg`

### 3. Dawn Reversion (turn refresh event) — IMPLEMENTED
- Fires on `turn refresh`, scoped to `side=$side_number` (werefolk player's turn, since transformed units are on their side), checks if time of day is `dawn`
- Stores all units with `lycanthropy_transformed=yes`
- For each: snapshots current HP/XP, then `[remove_object]` reverts the type change
- Restores original side, carries over current HP (damage taken during night persists), restores original max HP/XP from stored variables
- `[redraw]` forces immediate visual refresh
- If the cursed form dies during the night, the unit is simply dead (no special handler needed — the original unit IS the cursed form, just type-changed)
- Implementation: `LYCANTHROPY_REMOVE_TRANSFORM` helper + `LYCANTHROPY_DAWN_EVENT` in `macros/werefolk-events.cfg`

### 4. Curing Festering — IMPLEMENTED
- **Two-phase curse model**: Bite inflicts `festering` (curable). If uncured by nightfall, converts to permanent `lycanthropy` (incurable).
- **Festering phase**: Unit has `festering` + `unhealable` status. Cannot receive any healing (village, rest, healer HP, regeneration HP). Can be cured by:
  - **Village cure** (`FESTERING_VILLAGE_CURE_EVENT`): `turn refresh` checks for festering units on village terrain (`*^V*`), restricted to `side=$side_number`
  - **Healer cure** (`FESTERING_HEALER_CURE_EVENT`): `turn refresh` checks for festering units adjacent to a friendly unit with the `cures` ability
  - **Regenerate cure** (`FESTERING_REGENERATE_CURE_EVENT`): `turn refresh` checks for festering units with the `regenerates` ability — parallels how the base engine clears poison for regenerators
- All cure events fire before nightfall in the composer ordering, ensuring the player gets a fair chance to cure
- Curing uses `REMOVE_FESTERING` helper: removes the festering object, clears `festering` + `unhealable` statuses, cleans up tracking variables
- **Permanent lycanthropy**: Once the curse takes root at nightfall, `lycanthropy` status is set directly (no object needed). Cannot be cured by any means. Unit transforms every night forever.
- Implementation: `REMOVE_FESTERING` helper + `FESTERING_VILLAGE_CURE_EVENT`, `FESTERING_HEALER_CURE_EVENT`, `FESTERING_REGENERATE_CURE_EVENT` in `macros/werefolk-events.cfg`

### 5. Cursed Unit Type (Werefolk_Cursed) — IMPLEMENTED
- Defined in `units/werefolk/Cursed.cfg` — `do_not_list=yes` (hidden from help/recruit)
- `id=Werefolk_Cursed`, race=werefolk, movement_type=wolfpaw, 24 HP, 7 mov, level 1, chaotic
- Uses wolf sprite (`units/monsters/wolf.png`)
- Attack: Claws 5×3 blade with lycanthropic bite (cursed wolves can spread the curse further at night)
- `advances_to=null` — cannot level up while transformed
- The original unit's HP/XP is preserved through the transform via `[modify_unit]` overrides

### 6. Lua Status Icon — IMPLEMENTED
- `lua/theme.lua` hooks `wesnoth.interface.game_display.unit_status` to show a curse icon in the unit status bar
- Uses `images/misc/curse-status-icon.png` (copied from Wings of Liberty add-on)
- Shows different tooltips for each phase:
  - **Festering**: "This unit has a festering curse. If not cured before nightfall, it will take root permanently."
  - **Lycanthropy**: "This unit is permanently cursed with lycanthropy. It transforms into a werefolk at nightfall and reverts at dawn."
- Loaded via `wesnoth.require` in a `preload` event in `fr-resource-tags.cfg`
- Persists through fog reveal (unlike overlay/halo approaches that disappeared)

### 7. Strategic Depth
- **Festering window**: Every bite is a forced initiation — the enemy must cure before nightfall or the conversion becomes permanent. Creates urgency: rush to a village, stay near healers, or rely on regeneration.
- **Permanent commitment**: Once a unit transforms for the first time, the lycanthropy is locked in forever. No more curing. The enemy must live with a unit that switches sides every night.
- **Night chaos**: During night, the Werefolk player gets a swarm of bonus Cursed wolves fighting alongside their cult. The enemy's own units are turned against them — unwilling converts serving the moon.
- **Dawn recovery**: Permanently cursed units return at dawn, but weakened by any damage taken in wolf form. A rough night can leave the enemy's army crippled even after reversion.
- **Permanent death risk**: If the enemy (or anyone) kills the Cursed form at night, the original unit is gone forever. The enemy must be careful not to kill their own transformed allies.
- **Counterplay**: Cure festering before nightfall (villages, healers with cures, regeneration). Kill the cultists before they spread the bite. Undead/mechanical are immune to conversion. Fight primarily during the day to minimize transformation windows.
- **Snowball potential**: More bites → more converts at night → more biters → more bites. The cult grows. Balanced by the fact that Cursed wolves revert at dawn and festering is accessible to cure.
- **Unhealable pressure**: Festering units can't be healed at all — no village HP, no rest healing, no healer HP, no regeneration HP. The curse actively degrades the enemy's army even before transformation.

## Pack Tactics Mechanic
- L2+ alpha-tier cultists gain "Pack Leader" (leadership variant) — adjacent lower-level allies deal more damage
- This replaces the Mycelium's territorial buff with a positional buff — the cult must stay clustered
- Creates tension: spread out to convert more enemies vs. cluster for leadership bonuses

## Movement Type: wolfpaw
- Fast on flat terrain (1 MP), forest (1 MP), hills (2 MP)
- Decent in caves (2 MP), sand (2 MP)
- Slow in water (3 MP), swamp (3 MP), mountains (4 MP)
- Impassable: deep water, lava
- Defense: forest 40%, hills 40%, cave 40%, flat 40%, village 50%
- Generally mobile but not exceptionally defensive anywhere — wolves survive by speed, not by holding ground

## Race: Werefolk
- Custom race with themed name generator
- Permanent hybrids — humans who underwent ritual lycanthropic transformation. They chose this form and view it as ascension
- Stable form (unlike their cursed victims who transform uncontrollably)
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

### ~~0. Thrall (L0)~~ — REMOVED
- Replaced by `Werefolk_Cursed` unit type. Transformation now uses `apply_to=type` which changes the original unit's type directly (preserving HP/XP/traits) rather than replacing with a separate Thrall unit.
- The recruitable Thrall concept may be revisited later as a separate L0 recruit that advances to Feral.

### 1. Warg (Fighter) — 15g — IMPLEMENTED
- **Concept**: The cult's front-line enforcer — a hulking hybrid who embraced the beast willingly. More wolf than human, built to close distance and deliver the sacrament of the bite.
- **HP**: 34 | **Mov**: 7 | **XP**: 38 | **Align**: Chaotic
- **Melee**: Fangs 6×3 (blade) — **lycanthropic bite**
- **Role**: Core fighter. Fast, tough, spreads lycanthropy. The backbone of the faction — gets in, bites, holds the line. High movement lets it reach enemies that other factions' fighters can't.
- **Based on**: Wolf Rider (fast melee, mounted-speed movement). Warg trades the rider for tankier stats and lycanthropic bite.
- **Advances to**: Dire Warg (L2, tankier + first strike), Alpha Warg (L2, leadership + howl)

### 2. Howler (Debuffer/Support) — 15g
- **Concept**: A gaunt cultist whose transformation twisted their voice into a supernatural weapon. Their howl carries the cold of the moon itself, chilling and slowing all who hear it.
- **HP**: 28 | **Mov**: 6 | **XP**: 34 | **Align**: Chaotic
- **Melee**: Claws 4×2 (blade)
- **Ranged**: Howl 5×2 (cold) — **slow**
- **Role**: The faction's primary ranged option. Slows enemies from range so melee biters can close in. Fragile — stays behind the Wargs. Cold damage punishes fire-resistant units that counter the pack's melee.
- **Based on**: Elvish Shaman ranged (slow support, similar stat line). Howler trades healing for cold ranged damage + slow.
- **Advances to**: Dread Howler (L2, AoE slow), Wailing Wolf (L2, cold damage specialist)

### 3. Herbalist (Healer) — 14g
- **Concept**: The cult's apothecary — a human healer who tends to the pack's wounds with herbal remedies. She brews the tinctures used in transformation rituals and knows the curse intimately, though she has not taken it herself.
- **Race**: Human (not Werefolk — uses human names, traits, movement type)
- **HP**: 24 | **Mov**: 5 | **XP**: 32 | **Align**: Neutral
- **Melee**: Staff 4×2 (impact)
- **Ranged**: Herb Poultice 3×2 (impact) — **slow**
- **Ability**: Heals +4 (adjacent allies)
- **Role**: Faction healer. Like the Mycelium's Lion's Mane — essential support. Neutral alignment means she's consistent across day/night, unlike the rest of the chaotic cult. A human among the transformed — the one who chose to serve without taking the sacrament.
- **Based on**: Elvish Shaman (L1 healer, 15g, 26 HP, 5 mov), Village Healer. Herbalist trades 2 HP for -1g cost.
- **Advances to**: Pack Shaman (L2, heals +8 + cures), Wolfsbane Witch (L2, offensive poison/blight)

### 4. Shadow Wolf (Scout) — 14g
- **Concept**: The cult's spy — a sleek, dark-furred hybrid trained in stealth and infiltration. Slips unseen through enemy territory at night to identify targets for conversion.
- **HP**: 26 | **Mov**: 8 | **XP**: 30 | **Align**: Chaotic
- **Melee**: Fangs 5×3 (blade) — **backstab**
- **Ability**: Nightstalk (invisible at night unless adjacent to enemy)
- **Role**: Fast scout and assassin. 8 movement + nightstalk makes it the faction's eyes — scouting enemy positions, grabbing undefended villages, and picking off wounded stragglers with backstab. No lycanthropic bite at L1 — pure utility. Gains it at L2.
- **Based on**: Saurian Skirmisher (15g, 26 HP, 6 mov, chaotic, skirmisher). Shadow Wolf trades skirmisher for nightstalk + 2 extra movement at -1g.
- **Advances to**: Phantom Wolf (L2, teleport + nightstalk), Dire Stalker (L2, backstab + ambush specialist)

### 5. Feral (Skirmisher) — 13g
- **Concept**: A new initiate — recently transformed and still wild with the thrill of it. Zealous and reckless, eager to prove their devotion by spreading the bite to as many unbelievers as possible.
- **HP**: 22 | **Mov**: 7 | **XP**: 28 | **Align**: Chaotic
- **Melee**: Savage Claws 4×4 (blade) — **lycanthropic bite**
- **Ability**: Skirmisher (ignores ZoC)
- **Role**: Cheap expendable flanker. Slips through enemy lines via skirmisher to bite backline units. Similar to the Mycelium's Puffball — cheap, fast, expendable, spreads the faction mechanic. Dies easily but every bite creates conversion potential.
- **Based on**: Footpad (14g, 24 HP, 6 mov, chaotic, skirmisher). Feral trades 2 HP for lycanthropic bite + 1 movement at -1g.
- **Advances to**: (dead-end L1 — already an advancement from Thrall)

### 6. Moon Priest (Mage) — 16g
- **Concept**: The cult's clergy — a robed hybrid who channels the moon's cold light into destructive beams. They lead the transformation rituals and interpret the moon's will. More scholar than beast, retaining enough humanity for arcane study.
- **HP**: 24 | **Mov**: 5 | **XP**: 36 | **Align**: Chaotic
- **Melee**: Moonblade 4×2 (cold)
- **Ranged**: Moonbeam 7×2 (cold) — **magical**
- **Role**: Magical damage dealer. Expensive but necessary — hits ethereal and high-defense targets that physical melee can't touch. Cold/magical is the faction's answer to ghosts and heavy armor.
- **Based on**: Dark Adept (17g, 24 HP, 5 mov, chaotic; chill wave 5×2 cold ranged). Moon Priest matches the chassis, trades shadow wave for stronger moonbeam at -1g.
- **Advances to**: Lunar Oracle (L2, illumination control + AoE), Eclipse Seer (L2, obscure + feeding)

### 7. Blood Fang (Drain Fighter) — 16g
- **Concept**: An elder cultist who has given themselves fully to the predator's hunger. They feed on the lifeforce of their prey — a living sacrament, sustained by devotion to the hunt.
- **HP**: 32 | **Mov**: 6 | **XP**: 38 | **Align**: Chaotic
- **Melee**: Draining Bite 6×3 (blade) — **drain**
- **Ranged**: —
- **Role**: Melee-only drain fighter. Self-sustaining through combat — stays healthy as long as it keeps fighting. No ranged forces aggressive positioning. The faction's answer to sustained engagements where healer support is spread thin. Similar to the Mycelium's Morel (melee drain).
- **Based on**: Dune Rover (14g, 32 HP, 5 mov, liminal; axe 4×3 blade, bow 5×3 pierce). Blood Fang trades ranged and 1 movement for drain at +2g.
- **Advances to**: Bloodlord (L2, drain + lycanthropic bite), Packbound (L2, drain aura for allies)

### 8. Ravager (Berserker) — 19g
- **Concept**: A cultist who surrendered completely to the beast — consumed by bloodlust, barely recognizable as having once been human. The cult reveres them as holy berserkers, touched by the moon's madness. The faction's most dangerous weapon, and its most unpredictable.
- **HP**: 36 | **Mov**: 5 | **XP**: 44 | **Align**: Chaotic
- **Melee**: Rend 7×3 (blade) — **berserk**
- **Role**: High-risk melee powerhouse. Berserk fights until one combatant drops — devastating against low-HP targets, suicidal against tanks. The faction's burst damage option. Expensive but worth it when it connects.
- **Based on**: Dwarvish Ulfserker (15g, 32 HP, 5 mov, neutral, berserk; hammer 9×3 impact). Ravager matches chassis, trades neutral for chaotic and impact for blade at +4g (reflecting higher HP and faction tax).
- **Advances to**: Abomination (L2, berserk + regeneration), Primal Alpha (L2, berserk + leadership)

---

## L2 Advancements

Each L1 has two advancement paths representing different doctrines within the cult:
- **Beast path** (listed first) — the cultist surrenders more humanity to the wolf. More feral, stronger raw combat stats, more aggressive abilities. Viewed within the cult as deeper devotion.
- **Human path** (listed second) — the cultist masters the curse through discipline and intellect. Gains utility, technique, leadership, or magical refinement. Viewed within the cult as enlightened control.

Neither path transforms at night — both are stable hybrid forms achieved through ritual. The choice reflects the cultist's doctrine: abandon yourself to the beast, or harness it.

### From Warg

#### Dire Warg — ~32g *(beast path)*
- **HP**: 48 | **Mov**: 7 | **Align**: Chaotic
- **Melee**: Fangs 8×3 (blade) — **lycanthropic bite, first strike**
- **Role**: Enhanced fighter. Tankier, hits harder, strikes first. A massive wolf that can bite and kill in the same engagement. First strike makes it dangerous to engage in melee.
- **Advances to**: Fenrir (L3)

#### Alpha Warg — ~32g *(human path)*
- **HP**: 44 | **Mov**: 7 | **Align**: Chaotic
- **Melee**: Fangs 7×3 (blade) — **lycanthropic bite**
- **Ranged**: Rallying Howl 5×2 (cold)
- **Ability**: Leadership (adjacent lower-level allies deal bonus damage)
- **Role**: Alpha leader. Retains tactical intelligence — trades raw combat power for army-wide buff. Positions in the center of the group to maximize leadership radius. The faction's force multiplier.
- **Advances to**: Pack Lord (L3)

### From Howler

#### Dread Howler — ~30g *(human path)*
- **HP**: 38 | **Mov**: 6 | **Align**: Chaotic
- **Melee**: Claws 6×2 (blade)
- **Ranged**: Dread Howl 7×2 (cold) — **slow, AoE slow** (slows adjacent enemies on hit, similar to Oyster Vizier's Spore Cloud)
- **Role**: AoE crowd control. The howl reverberates, slowing multiple enemies. Makes the faction's melee rush devastating — a slowed enemy can't escape.
- **Advances to**: Howl of Doom (L3)

#### Wailing Wolf — ~30g *(beast path)*
- **HP**: 36 | **Mov**: 6 | **Align**: Chaotic
- **Melee**: Frost Claws 5×3 (cold)
- **Ranged**: Wail 9×3 (cold) — **magical**
- **Role**: Ranged damage specialist. Sacrifices the Dread Howler's crowd control for raw cold/magical damage output. The pack's answer to ethereal threats and heavy armor.
- **Advances to**: Banshee Wolf (L3)

### From Herbalist

#### Pack Shaman — ~28g *(human path)*
- **Race**: Human
- **HP**: 36 | **Mov**: 5 | **Align**: Neutral
- **Melee**: Staff 5×2 (impact)
- **Ranged**: Herb Poultice 5×2 (impact)
- **Abilities**: Heals +8, Cures (removes poison AND lycanthropy from allies)
- **Role**: Upgraded healer. Cures is critical — both for removing poison from your own units and as a flavor element (the Shaman understands the curse well enough to manage it). Essential support.
- **Advances to**: Elder Shaman (L3)

#### Wolfsbane Witch — ~28g *(beast path)*
- **Race**: Human
- **HP**: 34 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Toxic Touch 5×2 (blade) — **poison**
- **Ranged**: Hex Bolt 7×3 (arcane)
- **Role**: Offensive caster path. The herbalist who delved too deep into the faction's dark magic — embraced the darkness. Poison melee + arcane ranged provides damage types the pack otherwise lacks. Chaotic alignment (unlike the neutral Pack Shaman) — she's fully embraced the darkness.
- **Advances to**: Crone (L3)

### From Shadow Wolf

#### Phantom Wolf — ~30g *(beast path)*
- **HP**: 34 | **Mov**: 8 | **Align**: Chaotic
- **Melee**: Fangs 7×3 (blade) — **backstab, lycanthropic bite**
- **Abilities**: Nightstalk, Teleport (between forest tiles at night — WML event on move, similar to Portalbello's Fungal Tunnel but restricted to nighttime)
- **Role**: Nighttime assassin. Teleports between forests at night to strike deep behind enemy lines, biting high-value targets. Terrifying during night phases, manageable during day.
- **Advances to**: Specter Wolf (L3)

#### Dire Stalker — ~30g *(human path)*
- **HP**: 38 | **Mov**: 7 | **Align**: Chaotic
- **Melee**: Fangs 8×3 (blade) — **backstab**
- **Ability**: Nightstalk, Ambush (hides in forest)
- **Role**: Ambush predator. Sits hidden in forest, waits for enemies to walk past, then strikes with backstab. More defensive/patient than the Phantom Wolf's aggressive teleporting.
- **Advances to**: Apex Predator (L3)

### From Moon Priest

#### Lunar Oracle — ~34g *(human path)*
- **HP**: 34 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Moonblade 6×2 (cold)
- **Ranged**: Lunar Cascade 9×3 (cold) — **magical**
- **Ability**: Illuminates -1 (dims surrounding hexes — makes it darker, benefiting chaotic allies)
- **Role**: Darkness manipulator. Shifts the local time of day one step darker, boosting the entire chaotic pack while hindering lawful enemies. A walking eclipse.
- **Advances to**: Blood Moon (L3)

#### Eclipse Seer — ~34g *(beast path)*
- **HP**: 32 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Void Claw 6×2 (arcane)
- **Ranged**: Eclipse Bolt 8×3 (arcane) — **magical**
- **Abilities**: Obscure (adjacent units fight as if one step darker), Feeding (+1 max HP per kill)
- **Role**: Arcane void path. Trades cold for arcane damage and gains sustain through feeding. Obscure aura protects adjacent allies by darkening their hexes.
- **Advances to**: Void Moon (L3)

### From Blood Fang

#### Bloodlord — ~34g *(beast path)*
- **HP**: 46 | **Mov**: 6 | **Align**: Chaotic
- **Melee**: Draining Bite 8×3 (blade) — **drain, lycanthropic bite**
- **Role**: Ultimate individual fighter. Drain keeps it alive, lycanthropic bite ensures kills spread the curse. A self-sustaining conversion engine. No ranged — must be in melee to function.
- **Advances to**: Lycan King (L3)

#### Packbound — ~32g *(human path)*
- **HP**: 42 | **Mov**: 6 | **Align**: Chaotic
- **Melee**: Parasitic Bite 6×3 (blade) — **drain**
- **Ranged**: Blood Howl 5×2 (cold)
- **Ability**: Parasitic Link (drain aura — adjacent allies' attacks drain health)
- **Role**: Drain support. Like the Mycelium's Morel Support — nearby allies self-sustain through combat. Gains a ranged attack for safer positioning. The faction's sustain engine.
- **Advances to**: Blood Alpha (L3)

### From Ravager

#### Abomination — ~36g *(beast path)*
- **HP**: 52 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Rend 9×3 (blade) — **berserk**
- **Ability**: Regeneration (+8 HP per turn)
- **Role**: Unstoppable horror. Berserk + regeneration means it can fight recklessly and heal between engagements. A relentless meat grinder that's nearly impossible to trade efficiently against.
- **Advances to**: Lycanthrope (L3)

#### Primal Alpha — ~36g *(human path)*
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
1. [x] Define `werefolk` race in WML (race definition, name generators, traits)
2. [x] Define `wolfpaw` movement type (movement costs, defense, resistances)
3. [x] Create lycanthropy events macro file (`macros/werefolk-events.cfg`):
   - [x] `WEAPON_SPECIAL_LYCANTHROPIC_BITE` — dummy special with id for event filtering
   - [x] `LYCANTHROPY_APPLY_CURSE` / `LYCANTHROPY_REMOVE_CURSE` — helper macros for curse status
   - [x] `LYCANTHROPY_APPLY_TRANSFORM` / `LYCANTHROPY_REMOVE_TRANSFORM` — helper macros for type change with HP/XP preservation
   - [x] `IF_TIME_OF_DAY` — helper macro (store_time_of_day + conditional)
   - [x] `LYCANTHROPY_BITE_EVENT` — attacker_hits + defender_hits events (both offensive and defensive bites)
   - [x] `LYCANTHROPY_NIGHTFALL_EVENT` — turn refresh at first_watch, transforms cursed units to Werefolk_Cursed
   - [x] `LYCANTHROPY_DAWN_EVENT` — turn refresh at dawn, reverts transformed units to original form
   - [x] `LYCANTHROPY_VILLAGE_CURE_EVENT` — turn refresh, cures cursed units on villages (own side's turn only)
   - [x] `LYCANTHROPY_EVENTS` — composer macro that wires all events
   - [x] Visual indicator: Lua status icon via `theme.lua` (persists through fog)
   - [x] `[redraw]` after transform/revert loops for immediate team color update
   - [x] `[status] lycanthropy=no` in REMOVE_CURSE (status add= not reversible by remove_object)
4. [x] Create Werefolk_Cursed unit type (`units/werefolk/Cursed.cfg`) — transformation target
5. [x] Create Warg L1 unit type (`units/werefolk/Warg.cfg`)
6. [ ] Create remaining L1 unit type .cfg files (7 units):
   - [ ] Howler (Debuffer)
   - [ ] Herbalist (Healer)
   - [ ] Shadow Wolf (Scout)
   - [ ] Feral (Skirmisher)
   - [ ] Moon Priest (Mage)
   - [ ] Blood Fang (Drain)
   - [ ] Ravager (Berserker)
7. [ ] Create faction .cfg file (leader list, recruit list, AI recruitment pattern)
8. [ ] Add faction to Fractured_Realms era definition
9. [ ] Playtest L1 balance — especially lycanthropy transformation timing and Cursed form strength

### Known Issues / Technical Notes
- `apply_to=status add=` is NOT reversible by `[remove_object]` — must explicitly set `[status] lycanthropy=no`
- `apply_to=type` changes max HP/XP to the new type's values — must `[modify_unit]` to restore originals
- `[modify_unit] image=` is read-only (image comes from unit type) — use `apply_to=type` to change appearance
- WML preprocessor splits macro args on whitespace: `$unit.x,$unit.y` = 1 arg, need `$unit.x $unit.y` = 2 args
- `special_id=` (flat) works in weapon event filters; `[specials][has_special]` does not
- Thrall concept removed — replaced by Werefolk_Cursed (a single hidden unit type for all transformed units)

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
