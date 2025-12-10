# MVP Scope & Feature Backlog: Solo RPG Companion App

**Project**: Solo RPG Companion App
**Phase**: Phase 6 - MVP Scoping
**Date**: 2025-12-10
**Created by**: @business-analyst
**Status**: Updated with architectural decisions 010-014

---

## Executive Summary

This document defines the MVP scope, prioritized feature backlog, phased roadmap, and technical spikes required for the Solo RPG Companion App.

**MVP Goal**: Validate that an AI-powered conversational GM with integrated oracle and rules system solves solo RPG pain points (creative generation fatigue, rules overhead, record-keeping burden).

**Success Criteria**:
- 10+ users complete campaigns of 5+ sessions each
- Zero manual rule lookups during play
- Session start time averages under 2 minutes
- Users successfully resume campaigns after 1+ week gap
- 80%+ of users report genuine narrative surprises

**MVP Timeline Estimate**: 10-14 weeks (2.5-3.5 months) to beta-ready *(reduced from 12-16 weeks due to simplified architecture)*

---

## Architectural Changes (Decisions 010-014)

**Key simplifications**:
- **Decision 010**: Hybrid storage (markdown files + SQLite indexes) - simpler, player-browsable
- **Decision 011**: Rules as AI knowledge (not C# code) - no rules compiler needed
- **Decision 012**: Save after every message - no auto-save timer logic
- **Decision 013**: Graph RAG spike added - may enhance world knowledge
- **Decision 014**: Modular architecture from day one - plugin-ready

**Impact**: Reduced complexity, faster implementation, better player data ownership

---

## Table of Contents

1. [MVP Scope Definition](#1-mvp-scope-definition)
2. [Feature Backlog](#2-feature-backlog)
3. [MVP Roadmap](#3-mvp-roadmap)
4. [Technical Spikes Required](#4-technical-spikes-required)
5. [Out of Scope (Post-MVP)](#5-out-of-scope-post-mvp)
6. [Success Metrics & Validation](#6-success-metrics--validation)

---

## 1. MVP Scope Definition

### 1.1 In Scope (MVP Must Have)

#### Core Features

**1. Core Chat Experience**
- Conversational chat interface with natural language input
- AI GM narrates scenes, prompts for actions, responds to player input
- Markdown rendering for rich text formatting
- Chat history display with smooth scrolling
- Character sheet panel (always visible on desktop)
- Scene context panel (current location, NPCs, threads)

**2. Dice Rolling & Rules (Fate Accelerated Only)**
- GM explains rolls conversationally with dice notation
- Physical dice support: player rolls, types result
- Click-to-roll option: dice icon for digital rolling
- Auto-roll setting: always digital for speed
- Fate Accelerated mechanics via AI interpretation:
  - 6 Approaches (Careful, Clever, Flashy, Forceful, Quick, Sneaky)
  - 4 Actions (Overcome, Create Advantage, Attack, Defend)
  - Roll resolution (4dF + bonus vs difficulty)
  - Success levels (Success with Style, Success, Tie, Failure)
  - Aspects (Character aspects, situation aspects, invokes)
  - Stress tracking (1-4 boxes)
  - Consequences (Mild, Moderate, Severe)
  - Fate points (spending, gaining)
- Rules as markdown documents (Decision 011)
- AI agent interprets and applies rules via RAG
- First-time mechanic explanations

**3. Oracle Integration (Mythic GME)**
- Invisible oracle consultation for yes/no questions
- Fate Chart with likelihood assessment
- Chaos Factor tracking (1-9, starts at 5)
- Random event checks at scene transitions
- NPC/Thread/Location lists maintained by Mythic GME
- Oracle transparency setting (show rolls in game log)

**4. Session & State Management**
- Campaign creation (name, character, rules system)
- Campaign selection and loading from campaign folder
- Session start with AI-generated recap (based on last session log)
- Session end flow with AI-generated summary
- Two-tier state model (Decision 009):
  - Chat Session (active, full transcript, working state)
  - Session Log (persisted markdown, summary, committed changes)
- Save after every message (Decision 012) - no auto-save timer
- Mid-session crash recovery (reload last message)

**5. State Persistence (Hybrid Architecture - Decision 010)**
- **Campaign folder structure** (file system - player-browsable):
  ```
  Campaign Folder/
  ├── sessions/
  │   ├── session-001.md       # Session logs (markdown)
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
  ├── character.md             # Character sheet (markdown with frontmatter)
  └── campaign.md              # Campaign overview
  ```
- **App data** (SQLite + vector store - internal):
  - `campaign.db` - Search indexes, relationships, metadata
  - `conversation-log.db` - Current chat session (ephemeral)
  - `embeddings/` - Vector store for semantic search
- Character sheet as markdown (not database record)
- NPC/location/faction pages as markdown files (Obsidian-like)
- Session logs written directly to markdown after each session
- SQLite indexes markdown content for fast search
- Vector store enables semantic search across markdown files
- Portable campaign files (copy folder to new machine)

**6. Campaign Management**
- Campaign folder selection (browse file system)
- New campaign creation (creates folder structure)
- Delete campaign (with confirmation)
- Campaign settings stored in `campaign.md` frontmatter (GM personality, narration style, dice preferences)

#### Platform Scope

**MVP Platforms**: Windows 10+ and macOS 11+
- Desktop-first for MVP (larger screen, better for reading/typing)
- .NET MAUI supports both platforms from single codebase
- Mobile (iOS/Android) optimization deferred to post-MVP

#### Rules System Scope

**MVP Rules System**: Fate Accelerated ONLY (as "knowledge pack" - Decision 011, 014)
- Rules stored as markdown documents in rules package
- Character/NPC state stored as JSON or markdown (not C# objects)
- AI agent "knows" rules via system prompt + RAG
- Dice mechanics are simple utility functions
- Modular design: rules system is a self-contained package

**Post-MVP**: Add Tales of the Valiant (PO's preferred system) to prove modularity

#### Oracle Scope

**MVP Oracle**: Mythic GME ONLY (as "knowledge pack" - Decision 014)
- Oracle rules stored as markdown
- Oracle state in markdown (chaos factor, lists)
- AI agent applies oracle via interpretation
- Modular design: oracle system is pluggable

**Post-MVP**: Add Adventure Crafter, other oracle systems

---

### 1.2 Out of Scope (MVP)

**Explicitly deferred to post-MVP releases**:

#### Combat/Conflict (P1 - Stretch Goal)
- Separate Combat Agent (Decision 007) for tactical conflicts
- Turn-based initiative and turn order
- Multi-NPC stress tracking
- Combat-specific UI (turn indicator, NPC status)
- **Rationale**: Requires separate validation walkthrough (Open Question Q2). If time permits, add as stretch goal. Core play loop works without specialized combat.

#### GM Personality Selection (P1 - Important but not blocking)
- User-selectable personality presets (Dramatic, Rules-Focused, Comedic, Dark & Gritty, Neutral)
- Custom personality description (advanced users)
- **Rationale**: Enhances experience but not required to validate core concept. Default to "Neutral Balanced" for MVP.

#### Advanced Features (P2 - Post-MVP)
- Conversation search and filter
- Session export (already done - files are the source)
- Character creation wizard (guided)
- Campaign setup wizard (genre, setting, tone)
- NPC relationship visualization
- Multiple character party support
- Rule explanation system (beyond first-time explanations)
- Advanced analytics/insights

#### Future Enhancements (P3+)
- Voice input/output (Concept 1b - validated as future enhancement)
- Multiple rules systems (Tales of the Valiant, D&D 5e, etc.)
- Mobile native optimization
- Cloud sync / backup (player can manually sync campaign folder)
- Offline mode with local LLM (already supported via OpenAI-compatible API)
- Multiplayer / shared campaigns
- Community / sharing features

---

### 1.3 MVP Success Criteria

**Technical Success** (MVP is "done" when):
- [ ] 10+ users complete campaigns of 5+ sessions each
- [ ] Users report zero manual rule lookups during play
- [ ] Session start time averages under 2 minutes
- [ ] Users successfully resume campaigns after 1+ week gap
- [ ] 80%+ of users report genuine narrative surprises in sessions
- [ ] Technical architecture supports adding second rules system post-MVP (modularity validated)

**User Experience Success**:
- [ ] Players feel like they're playing with a real GM (qualitative feedback)
- [ ] Oracle integration feels invisible and surprising (qualitative feedback)
- [ ] Session continuity works after long gaps (user testing)
- [ ] No cognitive overhead from record-keeping (user testing)
- [ ] Rules application is consistent and correct (user testing + validation)

**Technical Quality**:
- [ ] Session start time: median < 90 seconds, 90th percentile < 2 minutes
- [ ] AI response latency: median < 3 seconds, 95th percentile < 8 seconds
- [ ] Message save completes within 100ms (append-only writes)
- [ ] No data loss (messages saved after every turn)
- [ ] Campaign loads reliably after 1+ week gap

---

## 2. Feature Backlog

### Epic 1: Core Chat Experience

| ID | Feature | Priority | Effort | Dependencies | Acceptance Criteria |
|----|---------|----------|--------|--------------|---------------------|
| **FB-001** | Campaign Folder Selection | P0 (MVP must) | S | None | User can browse file system, select campaign folder, see last played date and session count, create new campaign, delete campaign with confirmation |
| **FB-002** | Campaign Creation | P0 (MVP must) | S | FB-001 | User provides campaign name, character name, rules system (Fate Accelerated default). Creates folder structure (sessions/, world/, character.md, campaign.md). User immediately in conversation with AI. |
| **FB-003** | Chat Interface UI | P0 (MVP must) | M | None | Message bubbles (GM/Player/System), text input field, send button, Enter key submits, smooth scrolling, markdown rendering |
| **FB-004** | Character Sheet Panel | P0 (MVP must) | M | None | Always visible on desktop (left panel), shows Fate Accelerated stats from character.md (approaches, aspects, stress, consequences, fate points, inventory), auto-updates with pulse animation |
| **FB-005** | Scene Context Panel | P0 (MVP must) | S | None | Shows current location, NPCs present, active threads, session number. Updates as scene changes. Header or right panel on desktop. |
| **FB-006** | Settings Screen | P0 (MVP must) | M | None | LLM configuration (endpoint, API key, model), Gameplay preferences (narration style, auto-roll, show oracle), About section. API key stored securely. |
| **FB-007** | Conversation History Display | P0 (MVP must) | S | FB-003 | Last 50 messages in view, infinite scroll for older messages, timestamps (optional display), 60fps scrolling |
| **FB-008** | Markdown Rendering | P0 (MVP must) | XS | FB-003 | Renders bold, italic, lists, headings, code blocks in chat messages. Uses Markdig library. |

---

### Epic 2: AI Conversation Engine

| ID | Feature | Priority | Effort | Dependencies | Acceptance Criteria |
|----|---------|----------|--------|--------------|---------------------|
| **FB-010** | AI Conversation Engine | P0 (MVP must) | XL | FB-003, FB-020 | LLM integration via Semantic Kernel or Azure OpenAI SDK. Responds within 2-5 seconds. Interprets player intent correctly 90%+ of time (validation testing). |
| **FB-011** | Natural Language Action Input | P0 (MVP must) | M | FB-010 | User types actions in natural language. AI analyzes intent (action vs question vs meta-query). Asks clarifying questions if ambiguous. Never forces predetermined choices. |
| **FB-012** | AI Response Patterns | P0 (MVP must) | M | FB-010 | AI uses distinct patterns: Narration, Prompt for Action, Mechanical Prompt, Rule Explanation. Response length adapts to user's Narration Style setting. |
| **FB-013** | Context Management | P0 (MVP must) | M | FB-010, FB-025 | AI context includes: character.md, scene state, recent history (20-30 turns), rules markdown docs (RAG), relevant campaign history (RAG retrieval). Total context budget ~25k-40k tokens. |
| **FB-014** | AI Tool Registration | P0 (MVP must) | M | FB-010 | AI has access to tools: roll_dice, check_rule, resolve_action, invoke_oracle, get_character_state, update_character_state, read_npc_file, write_npc_file, get_scene_context, update_scene |

---

### Epic 3: Dice Rolling & Rules (Fate Accelerated)

| ID | Feature | Priority | Effort | Dependencies | Acceptance Criteria |
|----|---------|----------|--------|--------------|---------------------|
| **FB-020** | Fate Accelerated Rules Package | P0 (MVP must) | M | None | Fate Accelerated rules as markdown documents. Character/NPC state as JSON schema. Rules stored in knowledge pack (markdown + schema). AI interprets rules via RAG (not compiled C# code). Decision 011 implementation. |
| **FB-021** | Dice Roll Request & Explanation | P0 (MVP must) | M | FB-020, FB-010 | AI requests rolls conversationally. Explains approach, dice notation, difficulty. Displays dice icon inline for click-to-roll option. Roll requests are natural, not robotic. |
| **FB-022** | Physical Dice Result Input | P0 (MVP must) | M | FB-021 | Player types result: "+2", "[-][+][+][0]", "I got +2". AI parses correctly. If unparseable, asks for clarification. |
| **FB-023** | Click-to-Roll Digital Dice | P0 (MVP must) | M | FB-021 | Dice icon appears next to roll request. Click rolls 4dF (or other dice types), displays result naturally in chat. Supports dF, d4, d6, d8, d10, d12, d20, d100. Completes within 500ms. Cryptographically secure RNG. |
| **FB-024** | Auto-Roll Setting | P1 (MVP should) | S | FB-023 | Setting: "Always auto-roll dice" (default: OFF). When enabled, AI automatically rolls and reports results without player interaction. Persists across sessions. |
| **FB-025** | Rules RAG Implementation | P0 (MVP must) | M | FB-020 | Fate Accelerated rules markdown chunked, embedded via Semantic Kernel. AI tool: check_rule(query) retrieves relevant rules. Retrieval latency < 500ms. Simpler than C# encoding. |
| **FB-026** | Action Intent Mapping | P0 (MVP must) | M | FB-020, FB-011 | AI maps player action to Fate mechanics: action type (Overcome, Create Advantage, Attack, Defend), approach (or clarifies), difficulty. 90%+ correct identification (validation). AI interprets, not C# code. |
| **FB-027** | Aspect Invoke Prompting | P0 (MVP must) | M | FB-020, FB-041 | AI suggests relevant aspect invokes at appropriate moments. Conversational suggestions. Player decides whether to spend fate point. Fate point tracking in character.md. 80%+ relevant suggestions. |
| **FB-028** | Consequence Selection Flow | P0 (MVP must) | M | FB-020, FB-041 | When stress boxes full, AI prompts for consequence. Explains options (Mild/Moderate/Severe). Offers examples. Records player-described consequence in character.md. |
| **FB-029** | First-Time Mechanic Explanation | P1 (MVP should) | S | FB-020 | Track which mechanics player has encountered per campaign (in campaign.md). First encounter: AI explains briefly. Subsequent: AI applies silently (unless player asks). |

---

### Epic 4: Oracle Integration (Mythic GME)

| ID | Feature | Priority | Effort | Dependencies | Acceptance Criteria |
|----|---------|----------|--------|--------------|---------------------|
| **FB-040** | Mythic GME Yes/No Oracle | P0 (MVP must) | M | FB-010 | AI consults Mythic Fate Chart invisibly. Assigns likelihood (Impossible to Already Is), cross-references Chaos Factor (1-9), rolls d100. Result: Exceptional No, No, Yes, Exceptional Yes. Only narrative surfaces to player. Oracle rules as markdown (Decision 011). |
| **FB-041** | Chaos Factor Tracking | P0 (MVP must) | S | FB-040, FB-053 | Chaos Factor starts at 5. Adjusted at session end: -1 (control), 0 (mixed), +1 (chaos). Min 1, Max 9. Affects oracle probabilities. Stored in campaign.md frontmatter. |
| **FB-042** | Random Event Checks | P0 (MVP must) | M | FB-040, FB-041 | At scene transitions, roll d10. If ≤ Chaos Factor, random event occurs. AI interprets event naturally in narrative. Events feel surprising but contextually appropriate (validation). |
| **FB-043** | NPC/Thread/Location Lists | P0 (MVP must) | M | FB-050, FB-051, FB-052 | Mythic GME maintains lists: NPCs (active/resolved/unknown), Threads (active/resolved/abandoned), Locations (visited). Updated at session end in campaign.md. Oracle can reference lists for events. |
| **FB-044** | Oracle Transparency Setting | P1 (MVP should) | S | FB-040 | Setting: "Show oracle rolls" (default: OFF). When enabled, oracle consultations visible in game log with details (likelihood, chaos, roll, result). Does not display in main chat. |

---

### Epic 5: Session & State Management

| ID | Feature | Priority | Effort | Dependencies | Acceptance Criteria |
|----|---------|----------|--------|--------------|---------------------|
| **FB-050** | Campaign Loading | P0 (MVP must) | M | FB-001, FB-060 | User selects campaign folder. Reads last session log markdown, character.md, campaign.md (Mythic GME state). Loads within 2 seconds. Decision 010 implementation. |
| **FB-051** | Session Start with AI Recap | P0 (MVP must) | M | FB-050, FB-010 | AI generates 2-3 sentence recap based on last session log markdown. Includes last scene, last action, current stakes. Recap generated within 30 seconds. User can ask clarifying questions. |
| **FB-052** | Chat Session (In-Progress) | P0 (MVP must) | M | FB-010 | Full conversation transcript in memory and conversation-log.db. Saves after every message (Decision 012). Real-time interaction. No auto-save timer needed. |
| **FB-053** | Session End & Summary Generation | P0 (MVP must) | L | FB-052, FB-010, FB-041, FB-043 | Trigger: Player says "end session" or closes app. AI generates 2-3 paragraph narrative summary. Extracts state changes (NPCs, locations, inventory, threads). Updates Mythic GME state (chaos factor) in campaign.md. Creates markdown files for new NPCs/locations in world/ folder. Writes session-NNN.md. Presents changes for player review/edit. Completes within 30 seconds. |
| **FB-054** | Message-by-Message Save & Recovery | P0 (MVP must) | S | FB-052 | Save after every message to conversation-log.db (Decision 012). On crash, resume from last message. Zero message loss. Simpler than auto-save timer. |
| **FB-055** | Character State Auto-Update | P0 (MVP must) | M | FB-041 | Character.md updates automatically: stress, fate points, aspects, consequences, inventory. Triggers: damage, aspect invoke, consequence added, inventory change, fate point spend/gain. Updates within 100ms. Visual feedback: pulse animation. Markdown write is fast. |
| **FB-056** | NPC/Location File Generation | P0 (MVP must) | M | FB-010, FB-060 | AI generates NPCs/locations naturally (name, personality, description). Named NPCs/locations auto-saved as markdown files in world/npcs/ or world/locations/ at session end. Markdown format: frontmatter (metadata) + description. Remembered consistently across sessions via file reading + RAG. |

---

### Epic 6: Data Persistence (Hybrid Architecture - Decision 010)

| ID | Feature | Priority | Effort | Dependencies | Acceptance Criteria |
|----|---------|----------|--------|--------------|---------------------|
| **FB-060** | Markdown File Management | P0 (MVP must) | M | None | Campaign folder structure: sessions/, world/npcs/, world/locations/, world/factions/, character.md, campaign.md. File watcher for external changes. Markdown parser (Markdig + YamlDotNet for frontmatter). Write operations atomic (temp file + rename). |
| **FB-061** | Session State Model (Two-Tier) | P0 (MVP must) | M | FB-060, FB-053 | Chat Session (active): conversation-log.db, working state. Session Log (persisted): session-NNN.md (markdown summary). Transition at session end. Decision 009 + 010 implementation. |
| **FB-062** | Conversation Log Persistence | P0 (MVP must) | S | FB-060 | Store current chat session in conversation-log.db (SQLite, ephemeral). Message saved after every message (Decision 012). Loads within 1 second on campaign resume. Cleared at session end (summary moved to session-NNN.md). |
| **FB-063** | Vector Store for Semantic Search | P0 (MVP must) | M | FB-060 | Embed session markdown files and world markdown files via Semantic Kernel Memory. Metadata: session number, NPCs, locations, tags, date. AI can query: "What happened with the merchant guild?" Retrieval latency < 500ms. Top 3-5 chunks retrieved. Vector embeddings stored in embeddings/ folder or linked to campaign.db. |
| **FB-064** | SQLite Search Indexes | P0 (MVP must) | S | FB-060 | campaign.db stores indexes and metadata for fast search: NPC names, location names, session dates, tags. Does not duplicate markdown content (Decision 010). Rebuilt from markdown files on campaign load. Enables fast filtering and queries. |
| **FB-065** | Campaign Export | P0 (MVP must) | XS | FB-060 | Export = zip campaign folder. Already done - files are the source of truth (Decision 010). User can manually copy/share campaign folder. Import = unzip and select folder. Extremely simple. |

---

### Epic 7: Combat & Conflict (P1 - Stretch)

| ID | Feature | Priority | Effort | Dependencies | Acceptance Criteria |
|----|---------|----------|--------|--------------|---------------------|
| **FB-070** | Combat Encounter Detection | P1 (stretch) | M | FB-010, FB-020 | GM Agent detects combat initiation (multiple hostile NPCs, initiative needed). Seamless handoff to Combat Agent. Combat Agent has access to character.md, NPC markdown files, battlefield context. |
| **FB-071** | Combat Agent Implementation | P1 (stretch) | L | FB-070 | Separate AI agent for combat resolution (Decision 007). Specialized system prompt and tools. Fate Accelerated conflict rules. Turn-by-turn structure. Different pacing than narrative. Returns control to GM Agent after combat ends. |
| **FB-072** | Initiative & Turn Order | P1 (stretch) | S | FB-071 | Combat Agent manages turn order. Displays turn order clearly. Prompts player when it's their turn. No strict initiative in Fate Accelerated, but tracks who acts when. |
| **FB-073** | Multi-NPC Stress Tracking | P1 (stretch) | M | FB-071, FB-020 | Each NPC has stress boxes (1-4 depending on importance) in their markdown file. Track stress, consequences, conditions per NPC. Display NPC status in combat UI (optional). NPCs taken out when stress overflows. |

---

### Epic 8: GM Personality & Polish (P1 - Important)

| ID | Feature | Priority | Effort | Dependencies | Acceptance Criteria |
|----|---------|----------|--------|--------------|---------------------|
| **FB-080** | GM Personality Presets | P1 (important) | S | FB-010 | User selects GM personality style: Dramatic Storyteller, Rules-Focused, Comedic, Dark & Gritty, Neutral (default). Stored in campaign.md frontmatter. Affects narration style, not rules application. Can change mid-campaign. Each preset has distinct tone (validation testing). |
| **FB-081** | Custom Personality Description | P2 (post-MVP) | S | FB-080 | Advanced users can write custom GM personality description in campaign.md. Validation: not empty, reasonable length. Produces consistent narration (validation testing). |
| **FB-082** | Narration Style Preference | P1 (important) | S | FB-010 | User controls AI response length: Terse (1-2 sentences), Balanced (2-3 sentences - default), Rich (3-5 sentences). Stored in campaign.md. Affects only narrative responses, not mechanical explanations. Change takes effect immediately. |
| **FB-083** | Conversation Search & Filter | P2 (post-MVP) | S | FB-062, FB-064 | Search conversation history by keyword (uses SQLite indexes + vector search). Filter by: All messages, Rolls only, Oracle only, NPCs, Locations. Search returns results within 500ms. Filters work correctly. Simpler with markdown + indexes. |
| **FB-084** | Session Export | P0 (MVP must) | XS | FB-060 | Already done - session logs are markdown files (Decision 010). User can open session-NNN.md in any text editor or Obsidian. No export feature needed. |

---

## 3. MVP Roadmap

### Phased Approach (10-14 weeks to beta-ready)
*(reduced from 12-16 weeks due to simplified architecture)*

---

### Phase A: Core Loop & Foundation (Weeks 1-3)
*(reduced from 4 weeks)*

**Goal**: Get to a playable core loop - player acts, AI responds, state persists

**Deliverables**:
- Basic chat interface (FB-003)
- AI conversation engine with Semantic Kernel (FB-010, FB-011, FB-012)
- Fate Accelerated rules as markdown package (FB-020) - simpler than C# encoding
- Physical dice rolling + click-to-roll (FB-021, FB-022, FB-023)
- Action intent mapping via AI (FB-026)
- Markdown file management (FB-060)
- Character sheet panel reading character.md (FB-004)

**Features Included**:
- Epic 1 (Core Chat): FB-003, FB-004
- Epic 2 (AI Conversation): FB-010, FB-011, FB-012, FB-014
- Epic 3 (Dice & Rules): FB-020, FB-021, FB-022, FB-023, FB-026
- Epic 6 (Data Persistence): FB-060

**Effort Estimate**: 3 weeks *(reduced - no C# rules encoding)*
- Week 1: .NET MAUI setup, basic chat UI, AI integration
- Week 2: Fate Accelerated markdown rules, dice rolling, file management
- Week 3: Natural language action input, intent mapping, character.md reading/writing

**Validation**: Can play a single session with dice rolls, basic Fate rules, and state saved to markdown

---

### Phase B: Oracle & Rules Integration (Weeks 4-6)
*(reduced from 4 weeks)*

**Goal**: Integrate Mythic GME oracle and complete Fate Accelerated rules

**Deliverables**:
- Mythic GME oracle as markdown package (FB-040, FB-041, FB-042, FB-043)
- Rules RAG for AI reasoning (FB-025) - simpler with markdown
- Aspect invokes and consequence selection (FB-027, FB-028)
- Scene context panel (FB-005)
- NPC/location markdown file generation (FB-056)
- Oracle transparency setting (FB-044)

**Features Included**:
- Epic 3 (Dice & Rules): FB-025, FB-027, FB-028
- Epic 4 (Oracle): FB-040, FB-041, FB-042, FB-043, FB-044
- Epic 1 (Core Chat): FB-005
- Epic 5 (Session Management): FB-056

**Effort Estimate**: 3 weeks *(reduced - oracle as markdown, not code)*
- Week 4: Mythic GME oracle mechanics (markdown rules + AI interpretation)
- Week 5: Random events, NPC/Thread/Location lists in campaign.md, RAG
- Week 6: Aspect invokes, consequence selection, NPC/location file generation

**Validation**: Can play with invisible oracle generating surprises, Fate rules fully applied

---

### Phase C: Session Lifecycle & Persistence (Weeks 7-10)

**Goal**: Complete session management - start, play, end, resume

**Deliverables**:
- Campaign folder selection and creation (FB-001, FB-002)
- Campaign loading from markdown files (FB-050)
- Session start with AI recap from markdown (FB-051)
- Chat session with message-by-message save (FB-052, FB-054) - simpler than auto-save timer
- Session end & markdown summary generation (FB-053)
- Two-tier session state model (FB-061)
- Character state auto-update to markdown (FB-055)
- Conversation log persistence to SQLite (FB-062)
- Vector store for semantic search (FB-063)
- SQLite search indexes (FB-064)
- Context management (FB-013)

**Features Included**:
- Epic 1 (Core Chat): FB-001, FB-002
- Epic 2 (AI Conversation): FB-013
- Epic 5 (Session Management): FB-050, FB-051, FB-052, FB-053, FB-054, FB-055
- Epic 6 (Data Persistence): FB-061, FB-062, FB-063, FB-064

**Effort Estimate**: 4 weeks
- Week 7: Campaign folder selection, creation, loading from markdown
- Week 8: Session start with recap, message-by-message save (simpler!)
- Week 9: Session end flow, markdown summary generation, NPC/location file creation
- Week 10: Vector store, SQLite indexes, semantic search, context management

**Validation**: Can create, play, end, and resume campaigns over multiple sessions

---

### Phase D: Polish & Validation (Weeks 11-14)
*(reduced from 4 weeks)*

**Goal**: Complete MVP feature set, user testing, bug fixing

**Deliverables**:
- Settings screen (FB-006)
- Conversation history display (FB-007)
- Markdown rendering (FB-008)
- Auto-roll setting (FB-024)
- First-time mechanic explanations (FB-029)
- Campaign export (FB-065) - trivial with markdown files
- GM personality presets (FB-080, FB-082) - if time permits
- Combat Agent (FB-070, FB-071, FB-072, FB-073) - stretch goal if time permits
- Bug fixes and polish
- User testing with 5-10 solo RPG players
- Performance optimization

**Features Included**:
- Epic 1 (Core Chat): FB-006, FB-007, FB-008
- Epic 3 (Dice & Rules): FB-024, FB-029
- Epic 6 (Data Persistence): FB-065
- Epic 8 (GM Personality): FB-080, FB-082 (if time)
- Epic 7 (Combat): FB-070, FB-071, FB-072, FB-073 (stretch)

**Effort Estimate**: 4 weeks
- Week 11: Settings screen, conversation history, markdown rendering, campaign export (trivial)
- Week 12: Auto-roll setting, first-time explanations, personality presets (if time)
- Week 13: User testing with 5-10 beta testers, bug fixing
- Week 14: Performance optimization, final polish, beta release prep

**Validation**: 10+ users complete 5+ session campaigns successfully

---

### Post-MVP (Phase 2+)

**Next Priorities After Beta**:
1. **Combat Agent** (if not in stretch) - Epic 7
2. **GM Personality & Narration Style** (if not in stretch) - Epic 8
3. **Conversation Search** (simpler with markdown + indexes) - Epic 8 (FB-083)
4. **Tales of the Valiant Rules System** - Validates plugin architecture (Decision 014)
5. **Mobile Optimization** - iOS and Android native
6. **Voice Input/Output** - Concept 1b enhancement
7. **Cloud Sync** - Optional backup (player can already manually sync campaign folder)

---

## 4. Technical Spikes Required

Technical spikes are time-boxed investigations to validate risky technical assumptions before committing to implementation.

---

### Spike 1: Long Campaign Context Management ⚠️ CRITICAL

**Risk Addressed**: TR-01 (Context management breaks down in long campaigns)

**Question**: Can hierarchical memory (Semantic Kernel) handle 50+ session campaigns without losing critical plot threads or NPCs?

**Approach**:
1. Implement hierarchical memory architecture:
   - Working memory (current session, 5-10k tokens)
   - Session memory (last 10 sessions summarized, 5k tokens)
   - Archival memory (all session markdown files embedded in vector store, retrieve top 3-5 chunks, 2-5k tokens)
   - Static context (rules markdown, character.md, 5-10k tokens)
   - Total budget: 25k-40k tokens
2. Create synthetic 50-session campaign with:
   - 10 major NPCs with markdown files in world/npcs/
   - 5 active plot threads in campaign.md
   - 20 location markdown files in world/locations/
   - Branching narrative decisions
3. Test AI recall after each session:
   - "Who is [NPC from session 10]?" (reads NPC markdown file)
   - "What happened with [plot thread from session 20]?" (RAG retrieves session markdown)
   - "Where did I acquire [item from session 30]?" (RAG + character.md)
4. Measure:
   - Recall accuracy (% of queries answered correctly)
   - Retrieval latency (< 500ms target)
   - Summary quality (manual review)
   - Context budget usage (stays within limits)

**Success Criteria**:
- 90%+ recall accuracy for major plot elements
- Retrieval latency < 500ms
- AI can reference events from 40+ sessions ago when relevant
- Context budget stays under 40k tokens

**Effort**: 1-2 weeks (1 developer)

**Timing**: Week 9-10 (during Phase C - Session Lifecycle)

**Status**: CRITICAL - Must validate before committing to long campaign support

**Note**: Markdown + RAG may actually improve recall (files are explicit, not buried in database)

---

### Spike 2: Rules Consistency Validation ⚠️ IMPORTANT

**Risk Addressed**: TR-02 (Rules inconsistency across sessions)

**Question**: Does AI interpretation of Fate Accelerated markdown rules produce consistent application across sessions?

**Approach**:
1. Create Fate Accelerated rules as markdown documents (FB-020)
2. Implement rules RAG for AI querying (FB-025)
3. Create test scenarios covering:
   - Overcome actions (various difficulties)
   - Create Advantage actions (free invokes)
   - Attack actions (stress application)
   - Defend actions (tie results)
   - Consequence selection (stress overflow)
   - Aspect invokes (fate point spending)
4. Run each scenario 10 times across different sessions
5. Measure:
   - Mechanical correctness (AI applies rules correctly)
   - Narrative consistency (AI explains same mechanic similarly)
   - Edge case handling (RAG provides correct context)

**Success Criteria**:
- 95%+ mechanical correctness (AI interprets rules correctly)
- 90%+ consistent narrative explanations (validation testing)
- Edge cases handled correctly via RAG context (manual review)

**Effort**: 1 week (1 developer)

**Timing**: Week 5-6 (during Phase B - Oracle & Rules Integration)

**Status**: IMPORTANT - Must validate AI rules interpretation approach (Decision 011)

**Note**: This is higher risk than C# encoding but more flexible. Must validate early.

---

### Spike 3: Dice Rolling UX Decision ⚠️ IMPORTANT

**Risk Addressed**: TR-V01 (Dice rolling UX ambiguity)

**Question**: What's the best dice rolling interaction? Physical only? Digital only? Hybrid?

**Approach**:
1. Implement all three options as prototypes:
   - **Option A**: Physical only - player rolls, types result
   - **Option B**: Digital only - click-to-roll
   - **Option C**: Hybrid - physical OR click-to-roll OR auto-roll setting
2. Test with 5-10 RPG players (mix of physical dice lovers and digital-first users)
3. Collect feedback:
   - Which option feels most natural?
   - Does click-to-roll icon interrupt conversation flow?
   - Is auto-roll too fast or just right?
4. Measure:
   - Time from roll request to result (physical vs digital)
   - User preference (qualitative)
   - Error rate (unparseable physical roll inputs)

**Success Criteria**:
- Clear user preference emerges (or validation of hybrid approach)
- Chosen option feels natural in conversation flow (qualitative feedback)
- Implementation complexity acceptable

**Effort**: 3-5 days (1 developer + user testing)

**Timing**: Week 2-3 (during Phase A - Core Loop)

**Status**: IMPORTANT - Affects every skill check in game

**Recommendation**: Hybrid approach (Option C) - serves all user preferences

---

### Spike 4: Combat Validation Walkthrough ⚠️ MEDIUM

**Risk Addressed**: TR-V02 (Combat complexity untested)

**Question**: How does combat/conflict work conversationally? What UX changes are needed?

**Approach**:
1. Create detailed combat scenario walkthrough (similar to Phase 4 validation):
   - 1 PC vs 2-3 NPCs
   - Multiple rounds of combat
   - Stress tracking, consequences, aspect invokes
   - Different approaches (Attack, Create Advantage, Defend)
   - Combat ends (NPCs taken out, PC concedes, or PC flees)
2. Identify requirements:
   - Turn order management (who acts when?)
   - NPC stress tracking visibility (always shown or on-demand?)
   - Combat Agent handoff (seamless or explicit?)
   - UI changes (turn indicator, initiative order, NPC status?)
3. Define user stories and acceptance criteria for combat features
4. Decide if combat is MVP or post-MVP based on complexity

**Success Criteria**:
- Combat flow is well-defined and documented
- User stories written for combat features (Epic 7)
- Decision made: MVP (stretch) or post-MVP
- If MVP: Combat Agent implementation estimated

**Effort**: 3-5 days (@business-analyst + @ux-designer)

**Timing**: Week 1 (Phase 5, parallel to PRD review)

**Status**: MEDIUM - Informs scope decision (P1 stretch vs post-MVP)

**Outcome**: If complexity is low, add to Phase D stretch. If high, defer to post-MVP.

---

### Spike 5: Graph RAG Exploration (NEW - Decision 013) ⚠️ LOW

**Risk Addressed**: World knowledge relationships may be difficult for standard RAG to capture

**Question**: Does Graph RAG improve context retrieval for interconnected world knowledge queries?

**Approach**:
1. Evaluate graph database options:
   - Neo4j (separate server - may be too heavy)
   - Graph layer on SQLite (e.g., sqlite-graph)
   - Implicit graph from markdown links (Obsidian-style [[NPC Name]])
2. Create test campaign with:
   - 10 NPCs with relationships (allies, enemies, family)
   - 5 factions with NPC memberships
   - 8 locations with NPC/faction associations
3. Test queries:
   - "Who does the merchant guild have conflicts with?" (faction relationships)
   - "Where have I encountered Captain Elena before?" (NPC + location history)
   - "Which NPCs are allied with the thieves' guild?" (faction membership)
4. Compare:
   - Standard vector RAG (retrieve top-k chunks)
   - Graph RAG (traverse relationships)
   - Hybrid approach (vector + graph traversal)
5. Measure:
   - Query accuracy (% correct answers)
   - Retrieval latency (< 500ms target)
   - Implementation complexity
   - Maintenance burden

**Success Criteria**:
- Graph RAG shows measurable improvement for relationship queries (>10% accuracy gain)
- Latency acceptable (< 500ms)
- Implementation complexity justified by benefit

**Effort**: 1 week (1 developer)

**Timing**: Week 10 (during Phase C) OR post-MVP (exploratory)

**Status**: LOW - Exploratory spike. May be post-MVP enhancement.

**Recommendation**: Start with standard vector RAG + markdown links. Add graph layer if clear need emerges in testing.

---

### Spike 6: Vector Store Evaluation (C# Options) - OPTIONAL

**Risk Addressed**: TR-07 (Vector store ecosystem less mature in C#)

**Question**: Which C# vector store option is best for MVP?

**Options to Evaluate**:
1. Semantic Kernel Memory Connectors + Azure AI Search (local)
2. Semantic Kernel Memory Connectors + Qdrant (embedded or server)
3. LiteDB with vector extensions (fully embedded)

**Approach**:
1. Implement simple campaign history storage and retrieval with each option
2. Measure:
   - Setup complexity (embedded vs server)
   - Query latency (< 500ms target)
   - Memory usage
   - Documentation quality
   - Community support
3. Test with 50-session synthetic campaign (from Spike 1)

**Success Criteria**:
- One option emerges as clear winner
- Meets latency target (< 500ms)
- Embedded option preferred (no server dependency)

**Effort**: 3-5 days (1 developer)

**Timing**: Week 8-9 (during Phase C - Session Lifecycle, before FB-063)

**Status**: OPTIONAL - Can defer to implementation if Semantic Kernel + Qdrant is default choice

**Recommendation**: Start with Semantic Kernel + Qdrant embedded mode, evaluate if issues arise

---

## 5. Out of Scope (Post-MVP)

### Phase 2 Features (Next Release)

**Goal**: Prove modularity and enhance user experience

**Features**:
- Combat/Conflict Agent (Epic 7) - if not in MVP stretch
- GM Personality Presets & Custom (Epic 8) - if not in MVP
- Conversation Search & Filter (FB-083) - simpler with markdown + indexes
- Character Creation Wizard (guided setup)
- Campaign Setup Wizard (genre, setting, tone)
- Tales of the Valiant Rules System (proves plugin architecture - Decision 014)

**Rationale**: These features enhance experience but aren't required to validate core concept. Adding Tales of the Valiant proves the rules plugin architecture works (Decision 014).

---

### Phase 3+ Features (Future Enhancements)

**Advanced Features**:
- NPC Relationship Visualization (graph view) - may benefit from Spike 5 (Graph RAG)
- Multiple Character Party Support (control 2-3 PCs)
- Rule Explanation System (advanced help)
- Advanced Analytics / Insights (session statistics, approach usage)

**Platform Enhancements**:
- Mobile Native Optimization (iOS, Android touch controls)
- Voice Input/Output (Concept 1b - text-to-speech, speech-to-text)
- Offline Mode with Local LLM (already supported via OpenAI-compatible API + Ollama)

**Community & Sharing**:
- Cloud Sync / Backup (optional Dropbox, Google Drive, self-hosted) - player can already manually sync campaign folder
- Campaign Export/Import (already done - zip/unzip campaign folder)
- Campaign Templates Library (starting scenarios as campaign folders)
- Community Sharing Platform (public campaign logs, discussion)

**Additional Rules Systems**:
- D&D 5e / Tales of the Valiant (PO's preferred) - as knowledge pack (Decision 011, 014)
- Blades in the Dark - as knowledge pack
- Powered by the Apocalypse systems - as knowledge pack
- Custom rules system support (user-defined markdown rules)

**Additional Oracle Systems**:
- Adventure Crafter - as knowledge pack (Decision 014)
- MUNE (Madey Upy Names Emulator) - as knowledge pack
- Custom oracle tables (user-defined markdown tables)

**Rationale**: These are nice-to-have enhancements that add value but aren't critical to validating the core value proposition.

---

### Explicitly Won't Do (Out of Scope)

**Multiplayer / Shared Campaigns**:
- Different product direction (this is explicitly solo RPG tool)
- Adds authentication, sync, concurrency complexity
- Future consideration: If user demand emerges, could be separate product/mode

**AI Fine-Tuning**:
- Expensive, inflexible, hard to update
- Generic LLMs work well with good prompting and tools

**Web-Only Version (No Local App)**:
- Loses local-first benefits (data ownership, LLM flexibility)
- Storage limits, no local LLM option

---

## 6. Success Metrics & Validation

### MVP Launch Metrics (Beta Testing)

**User Acquisition** (3-6 months post-launch):
- Target: 100+ active beta users
- Measure: Sign-ups, campaign creations

**Engagement** (Per User):
- Target: 5+ sessions per campaign (validate MVP success criterion)
- Target: 10+ users complete 5+ session campaigns
- Measure: Session count per campaign, active campaigns per user

**User Experience** (Qualitative):
- Target: 80%+ users report zero manual rule lookups
- Target: 80%+ users report genuine narrative surprises
- Target: 80%+ users feel like playing with a real GM
- Measure: Post-session surveys, user interviews

**Technical Performance**:
- Target: Session start time < 2 minutes (median < 90s)
- Target: AI response latency < 5 seconds (median < 3s)
- Target: Zero message loss (saves after every message)
- Target: Markdown file operations < 100ms
- Measure: Instrumented timing, error logs, user reports

**Campaign Continuity**:
- Target: 90%+ users successfully resume campaigns after 1+ week gap
- Target: Users report adequate context on session start
- Measure: User testing, post-session surveys

**Data Ownership & Portability**:
- Target: 90%+ users can find and read their campaign files
- Target: Campaign folder can be copied/moved/shared successfully
- Measure: User testing, feedback

---

### Validation Criteria (Go/No-Go Decision Points)

**Phase A Validation (Week 3)**:
- [ ] Core loop works: player acts → AI responds → state persists to markdown
- [ ] Dice rolling feels natural (Spike 3 completed)
- [ ] Fate Accelerated markdown rules + AI interpretation works (basic validation)
- [ ] Character.md updates correctly
- **Decision**: Proceed to Phase B or adjust architecture

**Phase B Validation (Week 6)**:
- [ ] Oracle generates surprises invisibly (validation testing)
- [ ] Fate rules apply consistently via AI interpretation (Spike 2 completed)
- [ ] NPCs/locations generated as markdown files correctly
- [ ] RAG retrieves relevant rules and world knowledge
- **Decision**: Proceed to Phase C or refine oracle/rules

**Phase C Validation (Week 10)**:
- [ ] Session lifecycle works: start → play → end → resume
- [ ] Long campaign memory works (Spike 1 completed)
- [ ] Context management stays within budget
- [ ] Vector search retrieves relevant session history
- [ ] Markdown file operations are fast and reliable
- **Decision**: Proceed to Phase D or fix critical gaps

**Beta Launch Validation (Week 14)**:
- [ ] 5-10 beta users complete 3+ session campaigns
- [ ] Performance targets met (session start < 2 min, response < 5s)
- [ ] No critical bugs or data loss
- [ ] User feedback is positive (qualitative)
- [ ] Users appreciate markdown-based data ownership
- **Decision**: Public beta or extend testing

---

### Post-MVP Success Criteria (6-12 months)

**Product-Market Fit Indicators**:
- 500+ active users
- 50%+ user retention after 1 month
- 80%+ users complete campaigns of 10+ sessions
- Net Promoter Score (NPS) > 50
- Word-of-mouth growth (organic referrals)

**Technical Validation**:
- Architecture supports multiple rules systems (Tales of the Valiant added as knowledge pack)
- Long campaigns (50+ sessions) work reliably
- No major performance issues reported
- Data integrity maintained (zero corruption reports)
- Modular plugin architecture validated (Decision 014)

**User Satisfaction**:
- 90%+ users report solving solo RPG pain points (creative fatigue, rules overhead, record-keeping)
- 80%+ users prefer this over other solo RPG tools (oracle apps, generic AI chat)
- High engagement: 10+ sessions per month on average
- Users value data ownership and markdown-based storage

---

## Summary

**MVP Scope**: Core conversational GM experience with Fate Accelerated rules, Mythic GME oracle, and robust session management. **10-14 weeks to beta-ready** (reduced from 12-16 weeks).

**Architectural Simplifications (Decisions 010-014)**:
1. **Hybrid storage** (markdown + SQLite indexes) - simpler, player-browsable, "already exported"
2. **Rules as AI knowledge** (not C# code) - no rules compiler, more flexible
3. **Save after every message** - no auto-save timer logic
4. **Modular architecture** - plugin-ready from day one
5. **Graph RAG spike** - exploratory enhancement for world knowledge

**Highest Priority**:
1. Core loop (Phase A) - Playable foundation (3 weeks)
2. Oracle & rules (Phase B) - Differentiating value (3 weeks)
3. Session lifecycle (Phase C) - Long-term usability (4 weeks)

**Critical Spikes**:
1. Long campaign context management (Spike 1) - CRITICAL
2. Rules consistency validation (Spike 2) - IMPORTANT (validates Decision 011)
3. Dice rolling UX decision (Spike 3) - IMPORTANT
4. Combat validation walkthrough (Spike 4) - Informs scope
5. Graph RAG exploration (Spike 5) - NEW - exploratory (Decision 013)

**Post-MVP**:
- Combat Agent (if not stretch)
- GM Personality & Polish
- Tales of the Valiant (validates modularity - Decision 014)
- Mobile optimization
- Voice input/output (Concept 1b)
- Graph RAG (if Spike 5 shows value)

**Success**: 10+ users complete 5+ session campaigns with zero manual rule lookups, genuine surprises, seamless session continuity, and appreciation for data ownership.

---

**Next Steps**:
1. Product Owner reviews and approves updated MVP scope
2. Conduct Spike 4 (Combat Walkthrough) to inform Phase D scope
3. Tech Lead reviews updated feature backlog for effort estimates
4. Decide on Graph RAG spike timing (Phase C or post-MVP)
5. Plan Phase A sprint (Weeks 1-3)
6. Begin development

---

**Document Status**: Updated with Decisions 010-014
**Created By**: @business-analyst
**Date**: 2025-12-10
**Phase**: Phase 6 - MVP Scoping
