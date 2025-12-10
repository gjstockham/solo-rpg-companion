# Decisions Log

Track key decisions made during discovery.

---

## Decision 001: Deployment Architecture

**Date:** 2025-12-09
**Phase:** 2 - Research
**Decision:** Local app with cloud LLM (BYOK model)

**Options considered:**
1. Fully cloud-hosted (SaaS)
2. Local app with cloud LLM ✅ Selected
3. Fully local (app + LLM)

**Rationale:**
- User owns their data (local app)
- OpenAI-compatible API gives flexibility (Claude, OpenAI, local Ollama)
- "Bring your own API key" - no vendor lock-in, no cost management for us
- Future-proofs for local LLM option without architectural changes

**Implications:**
- No user accounts or authentication needed
- No subscription/payment infrastructure
- User responsible for API costs
- Must support OpenAI-compatible API format

---

## Decision 002: Internet Requirement

**Date:** 2025-12-09
**Phase:** 2 - Research
**Decision:** Internet required for MVP, offline possible with local models

**Rationale:**
- Simplifies MVP scope
- Local Ollama models enable offline play for advanced users
- Same OpenAI-compatible interface works for both

**Implications:**
- No offline-first architecture needed
- Can cache game state locally for resilience
- Document local model setup for power users

---

## Decision 003: MVP Rule System

**Date:** 2025-12-09
**Phase:** 2 - Research
**Decision:** Fate Accelerated + Mythic GME for MVP

**Options considered:**
1. Tales of the Valiant (D&D 5E variant) + Mythic GME + Adventure Crafter
2. Fate Accelerated (simpler, free) + Mythic GME ✅ Selected

**Rationale:**
- Faster to playable - validate core loop in weeks, not months
- Lower risk - debug AI rules application on simpler system first
- CC-BY license - no legal concerns
- Proves architecture - oracle + persistence + AI narration work regardless of rules complexity
- Modular design means adding ToV later proves the architecture

**Roadmap:**
1. MVP: Fate Accelerated + Mythic GME
2. Phase 2: Add Tales of the Valiant (proves modularity, PO's preferred stack)
3. Phase 3: Add Adventure Crafter (multiple oracle support)

---

## Decision 004: Technology Stack

**Date:** 2025-12-09 (Updated: 2025-12-10)
**Phase:** 3 - Ideation
**Decision:** Electron + TypeScript with Vercel AI SDK

**Options considered:**
1. Tauri + Python sidecar - Complex IPC, packaging issues
2. Electron + Python - Large bundle, two languages
3. Pure Python (PyQt/PySide) - PO unfamiliar
4. .NET MAUI + C# - No Linux support ❌
5. Electron + TypeScript + Vercel AI SDK ✅ Selected

**Rationale:**
- **Linux support required** - .NET MAUI does not support Linux desktop
- PO has HTML/CSS/JS familiarity - web technologies transfer directly
- Electron provides true cross-platform (Windows, Mac, **Linux**)
- Vercel AI SDK provides clean TypeScript AI tooling with:
  - Native tool use / function calling
  - Multi-provider support (Claude, OpenAI, etc.)
  - Model Context Protocol (MCP) support
  - Streaming responses
- Huge npm ecosystem for any additional needs
- Single language codebase (TypeScript)
- Hot reload, fast iteration during development

**Trade-offs:**
- Larger app bundle (~150MB vs ~50MB for native)
- Higher memory usage than native apps
- Chromium-based (not truly native UI)

**Implications:**
- Use Vercel AI SDK for LLM integration and agent patterns
- SQLite via better-sqlite3 or similar
- Vector store options: Qdrant, LanceDB, or in-memory for MVP
- Can use any frontend framework (React, Vue, Svelte, or vanilla)
- Web ecosystem alignment

---

## Decision 005: Interaction Model

**Date:** 2025-12-09
**Phase:** 3 - Ideation
**Decision:** Chat-first conversational interface (no quick-action buttons)

**Options considered:**
1. Chat-based (Conversational GM) ✅ Selected
2. Panel-based with action buttons (Structured Scene Player)
3. Hybrid with Quick Mode buttons + Detail Mode

**Rationale:**
- Natural GM interaction - like talking to a real person
- Avoids "text adventure game" feel (e.g., The Hobbit on ZX Spectrum)
- More immersive experience
- Voice can be added as future enhancement to same interaction model
- Better alignment with core value prop: "feel like playing with a GM"

**Future enhancement:**
- Voice input/output to further enhance natural interaction
- Text remains primary for MVP, voice in future phase

**Implications:**
- Simpler UI to build
- AI prompt engineering focused on conversational flow
- Need to handle mechanics (dice, rules) within natural conversation
- Export/journaling still important (text logs)

---

## Decision 006: Dice Rolling UX

**Date:** 2025-12-10
**Phase:** 4 - Validation
**Decision:** GM explains and requests rolls conversationally, with optional click-to-roll

**Approach:**
- GM explains what roll is needed and why: "This is a skill check for persuasion, so roll D20 and add your Charisma modifier (D20 + 5)"
- Player can physically roll and report the result
- Small dice icon appears next to roll requests - click to auto-roll if player prefers
- Keeps conversation natural while providing convenience option

**Rationale:**
- Maintains conversational immersion (GM explains like a real GM would)
- Physical dice rolling is part of the RPG experience for many players
- Click-to-roll provides convenience without forcing it
- Educational: GM explains the "why" behind rolls

**Implications:**
- Need inline roll detection in chat to place dice icon
- Auto-roll needs to understand dice notation (2D8+6, D20+5, 4dF, etc.)
- Results from auto-roll should be shown naturally in conversation

---

## Decision 007: Combat/Conflict Agent

**Date:** 2025-12-10
**Phase:** 4 - Validation
**Decision:** Separate AI agent for combat/conflict resolution

**Rationale:**
- Combat rules vary wildly between systems (Fate stress vs D&D HP vs narrative systems)
- Complex state tracking (initiative, conditions, positioning)
- Different pacing than narrative play
- Allows specialized prompting and tool use for tactical situations
- Can be swapped out per rules system

**Implications:**
- Multi-agent architecture: GM agent + Combat agent (per rules system)
- Handoff protocol between agents
- Combat agent needs access to character stats, enemy stats, battlefield state
- May need different UI treatment during combat (turn order, status tracking)

---

## Decision 008: GM Personality Configuration

**Date:** 2025-12-10
**Phase:** 4 - Validation
**Decision:** User-selectable GM personality rather than adaptive prompting

**Options considered:**
1. Adaptive AI prompting based on context
2. User chooses GM personality preset ✅ Selected

**Rationale:**
- Simpler implementation
- Player knows what to expect
- Matches how players choose GMs in real life
- Can offer presets: "Dramatic storyteller", "Rules-focused", "Comedic", "Dark & gritty", etc.

**Implications:**
- GM personality stored as system prompt modifier
- Could allow custom personality descriptions
- Personality affects narration style, not rules application

---

## Decision 009: Session State Model

**Date:** 2025-12-10
**Phase:** 4 - Validation
**Decision:** Two-tier session model - Chat Session (in-progress) → Session Log (summary)

**Model:**
```
Chat Session (active)
  - Full conversation transcript
  - Working state (uncommitted changes)
  - Real-time interaction
        ↓
    [End Session]
        ↓
Session Log (persisted)
  - Summarized narrative
  - Confirmed state changes (NPCs, locations, plot threads)
  - Mythic GME updates (chaos factor, thread list)
```

**Rationale:**
- Follows Mythic GME pattern: update at scene/session boundaries
- Avoids constant state churn during play
- Summary is cleaner for journaling/export
- Player can review before committing changes
- Reduces AI hallucination risk in persistent state

**Implications:**
- Need "End Session" flow that:
  1. Generates narrative summary
  2. Extracts state changes (new NPCs, locations, inventory changes)
  3. Updates Mythic GME state (chaos factor, threads, NPCs list)
  4. Presents changes for player review/edit
  5. Commits to persistent storage
- Chat Session can be recovered if app crashes mid-session
- Session Log becomes the canonical record

---

## Decision 010: Hybrid Storage Architecture (File System + Database)

**Date:** 2025-12-10
**Phase:** 5 - Requirements
**Decision:** Player-visible content stored as files (like Obsidian), app-internal data in SQLite/vector store

**Architecture:**
```
Campaign Folder (file system - player-browsable)
├── sessions/
│   ├── session-001.md          # Session log (markdown)
│   ├── session-002.md
│   └── ...
├── world/
│   ├── npcs/
│   │   ├── guild-master-thorne.md
│   │   └── captain-elena.md
│   ├── locations/
│   │   ├── guild-hall.md
│   │   └── docks-district.md
│   └── factions/
│       └── merchant-guild.md
├── character.md                 # Character sheet (markdown)
└── campaign.md                  # Campaign overview

App Data (SQLite + vector store - internal)
├── campaign.db                  # Search indexes, relationships, metadata
├── conversation-log.db         # Current chat session (ephemeral)
└── embeddings/                  # Vector store for semantic search
```

**Rationale:**
- Player can browse/edit world content like an Obsidian vault
- Player owns their data in human-readable format
- Export is "already done" - files are the source of truth
- SQLite provides fast search/indexing without duplicating content
- Vector store enables semantic search across markdown files
- Matches existing Obsidian workflow PO already uses

**Implications:**
- Markdown files are the canonical source for world state
- SQLite indexes/caches markdown content for fast lookup
- Character sheet is markdown (not database record)
- Session logs written directly to disk after each session
- App reads from files on startup, watches for external changes
- "World wiki" feel - player can organize however they want

---

## Decision 011: Rules as AI Agent Knowledge (not compiled code)

**Date:** 2025-12-10
**Phase:** 5 - Requirements
**Decision:** Rules encoded as AI agent knowledge with markdown/JSON representations, not compiled code

**Approach:**
- Rules system defined in markdown (human-readable rules text)
- Character/NPC state stored as JSON or markdown (not TypeScript objects)
- AI agent "knows" the rules via system prompt + RAG
- Dice mechanics are simple utility functions, not encoded game logic
- AI interprets and applies rules conversationally

**Example:**
```markdown
# Fate Accelerated Rules

## Approaches
When you act, choose one of six approaches:
- Careful: +2
- Clever: +3
- Flashy: +1
...

## Resolution
Roll 4dF + approach rating vs difficulty.
- Beat by 3+: Success with Style
- Beat by 1-2: Success
- Tie: Success at cost
- Fail: Complication
```

```json
// character.json (or character.md with frontmatter)
{
  "name": "Kira",
  "approaches": {
    "careful": 2,
    "clever": 3,
    "flashy": 1,
    "forceful": 2,
    "quick": 1,
    "sneaky": 2
  },
  "stress": 3,
  "consequences": []
}
```

**Rationale:**
- More flexible - AI can interpret edge cases
- Easier to add new rules systems (just markdown + schema)
- No recompilation needed for rules changes
- Player can read/understand their character data
- AI agents excel at applying written rules
- Modular by design - each system is just a knowledge package

**Trade-offs:**
- Less deterministic than compiled code
- Relies on AI consistency (mitigated by clear rules text)
- May need validation for critical mechanics (dice math)

**Implications:**
- Rules systems are "knowledge packs" (markdown + JSON schema)
- TypeScript code limited to: dice rolling, file I/O, UI, LLM orchestration
- AI agent is responsible for rules interpretation
- Character sheets are JSON/markdown, not database entities

---

## Decision 012: Chat Session Saves After Every Message

**Date:** 2025-12-10
**Phase:** 5 - Requirements
**Decision:** Current chat session auto-saves after every message (no separate auto-save interval)

**Rationale:**
- Eliminates data loss risk entirely
- Simpler than periodic auto-save
- Modern storage is fast enough
- Crash recovery is trivial - just reload last message

**Implications:**
- Remove auto-save timer logic
- Conversation log writes are append-only (fast)
- No "unsaved changes" warning needed
- Session recovery = load conversation log

---

## Decision 013: Graph RAG Exploration Spike

**Date:** 2025-12-10
**Phase:** 5 - Requirements
**Decision:** Add technical spike to explore Graph RAG for world knowledge connections

**Rationale:**
- World knowledge has rich relationships (NPC knows NPC, location contains location, faction controls territory)
- Graph RAG could improve context retrieval for interconnected queries
- "Who does the merchant guild have conflicts with?" benefits from graph traversal
- Standard vector RAG may miss relationship-based queries

**Spike scope:**
- Evaluate graph database options (Neo4j, or graph layer on SQLite)
- Test graph RAG vs vector RAG for relationship queries
- Assess complexity vs benefit for MVP
- Determine if graph is MVP or post-MVP

**Implications:**
- Add to technical spike backlog
- May influence storage architecture
- Could enhance world-building features

---

## Decision 014: Modular Architecture from Day One

**Date:** 2025-12-10
**Phase:** 5 - Requirements
**Decision:** Build modular architecture for rules/oracle systems even though MVP only has Fate + Mythic GME

**Rationale:**
- Avoid refactoring when adding Tales of the Valiant
- Rules as "knowledge packs" already supports this (Decision 011)
- Oracle systems should be pluggable
- Small upfront investment saves significant rework later

**Implications:**
- Define clear interfaces for rules systems
- Define clear interfaces for oracle systems
- Each system is a self-contained package (markdown + schema + optional tools)
- MVP validates the plugin architecture with one of each

---
