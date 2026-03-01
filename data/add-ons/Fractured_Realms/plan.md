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

### 3. Fungal Plague (Sporecap, Cordyceps, Fungal Zombie)
- Unconditional plague — when these units kill an enemy, it rises as a Fungal Zombie
- Uses the engine's built-in plague system (doesn't work on undead, mechanical, or villages)
- Zombies are L0, fragile, and expendable — designed to die

### 4. Death Bloom (Fungal Zombie only)
- When a Fungal Zombie dies, ALL adjacent hexes are converted to Mushroom Grove
- This is the faction's primary territory expansion tool
- Creates the core loop: plague spawns zombie → zombie dies → death bloom spreads groves → more favorable terrain
- Strategic choice: protect the zombie for its plague attack, or sacrifice it to infect new ground
- **Counterplay**: enemies can kill zombies in locations where grove spread is harmless, or avoid killing them entirely

### Mushroom Grove Terrain Stats
- High defense for Mycelium (60-70%), lower for others (~40%)
- Good movement for Mycelium (1 MP), slightly costly for others (2 MP)
- Visually could overlay existing forest terrain
- Terrain conversion is permanent — the battlefield gets progressively more favorable

### Strategic Tension
- Spread out to claim territory vs. cluster for AoE synergy at L2+
- Push forward aggressively with plague units to spawn zombies
- Zombies are worth more dead than alive — sacrifice decisions
- Enemies face a dilemma: kill the zombie and spread groves, or leave it alive and let it plague more units

## L1 Recruits (single-target status effects)

### 1. Sporecap (Fighter) — 15g
- **Mushroom**: Generic toadstool warrior
- **HP**: 38 | **Mov**: 4 | **Align**: Chaotic
- **Melee**: Club 6×2 (impact)
- **Ranged**: Spore Puff 3×2 (impact) — **slow**
- **Role**: Faction tank. Tough and slow, holds the line while grove spreads. Slows enemies to match its pace.
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
- **HP**: 22 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Bump 3×3 (impact)
- **Ranged**: Spore Burst 6×1 (impact) — **slow**
- **Ability**: Skirmisher (ignores ZoC)
- **Role**: Cheap harassment unit. Slips through lines, slows key targets.
- **Advances to**: Giant Puffball (L2) → Earthstar (L3)

### 6. Ink Cap (Mage) — 19g
- **Mushroom**: Inky Cap / Coprinus (dissolves into black ink)
- **HP**: 22 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Touch 3×1 (cold)
- **Ranged**: Ink Bolt 7×2 (cold) — **magical**
- **Role**: Ranged damage dealer. Expensive but hits hard with cold/arcane.
- **Advances to**: Shaggy Mane (L2) → Black Morel (L3)

### 7. Cordyceps (Parasite) — 15g
- **Mushroom**: Cordyceps (parasitic, mind-controlling fungus)
- **HP**: 25 | **Mov**: 5 | **Align**: Chaotic
- **Melee**: Parasitic Touch 5×2 (blade) — **drain**
- **Ranged**: Mind Spore 3×2 (arcane) — **slow**
- **Role**: Parasitic survivor. Drains life in melee to stay alive despite fragile stats, slows at range to set up engagements. Benefits from grove reanimation like all Mycelium units.
- **Advances to**: Puppeteer (L2) → Hivemind (L3)

## L2 Advancements (AoE unlocks)

| L1 Unit | L2 Name | AoE Ability Gained |
|---------|---------|-------------------|
| Sporecap | **Sporeguard** | Spore Cloud: AoE slow to adjacent enemies (aura) |
| Deathcap | **Destroying Angel** | Death Cloud: AoE poison to adjacent enemies (aura) |
| Lion's Mane | **Morel** | Heals +8, Cures poison (adjacent allies) |
| Mycelium Runner | **Mycelium Weaver** | Entangle: Adjacent enemies lose movement (aura) |
| Puffball | **Giant Puffball** | Spore Explosion: AoE impact damage to adjacent enemies |
| Ink Cap | **Shaggy Mane** | Frost Nova-style: AoE cold damage to adjacent enemies on attack |
| Cordyceps | **Puppeteer** | AoE drain aura (adjacent enemies lose HP, heals Puppeteer) + Fungal Domination (adjacent enemies -10% damage) |

## L3 Advancements (enhanced AoE + combos)

| L2 Unit | L3 Name | Enhanced Ability |
|---------|---------|-----------------|
| Sporeguard | **Sporewarden** | AoE slow + reduces enemy damage |
| Destroying Angel | **Angel of Death** | AoE poison + kills on grove spawn 2 Fungal Zombies instead of 1 |
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
3c. Create Grove Reanimation event ([die] event: enemy killed on Mushroom Grove hex by Mycelium unit → spawns Fungal Zombie)
4. Create L1 unit type .cfg files (7 units)
5. Define L1 weapon specials/abilities in macros (slow, poison, drain, heals, ambush, skirmisher, magical)
5b. Create Fungal Zombie unit type (spawned by grove reanimation)
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