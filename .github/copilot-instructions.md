# Copilot Instructions for Battle for Wesnoth

## Build Commands

### CMake (preferred on Windows)

```bash
# Configure (Windows with Visual Studio + vcpkg)
cmake --preset x64-Debug    # Debug build
cmake --preset x64-Release  # RelWithDebInfo build

# Configure (Linux/macOS)
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug

# Build
cmake --build out/build/x64-Debug     # Windows preset
cmake --build build                    # Linux/macOS

# Key CMake options
-DENABLE_GAME=ON          # Build game client (default ON)
-DENABLE_SERVER=ON        # Build MP server (default ON)
-DENABLE_TESTS=ON         # Build Boost unit tests
-DENABLE_NLS=ON           # Build translations
```

### SCons (Linux/macOS alternative)

```bash
scons wesnoth           # Build game client only
scons wesnothd          # Build MP server only
scons build=debug       # Debug build
```

### Tests

```bash
# C++ unit tests (Boost.Test)
./boost_unit_tests --run_test=test_config           # Run a single test suite
./boost_unit_tests --run_test=test_config/test_name  # Run a single test case
./boost_unit_tests --log_level=all                   # Verbose output

# WML/Lua scenario tests
python run_wml_tests -v                   # Run all WML tests (verbose)
python run_wml_tests -f test_name         # Run a single WML test by name (regex supported)
python run_wml_tests -t 0                 # Disable timeouts
python run_wml_tests -bd                  # Disable batching (useful for debugging)

# Lua linting
luacheck data/                            # Lint all Lua files in data/
```

### Formatting

```bash
# C++ formatting (clang-format config is in src/.clang-format)
clang-format -i src/path/to/file.cpp

# WML formatting (checked by CI)
# WML files must be formatted with wmlindent (except data/gui/ and data/schema/)
```

## Architecture

Wesnoth is a turn-based strategy game with three main executables built from a shared C++17 codebase:

- **wesnoth** — The game client: rendering (SDL2), GUI, gameplay, AI, map editor, Lua scripting
- **wesnothd** — Multiplayer game server: matchmaking, game hosting, player management
- **campaignd** — Add-on distribution server: hosts and serves user-created content

### Engine Layers

The engine is organized into static libraries defined by source lists in `source_lists/`:

- **libwesnoth_core** — Low-level utilities shared by all executables: config parsing, serialization, filesystem, logging, networking
- **libwesnoth** — Game logic: units, teams, map, game events, AI, pathfinding, savegames
- **libwesnoth_sdl** — SDL2 rendering layer: display, drawing, video, image loading
- **libwesnoth_widgets** — GUI widgets (registered via `REGISTER_WIDGET3` macro; linked with `--whole-archive` to prevent dead-stripping)

### Three Languages, One Game

Game content is defined using three interconnected languages:

1. **C++** (`src/`) — The engine: rendering, networking, core game rules
2. **WML** (Wesnoth Markup Language, `data/`) — Declarative content: units, campaigns, terrain, GUI layouts, scenarios. Parsed by `src/serialization/` (tokenizer → preprocessor → parser → config objects). Validated against schemas in `data/schema/`
3. **Lua** (`data/` inline + `src/scripting/`) — Scripting for complex game logic. Three kernel types: `game_lua_kernel` (gameplay), `application_lua_kernel` (app-level), `mapgen_lua_kernel` (map generation). Lua bindings for C++ APIs are in `src/scripting/lua_*.cpp`

### Event System

Game events flow through `src/game_events/`: the `manager` loads event handlers from WML, and the `wml_event_pump` fires them. Handlers can be WML actions (`action_wml.cpp`) or Lua functions.

### GUI Framework

The custom GUI framework lives in `src/gui/` with a widget hierarchy: `core/` (event dispatching, canvas, layout) → `widgets/` (70+ widget types) → `dialogs/` (game screens). Widgets self-register via static initialization macros.

## Code Conventions

### C++ Style

- **C++17 standard**, prefer standard library over third-party libraries
- Use `#pragma once` instead of include guards
- Local includes use `"quotes"` (sorted alphabetically), system/external includes use `<angle brackets>` (sorted separately)
- Class/struct names: `lower_case_with_underscores`
- Private members end with trailing underscore: `member_`
- Use `T& ref` and `T* ptr` style (not `T &ref`)
- Use `nullptr`, C++ casts (`static_cast`, `dynamic_cast`), `constexpr`/`static const` over macros
- No space after `if`/`for`/`while`: `if(condition) {`
- Opening braces on same line for control flow, new line for class/struct/function definitions
- Leading commas in constructor initializer lists
- Indentation: tabs (4-width) for C++ and Lua, 4 spaces for WML/CFG files

### WML Style

- All WML files must be formatted with `wmlindent` (checked by CI). Exceptions: `data/gui/` and `data/schema/`
- Files are UTF-8 encoded (required for Gettext translations)
- Translatable strings use `_"string"` syntax; see the [Gettext guide](https://wiki.wesnoth.org/GettextForWesnothDevelopers)
- No deprecated WML or Lua API features in new code

### Pull Request Requirements

- AI-generated or AI-assisted code must be disclosed in the commit message
- You must be able to explain what the code does and why — "vibe coded" PRs will be closed
- Include unit tests when possible: C++ tests in `src/tests/`, WML tests in `data/test/test/`
- Test schedule files: `boost_test_schedule` (C++ tests), `wml_test_schedule` (WML tests)
