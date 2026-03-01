# Terrain Reference: Fungal Spread Rules

## Terrains where mushrooms CAN grow (Fungal Spread allowed)

| Terrain | Codes | Notes |
|---------|-------|-------|
| Grassland | `Gg,Gs,Gd,Gll` | Mushrooms thrive in grass, especially leaf litter |
| Dirt/Roads | `Rb,Re,Rd,Rr,Rrc,Rrd,Rp,Rra` | Fungi grow in soil and through cracks |
| Swamp | `Ss,Sm` | Prime fungal habitat — moisture + decay |
| Hills (non-desert) | `Hh,Hhd,Ha` | Mushrooms grow on hillsides in soil |
| Cave Floor | `Uu,Uue,Ur,Urb` | Caves are iconic mushroom territory |
| Interior Floors | `Is*,Iw*` | Mushrooms grow on old stone and wood floors |
| Rocky Cave | `Uh,Uhe` | Fungi on damp rock |

## Terrains where mushrooms CANNOT grow (Fungal Spread blocked)

These are excluded by the `FUNGAL_SPREAD_EXCLUDED_TERRAINS` macro:

| Terrain | Codes | Reasoning |
|---------|-------|-----------|
| Water (shallow) | `Ww*` | Aquatic — fungi don't grow underwater |
| Water (deep/ocean) | `Wo*` | Deep water |
| Desert/Sand | `Dd*,Ds*` | Too dry, almost no fungi in sand |
| Desert Dunes | `Hd` | Sand dunes, same as desert |
| Frozen (Snow/Ice) | `Aa,Ai` | Too cold, fungi go dormant |
| Mountains | `Mm*,Md*,Ms*,Mv` | Bare rock, too exposed |
| Castle | `C*` | Stone structures, skip for gameplay |
| Keep | `K*` | Strategic terrain, shouldn't be converted |
| Lava/Chasm | `Ql*,Qx*` | Impassable, nothing grows here |
| Impassable Walls | `Xu*,Xo*,Xv` | Solid rock/walls/void |

## Terrains blocked by overlay rule (already have overlays)

These are skipped automatically because the `FUNGAL_SPREAD` macro uses `[store_locations]` + `[variable] contains=^` to detect overlays. If the stored terrain string contains `^`, the hex already has an overlay and is skipped. This cannot be done with terrain wildcard matching because `*` is special-cased to match everything.

| Terrain | Codes | Notes |
|---------|-------|-------|
| Forests | `^Fp,^Fds,^Ft,...` | Converted to Mushroom Forest (`^Tff`) instead of skipped |
| Villages | `^Vh,^Ve,^Vo,...` | All village overlays |
| Bridges | `^Bw,^Bs,^Bh,...` | All bridge overlays |
| Doors/Gates | `^Pr,^Pw,...` | All door overlays |
| Embellishments | `^Em,^Es,^Efm,...` | Small mushrooms, flowers, stones |
| Fungus Grove | `^Tf,^Tfi` | Already mushroom terrain |
| Elevation | `^Qhh,^Qhu,...` | Bluffs, gulches |
| Mine Rails | `^Br` | Rails overlay |

## Existing fungus-related terrain codes

| Code | ID | Name | Notes |
|------|------|------|-------|
| `Tt` | fungus | Fungus | Virtual/hidden, used for movement/defense aliasing |
| `Tb` | fungus_floor | Mycelium | Base terrain (cave floor with mycelium) |
| `^Tf` | fungus_grove | Mushroom Grove | Overlay — THIS IS WHAT WE USE for Fungal Spread |
| `^Tfi` | fungus_beam | Mushroom Grove (Lit) | Lit variant of mushroom grove |
| `^Tff` | mushroom_forest | Mushroom Forest | **CUSTOM** — forest absorbed by fungal spread, aliasof=_bas,Tt,Ft |
| `^Uf` | fungus_grove_old | Mushroom Grove (deprecated) | Old non-mixed version, don't use |

## Implementation summary

The `FUNGAL_SPREAD` macro in `macros/mycelium-events.cfg` uses a two-step check:

1. **Overlay check** — `[store_locations]` stores the hex, then `[variable] contains=^` detects if the terrain string has an overlay (e.g. `Gg^Fp` contains `^`, bare `Gg` does not).
2. **If overlay exists** — check if it's a forest (`terrain=*^F*`). If yes, replace with `^Tfp` (Mushroom Forest). Otherwise skip (villages, bridges, etc.).
3. **If no overlay** — `[have_location]` with `[not] terrain={FUNGAL_SPREAD_EXCLUDED_TERRAINS}` blocks: water (`Ww*,Wo*`), desert (`Dd*,Ds*,Hd`), frozen (`Aa,Ai`), mountains (`Mm*,Md*,Ms*,Mv`), castle/keep (`C*,K*`), lava/chasm (`Ql*,Qx*`), impassable (`Xu*,Xo*,Xv`). If allowed, applies `^Tf` (Mushroom Grove) overlay.
4. Forests are **absorbed** into Mushroom Forest (`^Tfp`) which blends base + fungus + forest stats.

### Why not terrain wildcards for overlay detection?

WML terrain matching treats standalone `*` as a special token that matches everything (including overlays). There is no wildcard pattern that means "any base with no overlay." The `?` character is NOT a wildcard — only `*` is. So `*^` parses identically to `*`, and `*^?*` tries to match literal `?`. The `[store_locations]` + `contains=^` approach bypasses the wildcard system entirely.
