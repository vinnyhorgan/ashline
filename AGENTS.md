# AGENTS.md — ASHLINE Deep Context

## What Is This Game

ASHLINE is a terminal-first post-apocalyptic narrative game built in **LÖVE2D** (Lua). The player is a night-shift archive operator trapped behind an institutional terminal inside a sealed underground silo. The terminal is the only interface — there are no sprites, maps, or traditional game graphics. Every interaction is text commands, record fragments, and procedural UI.

The game's aesthetic is a real terminal: phosphor green on near-black, monospace text, CRT post-processing, mechanical hum. Think institutional infrastructure software for a bunker that has been running too long.

**Inspirations**: Papers Please (bureaucracy as moral pressure), Her Story (search-driven discovery), Orwell (information selection as power), Hacknet (terminal immersion), Return of the Obra Dinn (deductive reasoning), the Silo TV series, Fallout's institutional decay.

---

## The Story

You are **Operator 31** (CIV-0031), night-shift archive clerk on Terminal ARC-7 in **Silo Meridian**, year 2071. Clearance level 2.

A water anomaly appears: 612L/day draw from Annex A-17, supposedly decommissioned since 2060. Director Orla Vey tells you to log it as mineral drift. Then an anonymous message arrives — there are **64 people** hidden in A-17. Political prisoners from the 2060 Lantern Assembly protest, plus children born in captivity. They've been chemically sedated with "calm-ash" cognitive suppressant. The Directorate has a 6-minute liquidation contingency ready (chlorine pulse). And the surface — officially uniformly fatal — actually has breathable windows.

By shift's end, you must choose one of **five endings**: bury them (chlorine pulse), keep them hidden (tragic compromise), controlled disclosure, open broadcast (maximum chaos, maximum freedom), or extend the sedation doctrine across the whole silo.

**Every ending has a body count.**

### Progression

The game progresses through **5 chapters**, gated by investigation depth:

1. **ANOMALY TRIAGE** — Water draw on A-17, initial records
2. **HIDDEN OCCUPANCY** — Evidence of children, population mismatch
3. **SUPPRESSION LEDGER** — Annex vault unlocked, doctrine files
4. **BURIED SKY** — Surface truth, external survey data
5. **TERMINAL DECISION** — All evidence gathered, final authorization set

Progression is driven by reading records, searching keywords, comparing files, and receiving timed messages from NPCs (Naima Sol, Dr. Ilya Sera, Jonas Bell, Leon Var). The player must meet flag/proof/action requirements to unlock deeper content and the final decision set.

### Record Types

| Prefix | Type | Purpose |
|--------|------|---------|
| `INC-` | Incidents | System alerts, anomalies, contradictions |
| `MLOG-` | Maintenance Logs | Technical details, personnel traces, physical evidence |
| `DIR-` | Directives | Policy, doctrine, hidden orders |
| `WIT-` | Witness/Memos | Human voices, objections, testimony |
| `MSG-` | Messages | Inbox messages from NPCs, timed delivery |
| `ACT-` | Actions | Player authorizations (manifold override, ration model, broadcast, endings) |

### Key Metrics

- **proof_score** — Evidence gathered (reading records, searching, comparing). Gates ending availability.
- **audit_risk** — How much attention you've drawn. Rises with deep vault access.
- **strain** — Silo-wide pressure from your actions.
- **mercy** — Accumulated from compassionate actions (ACT-101, 102, 105). Gates "Keeper" ending.
- **complicity** — Accumulated from compliant/suppressive actions. Gates "Theory of Quiet" ending.

---

## Technical Architecture

### Framework & Runtime

- **LÖVE2D 11.5** — Game framework (Lua)
- **Moonshine** — Post-processing shader library (scanlines, CRT, glow, vignette, filmgrain)
- **Virtual resolution**: 1440×800, scaled with letterboxing via `getViewport()` → `(scale, offset_x, offset_y)`
- **Font**: IBM Plex Mono — Regular (body) and Bold (headers, title) at sizes 18, 24, 42
- **Identity**: `ashline` (LÖVE save directory)

### Repository Structure

```
ashline/
├── assets/
│   ├── fonts/              IBM Plex Mono Regular + Bold (.ttf)
│   └── sounds/             69 .wav files (clicks, errors, chimes, hum loops, tension)
├── lib/
│   ├── moonshine/          Shader effects library (DO NOT MODIFY)
│   └── json.lua            JSON encoder/decoder (DO NOT MODIFY)
├── docs/
│   ├── IDEA.md             Game design document
│   ├── PROMPT.md           Project description
│   ├── json.md             JSON library docs
│   └── moonshine.md        Moonshine library docs
├── lv_100/                 Reference terminal project (NOT USED IN GAME)
│
├── conf.lua                LÖVE configuration (window, modules, identity)
├── main.lua                Application entry point, state machine, event wiring
├── menu_ui.lua             All menu/settings/pause UI rendering and interaction
├── terminal.lua            Main game terminal renderer (frame, content, input)
├── game.lua                Core game logic, state, triggers, progression
├── commands.lua            Command parser, handlers, tab completion, ghost text
├── data.lua                All narrative content (records, messages, personnel, actions, endings)
├── sound.lua               Audio system (clicks, errors, chimes, ambient, tension)
├── settings.lua            Settings persistence (JSON, with legacy migration)
├── save.lua                Save/load with checksums, atomic writes, backup recovery
├── boot.lua                Boot sequence animation data
├── colors.lua              Color palette (19 named RGBA colors)
├── display.lua             Virtual resolution constants
├── utf8_utils.lua          Shared UTF-8 string utilities
├── headless_smoke.lua      Test suite (runs without LÖVE)
└── AGENTS.md               This file
```

### Third-Party Libraries

Located in `lib/`. Loaded via `love.filesystem.setRequirePath("lib/?.lua;lib/?/init.lua;...")` at the top of `main.lua`.

- **`lib/moonshine/`** — CRT shader effects. Internal requires use `BASE = ...` pattern. **Do not modify.**
- **`lib/json.lua`** — rxi/json v0.1.2, pure Lua JSON codec. **Do not modify.**

### Module Dependency Graph

```
main.lua ─── orchestrates everything
├── moonshine        (lib — post-processing)
├── colors           (palette constants)
├── Display          (virtual resolution)
├── Sound            (audio system)
│   └── loads from assets/sounds/
├── Terminal          (game terminal renderer)
│   ├── colors
│   └── utf8_utils
├── Game              (game state & logic)
│   └── data          (narrative content)
│       └── colors
├── MenuUI            (all menu screens)
├── boot              (boot sequence data)
│   └── colors
├── commands          (command handlers)
│   ├── colors
│   └── data
├── Settings          (settings persistence)
│   └── json          (lib)
├── Save              (save system)
│   └── json          (lib)
└── utf8_utils        (UTF-8 helpers)

conf.lua
└── Display

headless_smoke.lua
├── Game
├── commands
└── Save
```

---

## File-by-File Reference

### `main.lua` (~930 lines) — Application Entry Point

The central orchestrator. Manages the application state machine, wires all modules together, handles LÖVE callbacks.

**State Machine** (`app_state`):
- `"title"` → Title screen (NEW SESSION, CONTINUE, SETTINGS, QUIT)
- `"settings"` → Settings screen (reachable from title or pause; `settings_return_state` tracks origin)
- `"boot"` → Boot sequence animation (typewriter text, skippable)
- `"game"` → Main gameplay (terminal input, command execution)
- `"pause"` → Pause overlay (RESUME, SETTINGS, RESTART, QUIT TO TITLE)

**Key Functions**:
- `love.load()` — Initializes fonts, terminal, sound, menu_ui with callback closures
- `love.update(dt)` — Drives boot sequence, game timers, message delivery, typewriter, notifications
- `love.draw()` — Renders via virtual resolution scaling; terminal always draws first in game context, menu overlays on top; optional moonshine post-processing
- `love.keypressed()` — Input dispatch: menu_ui gets first pass, then state-specific handling
- `executeCommand()` — Parses input, delegates to `commands.execute()`, renders output to terminal
- `applySettings(persist)` — Applies fullscreen, volume, post-effects; optionally saves
- `autosaveGame()` / `continueSession()` — Save/restore via `Save` module
- `getViewport()` — Computes scale + offset for virtual resolution letterboxing
- `renderVirtual(fn)` — Wraps drawing in push/translate/scale/pop for virtual coords
- `buildEffectChain(w, h)` — Creates moonshine scanlines→CRT→glow→vignette→filmgrain chain
- `updateHeader()` / `updateStatus()` — Refreshes terminal header bar (time, alerts, inbox) and status bar (phase, proof, risk, strain)

**Draw Pipeline** (in `love.draw`):
1. Clear background with `colors.bg`
2. `renderVirtual()` transforms to 1440×800 coordinate space
3. If in game context → `terminal:render()` draws the terminal frame and content
4. `menu_ui:draw()` draws any active overlay (title, settings, pause)
5. If `post_effects` enabled → entire draw wrapped in moonshine effect chain

**Input Text State** (module-level locals):
- `input_text` — Current command line input string
- `input_cursor` — Cursor position (UTF-8 character index)
- `command_history` — Array of previously executed commands
- `history_index` — Current position in history navigation

### `menu_ui.lua` (~1500 lines) — Menu System

All menu, settings, and pause UI rendering and interaction. Constructed with callback closures from `main.lua` — it never directly references game state, only through getters.

**Construction** (`MenuUI.new(opts)`): Takes a table of:
- `colors`, `font`, `font_bold`, `font_large`, `font_title` — Visual resources
- `get_viewport`, `get_virtual_size`, `get_settings`, `get_settings_return_state` — State getters
- `get_save_notice`, `get_save_metadata` — Save UI info
- `on_title_select`, `on_pause_select`, `on_adjust_setting`, `on_close_settings`, `on_click` — Action callbacks
- `Save` — Save module reference (for save existence check)

**Surfaces**: Menu navigation uses a "surface" concept for managing cursor state across screens:
- `"title"` — Title screen menu items
- `"settings"` — Settings screen items
- `"pause"` — Pause menu items

Each surface tracks: `selected_index`, `hovered_index`, `cursor_y` (animated), `target_y`.

**Transition System** (`requestTransition(callback, duration)`):
- CRT-style sweep animation (quadratic easing)
- Callback fires at the midpoint (state change happens behind the sweep)
- Default duration: 0.38s. RESUME uses 0.18s for snappiness
- Input blocked during transitions (`isTransitioning()`)

**Layout System**: Each screen has a `build*Layout()` function that computes all positions:
- `buildTitleLayout(w, h)` — Title screen with logo, decorative header, menu items, footer
- `buildSettingsLayout(w, h)` — Settings panel with options, volume bars, help footer
- `buildPauseLayout(w, h)` — Pause overlay panel

**Key Drawing Methods**:
- `drawBackground(w, h)` — Full-screen CRT background with chromatic aberration, ambient scan lines, breathing border, phosphor bleed
- `drawPanel(x, y, w, h, title, accent, badge)` — Bordered panel with header bar, title, status badge, decorative dashes, pulsing dot
- `drawTitleScreen(w, h)` — Title logo, decorative frame, menu items, save info, footer with blinking cursor
- `drawSettingsScreen(w, h)` — Settings panel with value display, volume bars, help text
- `drawPauseOverlay(w, h)` — Dimmed overlay (0.78 alpha, 0.35s ease-out fade) with pause panel, ambient scan lines

**Input Handling**:
- `keypressed(app_state, key, isrepeat)` — Returns `true` if consumed. Handles up/down navigation, left/right for settings adjustment, enter for selection, escape for back/close
- `mousemoved(app_state, x, y)` — Hover detection via hit-test on menu item rects
- `mousepressed(app_state, x, y, button)` — Click selection on menu items
- `wheelmoved(app_state, y)` — Settings scrolling

### `terminal.lua` (~475 lines) — Game Terminal Renderer

The main game interface — a bordered terminal with header bar, scrollable content area, status bar, and input line.

**Layout** (computed in `recalcLayout()`):
- `cols` — Character columns (max 110)
- `content_rows` — Visible content lines (max 24)
- `total_rows` — Total rows fitting in height
- Margins: 20px horizontal, 12px vertical
- Sections: header (2 lines), content, status (1 line), input (1 line), plus 3 separator lines

**Terminal Sizing**: `term_w = 110 * char_w + 40`, centered in virtual space. Height = `VIRTUAL_H - 48` (24px padding top and bottom).

**Content Model**:
- `displayed_raw` — Array of raw entries (each has `segments` or `is_blank`)
- `output` — Array of wrapped display lines (result of word-wrapping `displayed_raw`)
- `typewriter_queue` — Pending entries for typewriter animation
- `scroll_offset` — Lines scrolled up from bottom (0 = at bottom)

**Typewriter System**:
- Lines queue into `typewriter_queue`, displayed one-by-one at `typewriter_speed` chars/sec
- Sound plays every `typewriter_sound_interval` (4) lines for non-blank content
- `flushTypewriter()` — Instantly displays all queued content (skip animation)
- `isTyping()` — True when queue is non-empty

**Rendering** (`render()`):
- Double border frame with breathing opacity animation
- Cyan corner brackets and vertical rail accents
- Pulsing beacon dots (top-left)
- Header section with background fill, cyan left accent bar, gradient overlay
- Animated sweep lines on separators (moving highlight dot)
- Content area with word-wrapped segment rendering
- Scroll indicator (amber pulsing) when scrolled up
- Status bar with amber left accent
- Input line with ghost text (tab completion preview) and block cursor with glow
- Ambient scan line (slow sweep across full terminal height)

**Word Wrapping** (`wrap_segments()`): Smart wrapping that respects word boundaries. Breaks at spaces when possible (if break point is past 30% of line width), otherwise hard-breaks mid-word.

### `game.lua` (~558 lines) — Game State & Logic

Pure game logic — no rendering, no LÖVE dependencies (except through `data.lua`'s color references).

**State** (`Game.new()`):
- `phase` — `"boot"`, `"main"`, or `"ending"`
- `flags` — Map of boolean flags (progression gates, message delivery tracking)
- `inbox` — Array of `{id, message, read}` entries
- `records_read`, `personnel_viewed`, `searches_performed`, `comparisons_made`, `actions_taken` — Maps tracking player activity
- `game_time` — Elapsed time (used for in-game clock: starts at 22:00)
- `ending` — Which ending was triggered (nil until decided)
- `message_timers` — Pending message deliveries `{msg_id = seconds_remaining}`
- Metrics: `proof_score`, `audit_risk`, `strain`, `mercy`, `complicity`
- `chapter` (1-5), `decisions_unlocked` (boolean)

**Trigger System** (`checkTriggers()`):
- Called after every significant player action (reading a record, searching, comparing, overriding, executing an action)
- Checks combinations of flags, records read, and evidence thresholds
- Queues timed messages when conditions are met (e.g., read INC-7301 → queue MSG-002 in 3s)
- Updates `decisions_unlocked` and derived state (chapter, alert count)

**Action System**:
- `isActionAvailable(action_id)` — Checks requirements (flags, records, actions, min_proof, min_mercy, min_complicity)
- `executeAction(action_id)` — Marks taken, applies effects (flags, metrics, queued messages), triggers ending if applicable
- `getAvailableActions()` — Returns all currently available actions, sorted by ID

**Override System** (`unlockOverride(code)`):
- Player enters override codes (e.g., `OVERRIDE LANTERN-17`)
- Validates against `data.overrides`, checks prerequisite flags
- Sets flags and triggers cascading effects

**Serialization**: `serialize()` / `fromSnapshot()` — Deep-copies all state for save/load. Uses `copy_map()` and `copy_array()` helpers for clean cloning.

**Dynamic Objectives** (`getObjectives()`): Returns 3 context-sensitive hint strings based on current chapter/flags. Guides the player without being explicit.

### `commands.lua` (~1130 lines) — Command Handler System

Parses and executes player commands. Returns arrays of `{text, color}` segments for terminal display.

**Handler Pattern**: Each command is a function in the `handlers` table:
```lua
handlers.COMMAND_NAME = function(game, args) → result_lines | "CLEAR" | "LOGOUT"
```

**Available Commands**:
| Command | Purpose |
|---------|---------|
| `HELP` | Lists available commands |
| `TASKS` | Shows current objectives |
| `ACTIONS` | Lists available authorizations |
| `STATUS` | Shows game metrics and stats |
| `ALERTS` | Shows active system alerts |
| `READ <id>` | Reads a record, message, or personnel file |
| `SEARCH <keyword>` | Searches records by keyword |
| `LIST [category]` | Lists accessible records by type |
| `PERSONNEL <id>` | Views personnel profile |
| `COMPARE <id1> <id2>` | Cross-references two records |
| `INSPECT <id>` | Shows record metadata and cross-references |
| `TRACE <system>` | Traces resource flows through systems |
| `OVERRIDE <code>` | Enters override token to unlock vault access |
| `AUTHORIZE <action>` | Executes an action (ACT-xxx) |
| `DENY <action>` | Refuses an action |
| `INBOX` | Shows inbox messages |
| `CLEAR` | Clears terminal |
| `LOGOUT` | Ends session |

**Tab Completion & Ghost Text**:
- `getCompletions(input, game)` — Returns list of valid completions for current input
- `getGhostText(input, game)` — Returns dimmed preview text showing what tab would complete
- `applyCompletion(input, game)` — Applies first valid completion
- Completes command names, record IDs, personnel IDs, system names, action IDs, override codes

**Comparison Analysis** (`getComparisonAnalysis(id1, id2)`): Generates analysis output when comparing two records — finds shared keywords, timeline contradictions, cross-references. Returns formatted segment arrays.

### `data.lua` (~1988 lines) — Narrative Content Database

Pure data — every record, message, personnel profile, action, ending, and override token. **This is the game's script.** All content is defined as Lua tables.

**Structure**:
- `data.records` — Keyed by ID (e.g., `"INC-7301"`). Each has: `title`, `category`, `access_level`, `content` (array of `{text, color}` lines), `keywords`, `cross_refs`, `proof` value, optionally `requires_flag`
- `data.messages` — Keyed by ID (e.g., `"MSG-001"`). Each has: `from`, `subject`, `body` (array of lines)
- `data.personnel` — Keyed by ID (e.g., `"CIV-0031"`). Each has: `name`, `title`, `clearance`, `status`, `notes`
- `data.actions` — Keyed by ID (e.g., `"ACT-101"`). Each has: `label`, `description`, `requirements`, `effects`, `result`, optionally `ending`, `repeatable`
- `data.overrides` — Keyed by normalized code. Each has: `flag`, `description`, optionally `requires_flag`, `metrics`, `queue_messages`
- `data.endings` — Keyed by ending name. Each has: `title`, `lines` (array of `{text, color}`)
- `data.systems` — System definitions for TRACE command
- `data.search(keyword)` / `data.searchPersonnel(keyword)` — Search functions

**Content Scale**: ~30 records, 12+ messages, 10 personnel, 8 actions (including 5 endings), 4 override codes, 5 endings, 8 traceable systems.

### `sound.lua` (~137 lines) — Audio System

Manages all game audio with volume mixing.

**Sound Categories**:
| Category | Count | Type | Purpose |
|----------|-------|------|---------|
| `clicks` | 27 | static | Keyboard/terminal click feedback |
| `errors` | 15 | static | Error/alert sounds |
| `success` | 16 | static | Chime/notification sounds |
| `hums` | 6 | stream, looping | Ambient terminal hum |
| `tension` | 5 | stream | Tension/urgency pulses |

**Volume Model**: Each category has its own volume channel (`ui_volume`, `ambient_volume`, `tension_volume`), multiplied by `master_volume`. Success chimes get an additional 0.7x multiplier.

**Key Methods**: `click()`, `error()`, `chime()`, `startAmbient()`, `stopAmbient()`, `playTension()`, `setMix(master, ui, ambient, tension)`.

### `settings.lua` (~144 lines) — Settings Persistence

Loads/saves settings as JSON via `love.filesystem`. Includes legacy `.cfg` migration (auto-converts and deletes old format).

**Settings & Defaults**:
| Key | Type | Default | Range/Values |
|-----|------|---------|-------------|
| `fullscreen` | bool | `false` | — |
| `post_effects` | bool | `true` | — |
| `master_volume` | number | `0.7` | 0.0–1.0 |
| `ui_volume` | number | `0.3` | 0.0–1.0 |
| `ambient_volume` | number | `0.15` | 0.0–1.0 |
| `tension_volume` | number | `0.25` | 0.0–1.0 |
| `text_speed` | enum | `180` | 60, 120, 180, 300, 600 (cps) |

**Clamping**: `Settings.clamp()` enforces all ranges and snaps text_speed to nearest valid value. Called on every load and save.

**Write Verification**: After writing settings, immediately reads back and verifies JSON decode succeeds — paranoid but safe.

### `save.lua` (~290 lines) — Save/Load System

Robust save system with checksums, atomic writes, and backup recovery.

**Save Format**: Nested JSON wrapper:
```json
{
  "format": "ASHLINE_SAVE",
  "version": 1,
  "checksum": "<adler32 of payload JSON>",
  "payload": "<JSON string of game state>"
}
```

**Payload Contents**: `{saved_at, app: {input_text, input_cursor, command_history, history_index}, game: {serialized game state}}`

**Atomic Write Protocol** (`Save.save()`):
1. Read and validate current save (if exists) → keep as `previous_valid_blob`
2. Write new data to `.tmp.json` → verify it reads back correctly
3. Write previous valid data to `.backup.json` → verify
4. Write new data to main `.save.json` → verify
5. Clean up temp file
6. On any failure: restore previous data, delete temp, return error

**Load with Fallback** (`Save.load()`):
1. Try primary `.save.json` → return if valid
2. Try `.backup.json` → if valid, restore as primary, return
3. Try legacy `.bak` → same fallback
4. Return nil with error

**Filesystem Abstraction**: Works with both `love.filesystem` (LÖVE runtime) and native `io` (headless tests). Auto-detects which is available.

### `boot.lua` (~74 lines) — Boot Sequence

Returns an array of `{delay, segments}` entries that play as a typewriter boot animation when starting a new session. Pure data, no logic. Colors from the `colors` module.

Content: System initialization messages (BIOS check, kernel load, filesystem mount, network status, archive integrity, operator authentication, clearance confirmation).

### `colors.lua` (~22 lines) — Color Palette

19 named RGBA color constants. The visual DNA of the game.

**Primary**: `bg` (near-black green), `text` (phosphor green), `bright` (highlighted green), `dim`/`very_dim` (subdued)
**Accent**: `amber` (warnings), `red` (critical), `cyan` (info/decorative), `white` (rare emphasis)
**Functional**: `header`, `input_text`, `prompt`, `border`, `classified`, `highlight`, `ghost`, `soft_cyan`, `warm_dim`

### `display.lua` (~12 lines) — Virtual Resolution

Constants: `virtual_w = 1440`, `virtual_h = 800`. Window defaults mirror virtual size. Minimum window: 900×500 (maintains aspect ratio).

### `utf8_utils.lua` (~30 lines) — UTF-8 Utilities

Shared module providing `M.len(s)` and `M.sub(s, i, j)` — safe UTF-8 string length and substring with nil/bounds handling. Used by both `terminal.lua` and `main.lua`.

### `conf.lua` (~30 lines) — LÖVE Configuration

Sets window title, dimensions, resizable flag, vsync. Enables audio/graphics/keyboard/mouse/timer; disables joystick/physics.

### `headless_smoke.lua` (~211 lines) — Test Suite

Runs without LÖVE (standard Lua/LuaJIT). Tests:
- Game initialization and serialization round-trip
- Command execution (HELP, READ, SEARCH, STATUS, TASKS, LIST, COMPARE, INSPECT, TRACE, ACTIONS, ALERTS, INBOX, AUTHORIZE, OVERRIDE, DENY)
- Progression triggers (reading records queues messages)
- Save/load with integrity verification
- Edge cases (invalid commands, missing records, double-read)

Run with: `lua headless_smoke.lua` or `luajit headless_smoke.lua`

---

## Coding Conventions

### Style
- **Lua 5.1/LuaJIT compatible** (LÖVE2D standard)
- **Metatables for OOP**: `Class = {}; Class.__index = Class; function Class.new() ... setmetatable({}, Class) end`
- **Module pattern**: Each file returns a single table/class
- **Locals everywhere**: No globals except LÖVE callbacks in `main.lua`
- **Callback closures**: `menu_ui` receives all external dependencies as closures in its constructor, never reaching into other modules directly
- **Segments pattern**: Text is represented as arrays of `{text = "...", color = {r, g, b, a}}` segments throughout the codebase — in terminal output, menu rendering, data content, and command results
- **Comments only where needed**: Code is self-documenting through clear naming. Comments mark sections (`-- === HEADER SECTION ===`) and explain non-obvious behavior.

### Naming
- `snake_case` for variables, functions, fields
- `PascalCase` for module/class names (`Terminal`, `MenuUI`, `Game`, `Sound`, `Settings`, `Save`)
- `UPPER_CASE` for constants (`MARGIN_X`, `VIRTUAL_W`, `HEADER_LINES`)
- Handler functions: `handlers.COMMAND_NAME` (matches player-facing command names)

### Rendering
- All rendering uses LÖVE2D's immediate-mode graphics API (`love.graphics.*`)
- Virtual resolution (1440×800) with `push/translate/scale/pop` wrapping
- Colors are always `{r, g, b, a}` tables (0.0–1.0 range)
- Font set with `love.graphics.setFont()` before drawing text
- Color set with `love.graphics.setColor()` before each draw call
- Animation uses `love.timer.getTime()` with `math.sin()` for pulsing/breathing effects

### Data
- All game content lives in `data.lua` as plain Lua tables
- Records use `{text, color}` segment arrays for colored output
- Requirements are declarative: `{flags = {...}, records = {...}, min_proof = N}`
- Effects are declarative: `{flags = {...}, metrics = {proof_score = N}, queue_messages = {...}}`

---

## Design Principles

1. **Interface IS the game** — The terminal UI is not a wrapper around gameplay; it IS the play surface. Every pixel of the UI should feel diegetic — like real institutional software.

2. **Deduction over spectacle** — Progress comes from understanding patterns, contradictions, and relationships between records. The player's intelligence is the game mechanic.

3. **Systems produce story** — Narrative emerges from procedures, logs, restrictions, and consequences — not cutscenes or dialogue trees. The bureaucracy tells the story.

4. **Bureaucracy creates pressure** — Rules, quotas, access levels, and triage ladders create tension between policy and humanity. The system is the antagonist.

5. **Atmosphere through restraint** — Tone from pacing, silence, color temperature, typography, failure states, and coldness. Never flashy. Always measured.

6. **Art-skill free** — Built without any art assets. The entire experience is typography, color, spacing, and sound. Pure programming and storytelling.

### Success Criteria

The game succeeds when the player feels:
- Absorbed by the interface
- Curious about every discrepancy
- Pressured by procedure
- Responsible for outcomes
- Increasingly fluent in the world's systems
- Disturbed by what the records imply
- Intelligent for understanding what the machine is trying to hide

---

## Development Notes

### Running the Game
```bash
love .                    # Run with LÖVE2D
lua headless_smoke.lua    # Run tests (no LÖVE needed)
luac -p *.lua             # Syntax check all files
```

### Adding New Content

**New Record**: Add to `data.records` in `data.lua` with fields: `title`, `category`, `access_level`, `content` (segment array), `keywords`, `cross_refs`, `proof`. Optionally `requires_flag` for gated access.

**New Message**: Add to `data.messages` with `from`, `subject`, `body`. Queue delivery in `game.lua`'s `checkTriggers()` with `self:queueMessage("MSG-XXX", delay)`.

**New Action**: Add to `data.actions` with `label`, `description`, `requirements`, `effects`, `result`. For ending actions, add `ending = "ending_name"` and a corresponding entry in `data.endings`.

**New Command**: Add `handlers.COMMAND_NAME = function(game, args)` in `commands.lua`. Update `handlers.HELP()` to include it. Add tab completion entries in `getCompletions()`.

**New Override Code**: Add to `data.overrides` with `flag`, `description`, optionally `requires_flag`, `metrics`, `queue_messages`.

### Key Invariants

- `main.lua` and `conf.lua` MUST remain at the project root (LÖVE requirement)
- Terminal content always uses the segments pattern (`{text, color}` arrays)
- Game state must be fully serializable (no functions, no circular references)
- Save system writes are always atomic (temp → verify → backup → write → verify → cleanup)
- Menu callbacks never directly access game state — always through getter closures
- The typewriter queue must be flushable at any time without losing content
- Post-processing effects are optional — the game must look good without them

### What NOT to Change

- `lib/moonshine/` — Vendored shader library, do not modify
- `lib/json.lua` — Vendored JSON library, do not modify
- `lv_100/` — Reference project, not part of the game
- The segments data format `{text, color}` — used everywhere, changing it would require touching every file
- The save format version — bump `Save.VERSION` and handle migration if the schema changes
