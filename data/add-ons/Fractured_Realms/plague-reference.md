# Plague Mechanics Reference

How the built-in `plague` weapon special works in Wesnoth 1.18, and how it compares to our WML grove reanimation.

## The Plague Flow (C++ Engine)

Plague is **not** a WML event — it's hardcoded in the C++ combat system (`src/actions/attack.cpp`).

```
Attack hits → Defender HP ≤ 0
  ↓
1. Save defender's undead_variation (before any events fire)
  ↓
2. Fire "attack_end" event
  ↓
3. Fire "last_breath" event
   → If WML heals defender above 0 HP → ABORT (unit lives)
  ↓
4. Play death animation
  ↓
5. Fire "die" event                    ← OUR GROVE REANIMATION FIRES HERE
   → If WML heals defender above 0 HP → ABORT (unit lives)
  ↓
6. ERASE defender from map             ← unit is removed from the hex
  ↓
7. PLAGUE SPAWNING                     ← built-in plague creates unit here
   Check: attacker.valid() && plagues && !drain_killed
   → Create new unit at death hex
  ↓
8. Fire "unit_placed" event            ← WML can react to the new unit
```

**Key takeaway:** Built-in plague spawns the unit AFTER the dead unit is erased (step 7), so the hex is guaranteed empty. Our WML `die` event fires at step 5, when the dying unit is still on the map but about to be removed.

## Plague Eligibility (4 conditions, ALL must be true)

| # | Condition | Code | Meaning |
|---|-----------|------|---------|
| 1 | `!opp.get_state("unplagueable")` | status check | Victim doesn't have `unplagueable` status |
| 2 | `!plague_specials.empty()` | weapon check | The killing weapon has `[plague]` special |
| 3 | `opp.undead_variation() != "null"` | unit type check | Victim is "reanimatable" (not already undead-null) |
| 4 | `!map().is_village(opp_loc)` | terrain check | Victim is NOT on a village hex |

These are checked **before combat begins** (during battle_context_unit_stats construction), not at spawn time.

## Plague Type Resolution

1. Read `type=` attribute from the `[plague]` WML config
2. If empty → fall back to the **attacker's own unit type** (`u.type().parent_id()`)
3. If the type doesn't exist in `unit_types` → silently fail, no unit created

## Spawned Unit Properties

| Property | Value |
|----------|-------|
| Unit type | From `type=` in `[plague]` (or attacker type if absent) |
| Side | Same as the **attacker** (unit with plague weapon) |
| Gender | Always MALE (hardcoded) |
| Attacks left | 0 |
| Movement left | 0 |
| Facing | Opposite of attacker's facing |
| Location | Death hex (exact hex where victim stood) |
| Variation | Dead unit's `undead_variation` applied |
| HP | Full (healed after variation applied) |

## The `unplagueable` / `not_living` Relationship

Setting `not_living` status automatically sets three statuses:
- `undrainable`
- `unpoisonable`  
- `unplagueable`

This is how undead and mechanical units get plague immunity.

## Village Immunity

Units standing on villages **cannot** be plagued. This is a hardcoded check, not a WML status. There is no way to override it.

## WML Plague Special Definition

```wml
#define WEAPON_SPECIAL_PLAGUE
    [plague]
        id=plague
        name= _ "plague"
        description= _ "When a unit is killed by a Plague attack, that unit is
                        replaced with a Walking Corpse on the same side as the
                        unit with the Plague attack. This doesn't work on Undead
                        or units in villages."
        type=Walking Corpse
    [/plague]
#enddef

# Custom type variant:
#define WEAPON_SPECIAL_PLAGUE_TYPE TYPE
    [plague]
        id=plague({TYPE})
        name= _ "plague"
        description= ...
        type={TYPE}
    [/plague]
#enddef
```

## Edge Cases

| Scenario | Result |
|----------|--------|
| Attacker removed by WML during die event | Plague skipped (`attacker.valid()` fails) |
| Attacker dies from drain recoil | Plague skipped (`drain_killed=true`) |
| Invalid plague type (unit type doesn't exist) | Silently fails, no unit |
| WML heals defender in `last_breath` or `die` event | Death aborted, no plague |
| Defender on a village | Plague blocked (checked pre-combat) |
| Defender has `unplagueable` status | Plague blocked (checked pre-combat) |
| Defender has `undead_variation=null` | Plague blocked |

## Implications for Grove Reanimation

Our grove reanimation fires during the `die` event (step 5), which is **before** the dying unit is erased (step 6). The built-in plague fires **after** erasure (step 7).

### Why our zombie appears on the death hex correctly:
The `[unit]` WML action creates a new unit. During the `die` event, the dying unit is technically still on the map but is flagged for removal. WML `[unit]` apparently can still place a unit at `$x1,$y1` — it may displace or coexist briefly before the engine cleans up.

### Differences from built-in plague:
| Aspect | Built-in Plague | Our Grove Reanimation |
|--------|----------------|----------------------|
| Timing | After die event + unit erasure | During die event |
| Implementation | C++ hardcoded | WML event |
| Village immunity | Yes (hardcoded) | No (we could add it) |
| `undead_variation` applied | Yes | No |
| Movement/attacks zeroed | Yes | No (unit has full movement) |
| Condition | Weapon has `[plague]` | Kill on mushroom grove terrain |
| Type | From `[plague] type=` | Always Fungal_Zombie |

### Things we should consider matching:
1. **Zero movement/attacks** — plague units can't act the turn they spawn. We should add `moves=0` and `attacks_left=0` to prevent the zombie from acting immediately.
2. **Village immunity** — plague doesn't work on villages. Our grove reanimation doesn't check for this, but it's somewhat moot since villages have overlays and won't become groves.
3. **`undead_variation`** — we could apply this for visual variety but it's optional.
