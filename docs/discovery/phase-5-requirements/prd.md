# Product Requirements Document: Solo RPG Companion App

## Document Control
- **Version**: 1.0 (MVP)
- **Status**: Draft
- **Owner**: @business-analyst
- **Created**: 2025-12-10
- **Last Updated**: 2025-12-10
- **Phase**: Phase 5 - Requirements Definition

---

## 1. Executive Summary

### 1.1 Product Vision

The Solo RPG Companion App enables solo tabletop RPG players to experience immersive, GM-led gameplay through an AI-powered conversational interface. The app acts as a game master, oracle, rules arbiter, and record-keeper, allowing players to focus entirely on playing their character rather than managing the game.

### 1.2 Target User

**Primary Persona: Alex, the Narrative Explorer**
- Solo RPG enthusiast who plays 2-3 times per week
- Values immersion, surprise, and narrative depth
- Uses oracle systems (Mythic GME) for emergent storytelling
- Frustrated by creative generation fatigue and record-keeping overhead
- Wants to "just play" without juggling multiple roles

**Secondary Persona: Morgan, the Journaler**
- Plays solo RPG to create shareable stories
- Enjoys reviewing session notes and building campaign lore
- Needs persistent game state across irregular sessions
- Values readable export formats for sharing adventures

### 1.3 Key Value Proposition

**For solo RPG players** who want immersive gameplay without cognitive overhead, the Solo RPG Companion App is an AI-powered game master that handles narration, rules application, oracle functions, and state persistence, **unlike** generic AI chat tools or mechanical oracle apps, **our app** delivers a conversational GM experience with consistent rules enforcement and genuine narrative surprise through structured randomness.

### 1.4 Success Metrics

| Metric | Target | Measurement Approach |
|--------|--------|---------------------|
| **Session start time** | Under 2 minutes from app launch to in-game | Time tracking in app |
| **Session resumption success** | Player resumes campaign after 1+ week with full context | User testing, survey feedback |
| **Genuine surprise rate** | Players report discovering unexpected narrative elements in 80%+ of sessions | Post-session survey |
| **Rules lookup frequency** | Zero manual rule lookups during play | User testing observation |
| **Record-keeping time** | Zero manual note-taking (fully automated) | User testing observation |
| **MVP Validation** | 10+ users complete 5+ session campaigns successfully | Beta testing program |

---

## 2. Background & Problem Context

### 2.1 Problem Statement

Solo tabletop RPG players must simultaneously act as player, game master, oracle, and record-keeper. This cognitive juggling creates friction that pulls them out of the immersive player experience they're seeking.

**Specific Pain Points:**
1. **Creative generation fatigue**: Generating story hooks, worldbuilding details, NPC personalities, and plot twists while also trying to be surprised by the narrative
2. **Rules arbitration overhead**: Looking up and applying rules from the game system mid-session
3. **Record-keeping burden**: Tracking NPCs, locations, history, character state, and inventory across sessions
4. **Session continuity**: Remembering context and maintaining narrative coherence when resuming after days or weeks

**Evidence**: Product Owner domain expertise, validation walkthrough (Phase 4)

### 2.2 Current Solutions & Limitations

- **Paper + dice + random tables**: Manual, no persistence, easy to lose context
- **Note-taking apps (Obsidian)**: Good for records, but no rules/oracle integration. Some plugins exist for dice rolling and rules, but are not user-friendly or well-integrated.
- **Mythic GME mobile apps**: Oracle only, no rules system, limited record-keeping
- **Generic AI chat (ChatGPT, Claude)**: No game state persistence, no structured randomness, inconsistent rules
- **Virtual tabletops (Roll20, Foundry)**: Designed for groups, heavy setup, overkill for solo

### 2.3 Research & Validation Summary

- **Phase 1**: Problem statement validated with Product Owner domain expertise
- **Phase 2**: Technical feasibility confirmed - AI can handle GM + Oracle + Rules roles
- **Phase 3**: Conversational GM concept selected (Decision 005) over button-based alternatives
- **Phase 4**: 45-minute validation walkthrough demonstrated concept addresses all pain points
- **Confidence**: HIGH - Clear path to MVP with manageable risks

---

## 3. Goals & Objectives

### 3.1 Business Goals

1. **Validate core concept**: Prove conversational AI GM with oracle integration solves solo RPG pain points
2. **Establish technical foundation**: Build modular architecture that supports multiple rules systems (future)
3. **Build engaged community**: Create 100+ active beta users within 6 months of MVP launch
4. **Demonstrate differentiation**: Show clear value beyond generic AI chat tools

### 3.2 User Goals

1. **Focus on playing**: Eliminate cognitive overhead of juggling GM, oracle, and record-keeper roles
2. **Experience surprise**: Discover emergent narrative through invisible oracle integration
3. **Maintain continuity**: Resume campaigns weeks later with complete context automatically restored
4. **Apply rules consistently**: Trust that game mechanics are enforced correctly without manual lookup

### 3.3 MVP Success Criteria

MVP is considered successful when:
- [ ] 10+ users complete campaigns of 5+ sessions each
- [ ] Users report zero manual rule lookups during play
- [ ] Session start time averages under 2 minutes
- [ ] Users successfully resume campaigns after 1+ week gap
- [ ] 80%+ of users report genuine narrative surprises in sessions
- [ ] Technical architecture supports adding second rules system post-MVP

---

## 4. User Stories (Prioritized)

### 4.1 Must Have (MVP Core)

#### US-001: Session Start with Context
**As a** returning player
**I want to** launch my campaign and immediately understand where I left off
**So that** I can resume play without reviewing notes or remembering details

**Acceptance Criteria:**
- Given I have an existing campaign, when I launch the app and select the campaign, then I see an AI-generated recap of last session within 30 seconds
- Given the recap is displayed, when I type "yes" or "let's continue", then play begins immediately
- Given I'm confused about context, when I ask "what was I doing?", then the AI explains current situation in detail

**Priority**: MUST HAVE
**Estimate**: L

---

#### US-002: Conversational Action Input
**As a** player
**I want to** type what my character does in natural language
**So that** I can act without selecting from predetermined choices

**Acceptance Criteria:**
- Given I'm in an active session, when I type an action like "I try to convince the guard", then the AI interprets my intent and responds narratively
- Given my action is ambiguous, when the AI can't determine intent, then it asks clarifying questions naturally
- Given my action is impossible, when I attempt it, then the AI gently redirects with alternatives

**Priority**: MUST HAVE
**Estimate**: M

---

#### US-003: Invisible Oracle Integration
**As a** player
**I want** the AI to consult oracle systems without showing me the mechanics
**So that** I experience genuine surprise and discovery

**Acceptance Criteria:**
- Given I ask a yes/no question about the world, when the AI doesn't know the answer, then it consults Mythic GME invisibly and surfaces only the narrative result
- Given the oracle generates a random event, when it occurs, then I experience it as a narrative surprise without seeing "RANDOM EVENT ROLLED"
- Given I want transparency, when I enable "show oracle rolls" in settings, then oracle consultations are visible in the game log

**Priority**: MUST HAVE
**Estimate**: L

---

#### US-004: Automatic Rules Application
**As a** player
**I want** the AI to apply Fate Accelerated rules correctly
**So that** I never have to look up rules during play

**Acceptance Criteria:**
- Given I take an action requiring a roll, when the AI prompts me, then it explains which approach applies and what to roll (e.g., "Roll 4dF + your Clever (+3)")
- Given I report my dice result, when the AI calculates the outcome, then it correctly applies Fate rules (success levels, aspects, consequences)
- Given a tie result occurs, when calculating outcome, then the AI correctly applies "success at cost" rule
- Given I invoke an aspect, when spending a fate point, then the AI correctly applies +2 bonus and updates my fate point count

**Priority**: MUST HAVE
**Estimate**: XL

---

#### US-005: Dice Rolling Options
**As a** player
**I want** flexible dice rolling (physical or digital)
**So that** I can use my preferred method

**Acceptance Criteria:**
- Given the AI requests a roll, when I roll physical dice, then I can type the result (e.g., "+2" or "[-][+][+][0]") and the AI accepts it
- Given the AI requests a roll, when I see a dice icon next to the request, then I can click it to auto-roll digitally
- Given I prefer always auto-rolling, when I enable "auto-roll" in settings, then the AI rolls and reports results automatically

**Priority**: MUST HAVE
**Estimate**: M

**Note**: Exact UX for dice interaction needs detailed design (see Open Questions)

---

#### US-006: Character State Tracking
**As a** player
**I want** my character sheet to update automatically
**So that** I don't have to manually track stress, fate points, aspects, or inventory

**Acceptance Criteria:**
- Given I take damage, when stress is applied, then stress boxes are marked automatically and visible in character sheet panel
- Given I spend a fate point, when invoking an aspect, then fate point count decrements automatically
- Given I acquire an item, when the AI narrates receiving it, then it appears in my inventory automatically
- Given my character sheet changes, when updates occur, then I see a subtle visual indicator (brief pulse animation)

**Priority**: MUST HAVE
**Estimate**: L

---

#### US-007: NPC Generation & Persistence
**As a** player
**I want** NPCs to be generated naturally and remembered
**So that** the world feels consistent across sessions

**Acceptance Criteria:**
- Given I encounter a new NPC, when the AI introduces them, then the NPC has a name, personality, and motivation without me creating it
- Given an NPC becomes important (has aspects or relationships), when the NPC appears later, then they're remembered with consistent details
- Given I ask about an NPC, when I query "tell me about Kael", then the AI recalls who they are and our relationship

**Priority**: MUST HAVE
**Estimate**: L

---

#### US-008: Session End & Auto-Save
**As a** player
**I want** to end my session naturally and have everything saved
**So that** I can stop playing anytime without worrying about losing progress

**Acceptance Criteria:**
- Given I'm ready to stop, when I say "end session" or "I'll stop here", then the AI offers a summary of where we left off
- Given I close the app mid-session, when I reopen it, then I can resume from the last conversation turn
- Given a session ends, when auto-save triggers, then all game state is persisted: character sheet, NPCs, locations, threads, conversation log

**Priority**: MUST HAVE
**Estimate**: M

---

#### US-009: Scene Context Visibility
**As a** player
**I want** to see current scene information at a glance
**So that** I understand my situation without asking the AI

**Acceptance Criteria:**
- Given I'm in a location, when playing, then I see the current location name in the scene context panel
- Given NPCs are present, when in the scene, then I see their names listed in the scene context panel
- Given there are active plot threads, when playing, then I see them listed in the scene context panel

**Priority**: MUST HAVE
**Estimate**: S

---

#### US-010: Campaign Creation
**As a** player
**I want** to start a new campaign easily
**So that** I can begin playing multiple adventures

**Acceptance Criteria:**
- Given I want to start new campaign, when I click "New Campaign", then I'm prompted for: campaign name, rules system (Fate Accelerated for MVP), character name
- Given I provide basic info, when I start, then the AI begins with an opening prompt: "Tell me about your character and what brings them to this adventure"
- Given I describe my character, when I finish, then the AI populates character sheet and begins first scene

**Priority**: MUST HAVE
**Estimate**: M

---

### 4.2 Should Have (Important but not MVP-blocking)

#### US-011: Combat/Conflict Handling
**As a** player
**I want** combat encounters to be managed through conversation
**So that** tactical scenarios feel natural and rules are applied correctly

**Acceptance Criteria:**
- Given combat begins, when initiative is determined, then the AI clearly indicates turn order
- Given it's my turn, when the AI prompts me, then I can describe my action conversationally
- Given multiple NPCs are involved, when tracking their stress/conditions, then the AI maintains consistent state for each
- Given combat is complex, when a separate Combat Agent is activated (Decision 007), then transition is seamless and rules-specific

**Priority**: SHOULD HAVE
**Estimate**: XL

**Note**: Requires separate validation walkthrough (identified in Phase 4)

---

#### US-012: Rule Explanation System
**As a** player
**I want** to ask about rules anytime
**So that** I understand game mechanics when needed

**Acceptance Criteria:**
- Given I'm unsure about a rule, when I ask "how does stress work?", then the AI explains clearly in conversational tone
- Given a mechanic appears for the first time, when it's used, then the AI explains it before applying it
- Given I've used a mechanic before, when it appears again, then the AI applies it without re-explaining (unless I ask)

**Priority**: SHOULD HAVE
**Estimate**: M

---

#### US-013: GM Personality Selection
**As a** player
**I want** to choose GM personality style
**So that** the narration matches my preferences

**Acceptance Criteria:**
- Given I'm setting up a campaign, when choosing preferences, then I can select from GM personality presets: Dramatic Storyteller, Rules-Focused, Comedic, Dark & Gritty, Neutral
- Given I've selected a personality, when the AI narrates, then the tone and style match the selected personality
- Given I change my mind, when I update personality mid-campaign, then future narration reflects the change

**Priority**: SHOULD HAVE
**Estimate**: M

**Note**: Decision 008 - User-selectable vs adaptive

---

#### US-014: Conversation Search & Filter
**As a** player
**I want** to search past conversation
**So that** I can find specific events or details

**Acceptance Criteria:**
- Given I'm in a campaign, when I open the game log, then I see all past messages in chronological order
- Given I want to find something, when I search for a keyword (e.g., "warehouse"), then matching messages are highlighted
- Given I want to review mechanics, when I filter by "rolls only", then only messages with dice rolls are shown

**Priority**: SHOULD HAVE
**Estimate**: M

---

#### US-015: Narration Style Preference
**As a** player
**I want** to control AI response length
**So that** pacing matches my preference

**Acceptance Criteria:**
- Given I prefer quick play, when I select "Terse" style, then AI responses are 1-2 sentences max
- Given I prefer rich description, when I select "Rich" style, then AI responses include atmospheric detail (3-5 sentences)
- Given no preference set, when playing, then AI defaults to "Balanced" (2-3 sentences)

**Priority**: SHOULD HAVE
**Estimate**: S

---

### 4.3 Could Have (Nice to have, defer to post-MVP)

#### US-016: Character Creation Wizard
**As a** player
**I want** guided character creation
**So that** I don't need to know Fate Accelerated rules beforehand

**Priority**: COULD HAVE - Can create characters manually for MVP
**Estimate**: M

---

#### US-017: Session Export
**As a** player
**I want** to access session logs as markdown files
**So that** I can share my adventures or review them outside the app

**Acceptance Criteria:**
- Given I have completed sessions, when I navigate to the campaign folder, then I can see session logs stored as markdown files
- Given session logs exist as markdown files, when I open them in any text editor, then they are human-readable with proper formatting
- Given I want to share a session, when I copy the markdown file, then it contains the full session narrative

**Priority**: COULD HAVE - Session logs already stored as markdown (Decision 010)
**Estimate**: S

**Note**: Decision 010 - Session logs are already stored as markdown files on disk, making export "free"

---

#### US-018: NPC Relationship Visualization
**As a** player
**I want** to see a visual map of NPC relationships
**So that** I understand social dynamics at a glance

**Priority**: COULD HAVE - Nice visualization but not essential
**Estimate**: M

---

#### US-019: Campaign Setup Wizard
**As a** player
**I want** rich campaign setup (setting, initial situation)
**So that** campaigns start with clear context

**Priority**: COULD HAVE - Can handle conversationally for MVP
**Estimate**: M

---

#### US-020: Multiple Character Party Support
**As a** player
**I want** to control multiple PCs
**So that** I can play party-based adventures

**Priority**: COULD HAVE - Single character sufficient for MVP
**Estimate**: L

---

### 4.4 Won't Have (Explicitly out of scope for MVP)

#### US-021: Voice Input/Output (Concept 1b)
**Rationale**: Text-based chat proves concept first. Voice adds significant complexity. Validated as future enhancement in Phase 4.

#### US-022: Multiple Rules Systems
**Rationale**: MVP uses Fate Accelerated only to validate architecture. Additional systems (Tales of the Valiant, etc.) post-MVP. However, architecture is designed to be modular from day one to avoid refactoring when adding new systems (Decision 014).

#### US-023: Mobile Native Optimization
**Rationale**: Desktop-first for MVP. Electron supports mobile via Capacitor/Cordova, but optimize after desktop validation.

#### US-024: Multiplayer/Shared Campaigns
**Rationale**: Explicitly solo experience. Different product direction.

#### US-025: Offline Mode with Local LLM
**Rationale**: Cloud LLM (BYOK) acceptable for MVP. Local LLM option requires significant hardware and complicates distribution. Future consideration based on user demand.

#### US-026: Cloud Sync
**Rationale**: Local-first for MVP. Cloud sync adds complexity and infrastructure costs. Future optional enhancement.

---

## 5. Functional Requirements

### 5.1 Session Management

#### FR-001: Campaign Creation
- **Description**: User can create a new campaign with minimal setup
- **Priority**: MUST HAVE
- **Details**:
  - Input fields: Campaign name (required), rules system (Fate Accelerated - default for MVP), character name (required)
  - Creates campaign directory in local storage
  - Initializes SQLite database for campaign state
  - Begins AI conversation with opening prompt
- **Acceptance Criteria**:
  - Campaign created in under 60 seconds
  - User immediately in conversation with AI
  - Campaign appears in campaign list for future selection
- **Dependencies**: FR-020 (Data Persistence)

---

#### FR-002: Campaign Selection & Loading
- **Description**: User can view campaign list and select one to resume
- **Priority**: MUST HAVE
- **Details**:
  - Display list of existing campaigns with: name, last played date, session count
  - Load campaign state from SQLite database
  - Retrieve last N conversation messages for context
  - Generate AI recap of last session
- **Acceptance Criteria**:
  - Campaign loads within 2 seconds
  - AI recap appears within 30 seconds of selection
  - User can resume play immediately after recap
- **Dependencies**: FR-020 (Data Persistence), FR-003 (Session Start)

---

#### FR-003: Session Start with AI Recap
- **Description**: AI generates contextual recap when campaign is loaded
- **Priority**: MUST HAVE
- **Details**:
  - Retrieve: last session summary, current scene, active NPCs, open plot threads
  - AI generates 2-3 sentence recap conversationally
  - Prompt user: "Ready to continue?" or similar natural prompt
  - User can ask clarifying questions before resuming
- **Acceptance Criteria**:
  - Recap generated within 30 seconds
  - Recap includes: last scene location, last action taken, immediate stakes
  - User reports adequate context to resume (validation testing)
- **Dependencies**: FR-002 (Campaign Loading), FR-010 (AI Conversation Engine)

---

#### FR-004: Session End & Auto-Save
- **Description**: User can end session naturally; current chat session saves after every message
- **Priority**: MUST HAVE
- **Details**:
  - Chat session saves after every message (Decision 012) - no separate auto-save timer needed
  - Trigger for session end: User says "end session", "stop here", or closes app
  - If explicit end: AI offers summary of where session ended and commits session log
  - Session log committed at end includes: narrative summary, state changes, chaos factor updates
  - Save includes: character state, NPCs, locations, threads, full conversation log
- **Acceptance Criteria**:
  - Each message save completes immediately (append-only, fast)
  - User can close app anytime without data loss
  - Resuming after crash restores last message (no data loss)
- **Dependencies**: FR-020 (Data Persistence), FR-021 (Session State Model - Decision 009)
- **Notes**: Decision 012 - Eliminates auto-save timer complexity, simpler crash recovery

---

#### FR-005: Mid-Session Recovery
- **Description**: If app crashes mid-session, user can recover conversation state
- **Priority**: SHOULD HAVE
- **Details**:
  - Current chat session saves after every message (Decision 012)
  - On app reopen after crash: detect incomplete session
  - Prompt user: "You have an incomplete session. Resume from last message?"
  - Load last message if user confirms
  - No data loss - last message is always saved
- **Acceptance Criteria**:
  - Zero conversation turns lost in crash scenario (every message saved)
  - User can decline recovery and revert to last completed session log
- **Dependencies**: FR-004 (Auto-Save)
- **Notes**: Decision 012 - Save after every message makes recovery trivial

---

### 5.2 Conversation & Interaction

#### FR-010: AI Conversation Engine
- **Description**: Core conversational GM powered by LLM with tool access
- **Priority**: MUST HAVE
- **Details**:
  - LLM: OpenAI-compatible API (Claude, OpenAI, Azure OpenAI, Ollama)
  - User configures: API endpoint, API key, model name
  - Agent framework: Vercel AI SDK (TypeScript)
  - Context includes: character sheet, scene state, recent history, rules system
  - AI has access to tools: roll_dice, check_rule, get_npc, update_state, invoke_oracle
- **Acceptance Criteria**:
  - AI responds within 2-5 seconds for typical interaction
  - Conversation feels natural (validation testing)
  - AI correctly interprets user intent 90%+ of time
- **Dependencies**: FR-030 (Rules System Integration), FR-040 (Oracle Integration), FR-020 (Data Persistence)
- **Technical Notes**:
  - Use Vercel AI SDK for LLM abstraction and tool registration
  - Implement retry with exponential backoff for API failures
  - Log all LLM interactions for debugging (exclude API keys)

---

#### FR-011: Natural Language Action Input
- **Description**: User types actions in natural language; AI interprets intent
- **Priority**: MUST HAVE
- **Details**:
  - Accept free-form text input in chat interface
  - AI analyzes intent: action declaration, question, meta-query, or in-character speech
  - Patterns:
    - "I try to..." / "I want to..." = action declaration
    - "I say '...'" = in-character speech
    - "Show me..." / "What's my..." = meta-query
    - "How does..." / "Explain..." = rules question
  - If ambiguous: AI asks clarifying question naturally
- **Acceptance Criteria**:
  - User never forced to select from predetermined options
  - Ambiguous input triggers clarifying question within 1 conversational turn
  - AI correctly categorizes intent 95%+ of time (validation testing)
- **Dependencies**: FR-010 (Conversation Engine)

---

#### FR-012: AI Response Patterns
- **Description**: AI uses distinct conversational patterns for different communication types
- **Priority**: MUST HAVE
- **Details**:
  - **Pattern A - Narration**: Descriptive scene-setting, no immediate prompt
  - **Pattern B - Prompt for Action**: Ends with question, NPC waiting for response
  - **Pattern C - Mechanical Prompt**: Explains approaches, dice roll needed
  - **Pattern D - Rule Explanation**: Teaching moment, then returns to action
  - AI adapts response length based on user's "Narration Style" setting
- **Acceptance Criteria**:
  - User can distinguish between narration and prompts (validation testing)
  - Mechanics explained clearly when needed (validation testing)
  - No robotic "ROLL FOR CLEVER [BUTTON]" style prompts
- **Dependencies**: FR-010 (Conversation Engine), FR-015 (Narration Style Setting)
- **Technical Notes**:
  - Define response templates in AI system prompt
  - Use markdown formatting for emphasis: *italic* for atmosphere, **bold** for mechanics

---

#### FR-013: Markdown Rendering in Chat
- **Description**: AI responses rendered with markdown for rich formatting
- **Priority**: MUST HAVE
- **Details**:
  - Support: bold, italic, lists, headings, code blocks (for dice notation)
  - Render in chat interface with appropriate styling
  - Maintain readability on desktop and mobile
- **Acceptance Criteria**:
  - Formatting enhances readability (validation testing)
  - No rendering errors for common markdown patterns
- **Dependencies**: None
- **Technical Notes**: Use react-markdown, marked, or similar JS library

---

#### FR-014: Conversation History Display
- **Description**: User can scroll through past conversation messages
- **Priority**: MUST HAVE
- **Details**:
  - Display last 50 messages in active view
  - Older messages accessible via scroll (infinite scroll pattern)
  - Visual distinction: GM messages vs player messages vs system messages
  - Timestamps on messages (optional display)
- **Acceptance Criteria**:
  - Smooth scrolling performance (60fps)
  - Clear visual hierarchy distinguishes message types
- **Dependencies**: FR-010 (Conversation Engine)

---

#### FR-015: Narration Style Setting
- **Description**: User can control AI response length and detail level
- **Priority**: SHOULD HAVE
- **Details**:
  - Options: Terse (1-2 sentences), Balanced (2-3 sentences), Rich (3-5 sentences)
  - Default: Balanced
  - Affects only narrative responses, not mechanical explanations
  - Applied via system prompt modifier
- **Acceptance Criteria**:
  - Terse style: avg 1-2 sentences per narrative response
  - Rich style: avg 3-5 sentences with atmospheric detail
  - Style change takes effect immediately (next AI response)
- **Dependencies**: FR-010 (Conversation Engine)

---

### 5.3 Dice Rolling

#### FR-016: Dice Roll Request & Explanation
- **Description**: AI requests dice rolls naturally and explains why they're needed
- **Priority**: MUST HAVE
- **Details**:
  - When action requires roll: AI explains approach, bonus, and dice notation
  - Example: "That sounds like a Clever approach. Roll 4dF and add your Clever (+3). Difficulty is Fair (+2)."
  - Display dice icon inline next to roll request (for click-to-roll option)
  - AI waits for player to provide result before continuing
- **Acceptance Criteria**:
  - Roll requests are conversational, not robotic
  - Dice notation is clearly specified (e.g., "4dF", "D20+5")
  - Player understands why roll is needed (validation testing)
- **Dependencies**: FR-030 (Rules System), FR-010 (Conversation Engine)

---

#### FR-017: Physical Dice Result Input
- **Description**: Player can roll physical dice and type the result
- **Priority**: MUST HAVE
- **Details**:
  - Player types result as:
    - Simple number: "+2", "-1", "7"
    - Dice notation: "[-][+][+][0]", "[3][5][2]"
    - Natural language: "I got +2"
  - AI parses result and applies to calculation
  - If unparseable: AI asks for clarification
- **Acceptance Criteria**:
  - All common result formats are correctly parsed
  - Unparseable input triggers friendly clarification request
- **Dependencies**: FR-016 (Dice Roll Request)

---

#### FR-018: Click-to-Roll Digital Dice (Optional)
- **Description**: Player can click dice icon to auto-roll instead of physical rolling
- **Priority**: MUST HAVE
- **Details**:
  - Small dice icon appears next to roll request in AI message
  - Click icon: system rolls dice, displays result in chat naturally
  - Example display: "You rolled [+][-][0][+] = +1. With your Clever (+3), that's +4 total."
  - Supports dice types: dF (Fudge/Fate), d4, d6, d8, d10, d12, d20, d100
- **Acceptance Criteria**:
  - Click-to-roll completes within 500ms
  - Result displayed naturally in conversation flow
  - Correct dice notation implemented for all types
- **Dependencies**: FR-016 (Dice Roll Request)
- **Technical Notes**: Implement cryptographically secure random number generator for fairness

---

#### FR-019: Auto-Roll Setting (Always Digital)
- **Description**: User can enable always-auto-roll to skip manual rolling entirely
- **Priority**: SHOULD HAVE
- **Details**:
  - Setting: "Always auto-roll dice" (default: OFF)
  - When enabled: AI automatically rolls and reports results without player interaction
  - Example: "I'm rolling 4dF+3 for you... You got [+][0][+][-] = +1, so +4 total."
- **Acceptance Criteria**:
  - Setting persists across sessions
  - Auto-roll feels natural in conversation flow (validation testing)
- **Dependencies**: FR-018 (Click-to-Roll)

---

### 5.4 Rules System Integration (Fate Accelerated - MVP)

#### FR-030: Fate Accelerated Mechanics Implementation
- **Description**: Core Fate Accelerated rules encoded as AI agent knowledge with markdown/JSON representations (Decision 011)
- **Priority**: MUST HAVE
- **Details**:
  - **Rules as Knowledge**: Fate Accelerated rules stored as markdown documents, not compiled code
  - **Character State**: Character sheet stored as JSON or markdown (not database entities)
  - **AI Interpretation**: AI agent "knows" the rules via system prompt + RAG retrieval
  - **TypeScript Code Limited To**: Dice rolling utilities, file I/O, UI components, LLM orchestration
  - **Approaches**: Careful, Clever, Flashy, Forceful, Quick, Sneaky (ratings -1 to +3)
  - **Actions**: Overcome, Create Advantage, Attack, Defend
  - **Roll Resolution**: 4dF (Fudge dice: -1, 0, +1) + Approach bonus vs Difficulty
  - **Success Levels**:
    - Beat by 3+: Success with Style (+ boost or extra benefit)
    - Beat by 1-2: Success
    - Tie (equal): Success at Cost
    - Miss by 1-2: Failure
    - Miss by 3+: Failure with Complication
  - **Aspects**: Character aspects, situation aspects, consequences
  - **Invokes**: Spend 1 fate point for +2 or reroll (free invokes on newly created aspects)
  - **Stress**: 1-4 boxes (marks absorb damage)
  - **Consequences**: Mild (2 shifts), Moderate (4 shifts), Severe (6 shifts)
- **Acceptance Criteria**:
  - Rules stored as human-readable markdown documents
  - Character state stored as JSON/markdown (player can read/edit)
  - AI applies rules consistently across sessions (validation testing)
  - Edge cases handled: tie results, stress overflow, consequence selection
- **Dependencies**: FR-031 (Rules RAG)
- **Technical Notes** (Decision 011):
  - More flexible - AI can interpret edge cases and apply natural language rules
  - Easier to add new rules systems - just markdown + schema, no recompilation
  - Player can read/understand their character data
  - Trade-off: Less deterministic than compiled code, relies on AI consistency
  - TypeScript dice rolling validates math (4dF+3 = correct total)

---

#### FR-031: Rules RAG (Natural Language Lookup)
- **Description**: Fate Accelerated rules text stored for AI reasoning and lookup
- **Priority**: MUST HAVE
- **Details**:
  - Store Fate Accelerated rules as markdown documents
  - Chunk documents for RAG retrieval
  - Embed chunks using text embedding model
  - AI tool: check_rule(query) retrieves relevant rule sections
  - AI uses retrieved context to reason about edge cases or explain rules to player
- **Acceptance Criteria**:
  - Relevant rules retrieved for 90%+ of queries (validation testing)
  - Retrieval latency under 500ms
  - AI can explain rules conversationally using retrieved context
- **Dependencies**: FR-030 (Mechanics Implementation)
- **Technical Notes**:
  - Use LangChain.js or custom chunking for document processing
  - Store embeddings in vector store (LanceDB or Qdrant embedded)

---

#### FR-032: Action Intent Mapping
- **Description**: AI maps player's natural language action to Fate mechanics
- **Priority**: MUST HAVE
- **Details**:
  - AI analyzes player input to determine:
    - Action type: Overcome, Create Advantage, Attack, Defend
    - Approach: Which of 6 approaches applies (or asks player to clarify)
    - Difficulty: Based on situation (Poor +0, Fair +2, Good +3, Great +4, etc.)
  - If ambiguous: AI asks "Are you trying to charm them (Flashy) or reason with them (Clever)?"
  - AI explains mapping: "That sounds like a Clever approach to Overcome their suspicion."
- **Acceptance Criteria**:
  - Correct action type identified 90%+ of time
  - Approach correctly inferred or clarified 95%+ of time
  - Difficulty assessment feels fair (validation testing)
- **Dependencies**: FR-030 (Mechanics), FR-011 (Natural Language Input)

---

#### FR-033: Aspect Invoke Prompting
- **Description**: AI suggests aspect invokes at appropriate moments
- **Priority**: MUST HAVE
- **Details**:
  - When player attempts risky action: AI scans relevant aspects (character, scene, NPC)
  - If aspect would help: AI suggests invoke conversationally
  - Example: "You could invoke your 'Clever Merchant-Spy' aspect for training in staying calm under pressure. That would cost a fate point but give you +2."
  - Player decides whether to spend fate point
  - If player invokes: aspect bonus applied, fate point decremented automatically
- **Acceptance Criteria**:
  - AI suggests relevant aspect invokes 80%+ of appropriate moments
  - Suggestions feel natural, not forced (validation testing)
  - Fate point tracking is accurate (unit tests)
- **Dependencies**: FR-030 (Mechanics), FR-050 (Character State Tracking)

---

#### FR-034: Consequence Selection Flow
- **Description**: When stress boxes full, player selects consequence
- **Priority**: MUST HAVE
- **Details**:
  - AI detects stress overflow: "Your stress boxes are full. You need to take a consequence to absorb the remaining 3 shifts."
  - AI suggests consequence types available: Mild (2), Moderate (4), Severe (6)
  - AI offers examples: "Maybe 'Twisted Ankle' or 'Bleeding Wound'?"
  - Player describes consequence in natural language
  - AI records consequence on character sheet with mechanical effect
- **Acceptance Criteria**:
  - Consequence requirement detected correctly (unit tests)
  - AI explains consequence options clearly
  - Player-created consequences are recorded accurately
- **Dependencies**: FR-030 (Mechanics), FR-050 (Character State Tracking)

---

#### FR-035: First-Time Mechanic Explanation
- **Description**: AI explains game mechanics when they appear for first time in campaign
- **Priority**: SHOULD HAVE
- **Details**:
  - Track which mechanics player has encountered (per campaign)
  - First-time mechanics: AI provides brief explanation before applying
  - Example: "Since this is the first time you're creating an advantage, let me explain: when you succeed, you create a temporary aspect you can invoke later for free."
  - Subsequent uses: AI applies silently (unless player asks for explanation)
- **Acceptance Criteria**:
  - Mechanics encountered is tracked per campaign
  - First-time explanations are clear and concise (validation testing)
  - No redundant explanations on subsequent uses
- **Dependencies**: FR-030 (Mechanics), FR-020 (Data Persistence)

---

### 5.5 Oracle Integration (Mythic GME - MVP)

#### FR-040: Mythic GME Yes/No Oracle
- **Description**: AI consults Mythic GME oracle for yes/no questions invisibly
- **Priority**: MUST HAVE
- **Details**:
  - When AI needs to determine unknown fact: invoke oracle invisibly
  - Mythic GME mechanics:
    - Assign likelihood: Impossible, No Way, Very Unlikely, Unlikely, 50/50, Somewhat Likely, Likely, Very Likely, Near Sure Thing, Has To Be, Already Is
    - Cross-reference with Chaos Factor (1-9, starts at 5)
    - Roll d100, compare to Fate Chart
    - Result: Exceptional No, No, Yes, Exceptional Yes
  - Oracle result surfaces only as narrative
  - Example: Player asks "Is there a good inn nearby?" → Oracle: Yes → AI: "The guard grunts, 'Golden Lamb, two streets over.'"
- **Acceptance Criteria**:
  - Oracle consulted when AI lacks information (validation testing)
  - Player experiences only narrative result, not mechanics
  - Oracle adds genuine surprise (validation testing)
- **Dependencies**: FR-010 (Conversation Engine)
- **Technical Notes**:
  - Implement as AI tool: invoke_oracle(question, likelihood)
  - AI determines likelihood based on context
  - Log oracle rolls to separate game log (optional display)

---

#### FR-041: Chaos Factor Tracking
- **Description**: Mythic GME Chaos Factor adjusts oracle probabilities dynamically
- **Priority**: MUST HAVE
- **Details**:
  - Chaos Factor starts at 5 (moderate chaos)
  - Adjusted at end of each scene/session:
    - Scene ended in player control: -1 chaos
    - Scene ended in chaos/disorder: +1 chaos
    - Min: 1 (complete control), Max: 9 (utter chaos)
  - Chaos Factor affects oracle probabilities (higher chaos = more unpredictable)
- **Acceptance Criteria**:
  - Chaos Factor persisted per campaign
  - Adjustments logged in game log (optional display)
  - Higher chaos produces more unexpected results (validation testing)
- **Dependencies**: FR-040 (Oracle), FR-021 (Session State Model)

---

#### FR-042: Random Event Checks
- **Description**: Mythic GME random event generation for narrative surprises
- **Priority**: MUST HAVE
- **Details**:
  - At scene transitions: roll d10 for random event check
  - If result ≤ Chaos Factor: random event occurs
  - Generate event using Mythic GME event tables or AI interpretation
  - Event surfaces naturally in narrative
  - Example: Player investigating warehouse → Random event: "As you approach, you hear shouting inside - something unexpected is happening."
- **Acceptance Criteria**:
  - Random events occur at frequency matching Chaos Factor
  - Events feel surprising but contextually appropriate (validation testing)
- **Dependencies**: FR-040 (Oracle), FR-041 (Chaos Factor)

---

#### FR-043: NPC/Thread/Location Lists
- **Description**: Mythic GME tracks lists of NPCs, threads, and locations for oracle queries
- **Priority**: MUST HAVE
- **Details**:
  - Maintain lists per campaign:
    - **NPCs**: Characters introduced, with status (active, resolved, unknown)
    - **Threads**: Open plot threads (questions, goals, mysteries)
    - **Locations**: Places visited or known
  - Lists updated at session end (Decision 009: Session State Model)
  - Oracle can reference lists when generating events
- **Acceptance Criteria**:
  - Lists updated accurately during play
  - Lists queryable by AI for context
  - Lists visible in game log or separate panel (optional)
- **Dependencies**: FR-040 (Oracle), FR-021 (Session State Model)

---

#### FR-044: Oracle Transparency Setting
- **Description**: User can optionally see oracle rolls in game log
- **Priority**: SHOULD HAVE
- **Details**:
  - Setting: "Show oracle rolls" (default: OFF)
  - When enabled: Oracle consultations visible in game log with details
  - Example log entry: "Oracle: 'Is warehouse guarded?' - Likelihood: Likely - Chaos 5 - Roll: 42 - Result: Yes"
  - Does not display in main conversation (only game log)
- **Acceptance Criteria**:
  - Setting persists across sessions
  - Oracle log entries are clear and informative
- **Dependencies**: FR-040 (Oracle), FR-060 (Game Log)

---

### 5.6 State Persistence & Memory

#### FR-020: Hybrid Storage Architecture (File System + Database)
- **Description**: Player-visible content stored as files (like Obsidian vault), app-internal data in SQLite/vector store (Decision 010)
- **Priority**: MUST HAVE
- **Details**:
  - **Campaign Folder Structure** (file system - player-browsable):
    ```
    Campaign Folder/
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
    ```
  - **App Data** (SQLite + vector store - internal):
    - campaign.db: Search indexes, relationships, metadata
    - conversation-log.db: Current chat session (ephemeral)
    - embeddings/: Vector store for semantic search
  - **Rationale** (Decision 010):
    - Player can browse/edit world content like Obsidian vault
    - Player owns data in human-readable format
    - Export is "already done" - files are source of truth
    - SQLite provides fast search/indexing without duplicating content
- **Acceptance Criteria**:
  - Markdown files are canonical source for world state
  - SQLite indexes/caches markdown content for fast lookup
  - Campaign folder is portable (copy to new machine works)
  - Player can edit markdown files externally, app detects changes
- **Dependencies**: None
- **Technical Notes**:
  - App reads from files on startup, watches for external changes
  - Session logs written directly to disk after each session (Decision 012: after every message)
  - "World wiki" feel - player can organize however they want

---

#### FR-021: Session State Model (Two-Tier)
- **Description**: Chat Session (in-progress) → Session Log (summary at end), stored as markdown files (Decision 010)
- **Priority**: MUST HAVE
- **Details**:
  - **Chat Session (active)**:
    - Full conversation transcript saved to conversation-log.db after each message (Decision 012)
    - Working state (uncommitted changes to NPCs, locations, threads)
    - Real-time interaction
  - **Session End Flow**:
    - AI generates narrative summary (2-3 paragraphs)
    - AI extracts state changes: new NPCs, locations, inventory changes
    - AI updates Mythic GME state: chaos factor, thread list, NPC list
    - AI updates world markdown files: new NPC files, location files, etc.
    - AI presents changes for player review/edit
    - Player confirms or modifies
    - Committed to Session Log as markdown file: sessions/session-NNN.md
  - **Session Log (persisted as markdown)**:
    - Summarized narrative (not full transcript)
    - Confirmed state changes
    - Mythic GME updates
    - Stored as markdown file on disk (player-readable)
    - Canonical record for future session start
- **Acceptance Criteria**:
  - Session summary is clear and comprehensive (validation testing)
  - State changes accurately extracted (unit tests)
  - Player can review and edit before committing
  - Session log written as markdown file (sessions/session-NNN.md)
  - World state files updated (NPCs, locations, factions as markdown)
  - Committed session log used for future recaps
- **Dependencies**: FR-004 (Session End), FR-020 (Hybrid Storage), FR-041 (Chaos Factor), FR-043 (NPC/Thread Lists)
- **Technical Notes**: Decision 009 rationale - follows Mythic GME pattern, avoids state churn, reduces AI hallucination risk. Decision 010 - session logs stored as markdown files.

---

#### FR-022: Conversation Log Persistence
- **Description**: Current conversation messages persisted in database for active session
- **Priority**: MUST HAVE
- **Details**:
  - Store current chat session in conversation-log.db (SQLite)
  - Saves after every message (Decision 012)
  - Includes: message text, role (GM/player/system), timestamp
  - Used for: crash recovery, AI context, session continuity
  - At session end: conversation archived, summary written to markdown
  - Older full transcripts not retained (only summaries in session-NNN.md files)
- **Acceptance Criteria**:
  - Conversation log saves after each message (immediate)
  - Conversation log loads within 1 second on campaign resume
  - Sufficient context for AI to resume naturally after crash
  - Full transcript cleared after session end (summary saved to markdown)
- **Dependencies**: FR-020 (Hybrid Storage), FR-021 (Session State Model)
- **Technical Notes**: Decision 010 - Current conversation in database (ephemeral), session summaries in markdown files (permanent)

---

#### FR-023: Vector Store for Semantic Search
- **Description**: Campaign history embedded for semantic search across markdown files
- **Priority**: MUST HAVE
- **Details**:
  - Embed session summaries (markdown files) and world wiki content (NPCs, locations, factions)
  - Vector store: LanceDB or Qdrant (embedded)
  - Metadata: session number, NPCs involved, locations, tags, date
  - AI can query: "What happened with the merchant guild?" → retrieve relevant history
  - Used for: long campaign context management, player queries, AI recall
  - Semantic search across all markdown files in campaign folder
- **Acceptance Criteria**:
  - Relevant history retrieved for queries (validation testing)
  - Retrieval latency under 500ms
  - Works for campaigns of 50+ sessions (technical spike)
  - Searches across session logs AND world wiki markdown files
- **Dependencies**: FR-020 (Hybrid Storage), FR-021 (Session Summaries)
- **Technical Notes** (Decision 010):
  - Use LangChain.js or Vercel AI SDK for embeddings
  - Embed markdown file contents at session end
  - Retrieval: top 3-5 chunks added to AI context
  - Vector store enables semantic search across file system content
  - **Technical Spike** (Decision 013): Explore Graph RAG for relationship queries ("Who does merchant guild have conflicts with?")

---

#### FR-024: Character State Auto-Update
- **Description**: Character sheet updates automatically based on gameplay, stored as markdown file
- **Priority**: MUST HAVE
- **Details**:
  - Character sheet stored as character.md (Decision 010, 011)
  - Triggers: damage taken, aspect invoked, consequence added, inventory change, fate point spend/gain
  - Updates reflected in character sheet panel immediately (UI)
  - Changes written to character.md file
  - Visual feedback: brief pulse animation on changed field
  - Player can view/edit character.md directly if desired
- **Acceptance Criteria**:
  - Updates are immediate in UI (within 100ms of triggering event)
  - character.md file updated after each change
  - Visual feedback is noticeable but not distracting
  - No manual updates required
  - Character sheet is human-readable markdown/JSON
- **Dependencies**: FR-050 (Character Sheet Display), FR-020 (Hybrid Storage)
- **Technical Notes** (Decision 010, 011): Character sheet as markdown enables player ownership and portability

---

#### FR-025: Export to JSON
- **Description**: Campaign data exportable as portable JSON file
- **Priority**: COULD HAVE
- **Details**:
  - Export includes: campaign metadata, character sheets, NPCs, locations, threads, session summaries
  - JSON format for portability and backup
  - Can import JSON to restore campaign (future feature)
- **Acceptance Criteria**:
  - Export completes within 5 seconds for typical campaign
  - JSON is human-readable and well-structured
- **Dependencies**: FR-020 (SQLite)

---

### 5.7 User Interface

#### FR-050: Character Sheet Panel
- **Description**: Always-visible character sheet showing current state
- **Priority**: MUST HAVE
- **Details**:
  - Display (Fate Accelerated):
    - Character name
    - Approaches: Careful, Clever, Flashy, Forceful, Quick, Sneaky (with ratings)
    - Aspects: High Concept, Trouble, 3 other aspects
    - Stress boxes: 1-4 (marked/unmarked)
    - Consequences: Mild, Moderate, Severe (with descriptions if taken)
    - Fate Points: current count
    - Inventory: list of items
  - Updates: Auto-update with pulse animation on change
  - Position: Left panel on desktop, collapsible panel on mobile
- **Acceptance Criteria**:
  - Character sheet always visible during play (desktop)
  - Updates are immediate and visually indicated
  - Readable at a glance
- **Dependencies**: FR-024 (Auto-Update)

---

#### FR-051: Scene Context Panel
- **Description**: Current scene information visible at a glance
- **Priority**: MUST HAVE
- **Details**:
  - Display:
    - Current location name
    - NPCs present (names)
    - Active plot threads (brief descriptions)
    - Current session number
  - Updates: Auto-update as scene changes
  - Position: Header area or right panel on desktop, collapsible on mobile
- **Acceptance Criteria**:
  - Scene context visible without scrolling
  - Updates reflect current situation accurately
- **Dependencies**: FR-020 (Data Persistence)

---

#### FR-052: Chat Interface
- **Description**: Primary conversation interface for player and AI interaction
- **Priority**: MUST HAVE
- **Details**:
  - Layout: Message bubbles (GM left/blue, Player right/green, System center/gray)
  - Input: Text field at bottom, Send button (Enter key submits)
  - Scrolling: Auto-scroll to latest message, user can scroll up for history
  - Markdown rendering: Bold, italic, lists, headings
  - Inline elements: Dice icons for click-to-roll
- **Acceptance Criteria**:
  - Clean, uncluttered interface
  - Messages easily distinguishable by type
  - Input field always accessible
  - Performance: 60fps scrolling, no lag on typing
- **Dependencies**: FR-010 (Conversation Engine), FR-013 (Markdown Rendering)
- **Technical Notes**:
  - Use React, Vue, or Svelte for component-based UI in Electron renderer

---

#### FR-053: Campaign List Screen
- **Description**: Landing screen showing all campaigns
- **Priority**: MUST HAVE
- **Details**:
  - Display list of campaigns with:
    - Campaign name
    - Last played date
    - Session count
    - Rules system icon/name
  - Actions: Select to resume, Delete campaign (with confirmation), New Campaign button
  - Sort: By last played (most recent first)
- **Acceptance Criteria**:
  - Campaigns load within 1 second
  - Clear call-to-action for new users: "Create Your First Campaign"
- **Dependencies**: FR-001 (Campaign Creation), FR-002 (Campaign Loading)

---

#### FR-054: Settings Screen
- **Description**: User preferences and configuration
- **Priority**: MUST HAVE
- **Details**:
  - Sections:
    - **LLM Configuration**: API endpoint, API key (secure storage), Model name
    - **Gameplay**: Narration style (Terse/Balanced/Rich), Auto-roll dice (on/off), Show oracle rolls (on/off)
    - **GM Personality**: Preset selection (Dramatic, Rules-Focused, Comedic, Dark & Gritty, Neutral)
    - **About**: App version, license, credits
  - API key: Stored in OS secure keychain (not plaintext)
- **Acceptance Criteria**:
  - Settings persist across sessions
  - API key storage is secure (not visible, not logged)
  - Changes take effect immediately or on next session start (as appropriate)
- **Dependencies**: None
- **Technical Notes**:
  - Use electron-store with encryption or keytar for OS keychain API key storage
  - Default API endpoint: OpenAI-compatible (user configurable)

---

#### FR-055: Game Log Panel
- **Description**: Searchable, filterable log of all game events
- **Priority**: SHOULD HAVE
- **Details**:
  - Display: All messages, rolls, state changes, oracle consultations (if enabled)
  - Search: Keyword search with highlighting
  - Filter: All messages, Rolls only, Oracle only, NPCs, Locations
  - Export: Copy to clipboard or save as markdown
- **Acceptance Criteria**:
  - Search returns results within 500ms
  - Filters work correctly
  - Log is human-readable
- **Dependencies**: FR-010 (Conversation Engine), FR-044 (Oracle Transparency)

---

### 5.8 Combat & Conflict (Separate Agent - Decision 007)

#### FR-070: Combat Encounter Detection
- **Description**: AI detects when combat/conflict begins and transitions to Combat Agent
- **Priority**: SHOULD HAVE
- **Details**:
  - GM agent detects combat initiation: multiple hostile NPCs, initiative needed
  - Seamless handoff to Combat Agent (Fate Accelerated-specific)
  - Combat Agent has access to: character state, NPC stats, battlefield context
  - Different pacing: turn-by-turn structure
- **Acceptance Criteria**:
  - Transition to combat is seamless (validation testing)
  - Combat Agent applies Fate conflict rules correctly
  - Return to GM agent after combat resolves
- **Dependencies**: FR-030 (Fate Mechanics), FR-010 (Conversation Engine)
- **Technical Notes**:
  - Decision 007 rationale: Combat rules vary wildly between systems, specialized agent allows swappable rules
  - Combat Agent is separate AI agent with specialized system prompt and tools
  - Requires separate validation walkthrough (identified in Phase 4)

---

#### FR-071: Initiative & Turn Order
- **Description**: Combat Agent manages turn order for conflicts
- **Priority**: SHOULD HAVE
- **Details**:
  - Fate Accelerated: No strict initiative, but track who acts when
  - Display turn order clearly in combat
  - Prompt player when it's their turn
  - Track NPC actions and stress
- **Acceptance Criteria**:
  - Turn order is clear and fair (validation testing)
  - Player always knows when it's their turn
- **Dependencies**: FR-070 (Combat Detection)

---

#### FR-072: Multi-NPC Stress Tracking
- **Description**: Combat Agent tracks stress/consequences for multiple NPCs
- **Priority**: SHOULD HAVE
- **Details**:
  - Each NPC has stress boxes (1-4 depending on importance)
  - Track stress, consequences, and conditions per NPC
  - Display NPC status in combat UI (optional combat panel)
  - NPCs taken out when stress overflows and no consequence slots available
- **Acceptance Criteria**:
  - Stress tracking is accurate for all combatants (unit tests)
  - Player can see NPC status at a glance during combat
- **Dependencies**: FR-070 (Combat Detection), FR-030 (Fate Mechanics)

---

### 5.9 GM Personality (Decision 008)

#### FR-080: GM Personality Presets
- **Description**: User selects GM personality style that affects narration tone
- **Priority**: SHOULD HAVE
- **Details**:
  - Presets:
    - **Dramatic Storyteller**: Rich descriptions, cinematic narration, emotional
    - **Rules-Focused**: Explains mechanics clearly, less atmosphere, tactical
    - **Comedic**: Light-hearted tone, humor, doesn't take itself too seriously
    - **Dark & Gritty**: Serious consequences, dangerous world, noir atmosphere
    - **Neutral/Balanced**: Default middle ground
  - Implemented as system prompt modifier (personality description prepended)
  - Affects narration style, not rules application
  - Can change mid-campaign (takes effect next session)
- **Acceptance Criteria**:
  - Each preset has distinct tone (validation testing)
  - Personality consistent throughout session
  - Rules application unaffected by personality
- **Dependencies**: FR-010 (Conversation Engine)
- **Technical Notes**: Decision 008 rationale - simpler than adaptive, player knows what to expect

---

#### FR-081: Custom Personality Description
- **Description**: Advanced users can write custom GM personality description
- **Priority**: COULD HAVE
- **Details**:
  - Free-text field: "Describe the GM's personality and style"
  - Used as system prompt modifier
  - Validation: Basic sanity check (not empty, reasonable length)
- **Acceptance Criteria**:
  - Custom personality produces consistent narration (validation testing)
- **Dependencies**: FR-080 (Personality Presets)

---

## 6. Non-Functional Requirements

### 6.1 Performance

#### NFR-001: Session Start Time
- **Requirement**: Campaign loads and AI recap generated within 2 minutes total
- **Rationale**: Pain point - current state takes 5-10 minutes
- **Target**: 90th percentile under 90 seconds
- **Measurement**: Instrumented timing from campaign selection to first player input

---

#### NFR-002: AI Response Latency
- **Requirement**: AI responses appear within 2-5 seconds for typical interactions
- **Rationale**: Conversational flow requires responsive feedback
- **Target**: Median 3 seconds, 95th percentile under 8 seconds
- **Measurement**: Time from player message send to AI response start
- **Notes**: Depends on LLM provider and model selected by user

---

#### NFR-003: UI Responsiveness
- **Requirement**: UI remains responsive during LLM API calls
- **Rationale**: User should be able to scroll, read history while waiting for AI
- **Target**: 60fps scrolling, no UI freeze during API calls
- **Measurement**: Frame rate monitoring, user perception testing

---

#### NFR-004: Auto-Save Performance
- **Requirement**: Auto-save completes within 5 seconds
- **Rationale**: User shouldn't wait to close app
- **Target**: 95th percentile under 3 seconds
- **Measurement**: Time from save trigger to completion

---

### 6.2 Reliability

#### NFR-010: Data Persistence Reliability
- **Requirement**: Zero data loss on clean app close
- **Rationale**: Game state is precious, irreplaceable
- **Target**: 100% success rate for clean closes
- **Measurement**: Automated testing, user reports
- **Mitigation**: Auto-backup before each session, atomic transactions

---

#### NFR-011: Crash Recovery
- **Requirement**: Zero conversation turns lost on unexpected crash (Decision 012)
- **Rationale**: Minimize frustration from technical failures
- **Target**: 100% of crashes recover to last message
- **Measurement**: Crash telemetry, user reports
- **Mitigation**: Save after every message (Decision 012) - no periodic timer needed

---

#### NFR-012: API Failure Handling
- **Requirement**: Graceful degradation on LLM API failures
- **Rationale**: Network issues shouldn't crash app
- **Target**: Clear error message, retry option, no data loss
- **Measurement**: Simulated API failures, user reports
- **Mitigation**: Retry with exponential backoff, queue requests, preserve state

---

### 6.3 Usability

#### NFR-020: Onboarding Time
- **Requirement**: New user creates first campaign and begins playing within 10 minutes
- **Rationale**: Low barrier to entry validates concept quickly
- **Target**: 80% of new users succeed within 10 minutes
- **Measurement**: User testing, onboarding analytics

---

#### NFR-021: Rules Learning Curve
- **Requirement**: User unfamiliar with Fate Accelerated can play without reading rulebook
- **Rationale**: AI should teach rules through play
- **Target**: 90% of users report understanding rules after 1 session
- **Measurement**: Post-session survey, user testing

---

#### NFR-022: Accessibility - Text Scaling
- **Requirement**: Text scales to user OS settings (125%, 150%, 200%)
- **Rationale**: Readability for users with vision impairments
- **Target**: Readable at all standard scaling levels
- **Measurement**: Manual testing at different scales

---

#### NFR-023: Accessibility - Keyboard Navigation
- **Requirement**: All core functions accessible via keyboard (no mouse required)
- **Rationale**: Accessibility for users with motor impairments
- **Target**: Full keyboard navigation support
- **Measurement**: Manual keyboard-only testing

---

### 6.4 Security

#### NFR-030: API Key Storage Security
- **Requirement**: API keys stored securely in OS keychain, never in plaintext
- **Rationale**: Protect user credentials from theft or exposure
- **Target**: API keys never visible in logs, files, or memory dumps
- **Measurement**: Security audit, code review
- **Implementation**: Use electron-store with encryption or keytar for OS keychain

---

#### NFR-031: Local Data Privacy
- **Requirement**: All campaign data stored locally, never sent to third parties (except user's configured LLM API)
- **Rationale**: User owns their data, privacy-first design
- **Target**: Zero third-party data transmission (except LLM API)
- **Measurement**: Network traffic analysis, privacy policy review

---

#### NFR-032: LLM API Communication Security
- **Requirement**: All LLM API calls over HTTPS with certificate validation
- **Rationale**: Protect API keys and game content in transit
- **Target**: 100% encrypted communication
- **Measurement**: Network traffic analysis

---

### 6.5 Portability

#### NFR-040: Cross-Platform Compatibility (Desktop)
- **Requirement**: Runs on Windows 10+, macOS 11+, Linux (Ubuntu 20.04+, Fedora 35+)
- **Rationale**: Electron supports all major desktop platforms including Linux
- **Target**: Feature parity on all three platforms
- **Measurement**: Manual testing on Windows, macOS, and Linux
- **Notes**: Desktop-first for MVP, mobile optimization post-MVP

---

#### NFR-041: Campaign Data Portability
- **Requirement**: Campaign files can be copied to different machine and resume work
- **Rationale**: User should be able to backup or move campaigns
- **Target**: Copy campaign directory → works on new machine
- **Measurement**: Manual testing of campaign copy
- **Notes**: SQLite database + vector store files are portable

---

#### NFR-042: LLM Provider Flexibility
- **Requirement**: Works with OpenAI, Claude (Anthropic), Azure OpenAI, Ollama (local)
- **Rationale**: User choice, no vendor lock-in (BYOK model)
- **Target**: All providers produce functional gameplay
- **Measurement**: Testing with each provider
- **Notes**: User configures endpoint and API key

---

### 6.6 Maintainability

#### NFR-050: Modular Rules System Architecture
- **Requirement**: Rules systems implemented as knowledge packages with standard interface (Decision 011, 014)
- **Rationale**: Enable adding additional systems (Tales of the Valiant, etc.) post-MVP without refactoring
- **Target**: Second rules system can be added in 2-4 weeks
- **Measurement**: Technical assessment, plugin interface design review
- **Notes** (Decision 014):
  - MVP: Fate Accelerated only, but modular architecture built from day one
  - Rules as "knowledge packs" (markdown + JSON schema + optional tools)
  - Oracle systems also pluggable
  - Small upfront investment saves significant rework later

---

#### NFR-051: Logging for Debugging
- **Requirement**: All LLM interactions, tool calls, state changes logged for debugging
- **Rationale**: Troubleshoot AI behavior, rules application, bugs
- **Target**: Logs capture sufficient context to reproduce issues
- **Measurement**: Debug session success rate
- **Notes**: Exclude API keys from logs, log to local file

---

## 7. Technical Constraints & Architecture

### 7.1 Technology Stack

| Layer | Technology | Rationale (from Technical Assessment) |
|-------|------------|--------------------------------------|
| **Desktop Framework** | Electron | Cross-platform (Win/Mac/**Linux**), web technologies |
| **Agent Framework** | Vercel AI SDK | TypeScript-native, tool use, MCP support, multi-provider |
| **Backend Language** | TypeScript/Node.js | Single language, strong async/await, web ecosystem |
| **LLM Integration** | Vercel AI SDK | Clean API, streaming, tool calling, provider abstraction |
| **Structured Storage** | SQLite via better-sqlite3 | Embedded, reliable, fast, portable |
| **Vector Storage** | LanceDB or Qdrant (embedded) | Local-first vector search, no external dependencies |
| **RAG** | LangChain.js or custom with Vercel AI SDK | Document chunking, embeddings, retrieval |
| **UI Framework** | React / Vue / Svelte (TBD) | Component-based, rich ecosystem, hot reload |
| **Markdown Rendering** | react-markdown or marked | Renders AI responses in chat, portable format |

**Key Decision**: Decision 004 (Updated) - Electron + TypeScript stack enables Linux support and leverages PO's HTML/CSS familiarity

**Trade-offs**:
- Larger bundle size (~150MB) vs native apps
- Higher memory footprint
- Benefits: Linux support, huge ecosystem, fast iteration

---

### 7.2 Deployment Architecture

```
┌──────────────────────────────────────────────────┐
│         Electron Desktop App (TypeScript)        │
│                                                  │
│  ┌────────────────────────────────────────────┐ │
│  │  Renderer Process (UI Layer)               │ │
│  │  - React/Vue/Svelte (TBD)                  │ │
│  │  - Chat interface (Decision 005)           │ │
│  │  - Character sheet panel                   │ │
│  │  - Scene context panel                     │ │
│  └────────────┬───────────────────────────────┘ │
│               ↓ IPC                              │
│  ┌────────────────────────────────────────────┐ │
│  │  Main Process (Node.js Services)           │ │
│  │  - Vercel AI SDK                           │ │
│  │  - GM Agent (main)                         │ │
│  │  - Combat Agent (Fate-specific)            │ │
│  │  - State management                        │ │
│  │  - Rules execution (Fate plugin)           │ │
│  │  - Oracle mechanics (Mythic GME)           │ │
│  │  - Tool implementations                    │ │
│  └────────────┬───────────────────────────────┘ │
│               ↓                                  │
│  ┌────────────────────────────────────────────┐ │
│  │  Storage Layer                             │ │
│  │  - SQLite via better-sqlite3               │ │
│  │  - LanceDB / Qdrant (embedded)             │ │
│  │  - Local campaign files (markdown)         │ │
│  └────────────────────────────────────────────┘ │
└───────────────┬──────────────────────────────────┘
                ↓ HTTPS (OpenAI-compatible API)
        ┌───────────────────┐
        │   Cloud LLM API   │
        │  (User Configured)│
        │                   │
        │  • Claude API     │
        │  • OpenAI API     │
        │  • Azure OpenAI   │
        │  • Ollama (local) │
        └───────────────────┘
```

**Deployment Model**: Decision 001 - Local app with cloud LLM (BYOK)
- User owns data (local app)
- OpenAI-compatible API gives flexibility
- No vendor lock-in, no cost management for us
- User responsible for API costs

**Internet Requirement**: Decision 002 - Internet required for MVP (cloud LLM)
- Offline possible with local Ollama models (future)
- Same API interface works for both

---

### 7.3 Data Model (High-Level) - Hybrid Storage (Decision 010)

**Key Architectural Principle**: Player-visible content stored as markdown files (source of truth), app-internal data in SQLite for indexing/search.

#### Campaign Folder Structure (File System)
```
Campaign Folder/
├── campaign.md                  # Campaign metadata (name, system, oracle, chaos factor)
├── character.md                 # Character sheet (markdown/JSON frontmatter)
├── sessions/
│   ├── session-001.md
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
└── .appdata/
    ├── campaign.db              # SQLite indexes/cache
    ├── conversation-log.db      # Current chat session (ephemeral)
    └── embeddings/              # Vector store
```

#### campaign.md (Markdown File)
```markdown
---
name: "The Merchant's Secret"
rules_system: "fate_accelerated"
oracle_system: "mythic_gme"
chaos_factor: 5
created_at: "2025-12-10"
last_played: "2025-12-10"
---

# Campaign: The Merchant's Secret

Brief campaign description or notes...
```

#### character.md (Markdown File with JSON/YAML Frontmatter)
```markdown
---
name: "Kira Shadowblade"
approaches:
  careful: 2
  clever: 3
  flashy: 1
  forceful: 2
  quick: 1
  sneaky: 2
high_concept: "Clever Merchant-Spy"
trouble: "Too Curious for My Own Good"
aspects:
  - "Friends in Low Places"
  - "Always Has a Plan B"
  - "Loyal to the Guild"
stress_marked: 2
consequences:
  mild: "Sprained Ankle"
  moderate: null
  severe: null
fate_points: 3
inventory:
  - "Lockpicks"
  - "Guild Seal"
  - "Smoke Bomb"
---

# Kira Shadowblade

Backstory and notes...
```

#### sessions/session-NNN.md (Session Log - Markdown File)
```markdown
---
session_number: 1
date: "2025-12-10"
duration_minutes: 90
chaos_factor_change: 0
---

# Session 1: A Mysterious Summons

## Summary
Kira received an urgent message from Guild Master Thorne...

## State Changes
- **NPCs Introduced**: Guild Master Thorne, Captain Elena
- **Locations Visited**: Guild Hall, Docks District
- **Threads Opened**: Investigate warehouse disappearances
- **Inventory Acquired**: Guild Seal

## Mythic GME Updates
- Chaos Factor: 5 → 5 (no change)
- New NPCs: Guild Master Thorne (active), Captain Elena (active)
- New Threads: Investigate warehouse disappearances (active)
```

#### world/npcs/guild-master-thorne.md (NPC - Markdown File)
```markdown
---
name: "Guild Master Thorne"
status: "active"
first_met_session: 1
relationships:
  kira: "trusts"
---

# Guild Master Thorne

**Description**: Elderly dwarf with silver beard, wears merchant guild robes

**Personality**: Cautious, diplomatic, values loyalty

**Notes**: Tasked Kira with investigating warehouse disappearances. Seems worried but won't say why.
```

#### SQLite Database (Internal - Indexing Only)
```csharp
// campaign.db - Used for fast search/indexing, NOT source of truth
public class CampaignIndex
{
    public Guid Id { get; set; }
    public string FilePath { get; set; } // Path to campaign.md
    public DateTime LastModified { get; set; }
    public string SearchableText { get; set; } // For full-text search
}

public class FileIndex
{
    public Guid Id { get; set; }
    public string FilePath { get; set; } // Relative path within campaign folder
    public string FileType { get; set; } // "npc", "location", "session", "character"
    public DateTime LastModified { get; set; }
    public string SearchableText { get; set; } // Extracted from markdown
    public string Metadata { get; set; } // JSON: extracted frontmatter
}

// conversation-log.db - Ephemeral current chat session
public class ConversationMessage
{
    public Guid Id { get; set; }
    public string Role { get; set; } // "gm", "player", "system"
    public string Content { get; set; }
    public DateTime Timestamp { get; set; }
}
```

**Rationale** (Decision 010):
- Markdown files are canonical source of truth
- Player can browse, edit, organize world content like Obsidian vault
- Export is "already done" - files are human-readable
- SQLite only for performance (search indexing, caching)
- App watches file system for external changes
- World wiki structure matches solo RPG journaling workflows

---

### 7.4 AI Agent Architecture

#### GM Agent (Primary)
- **Role**: Game master, narrator, scene framing, NPC dialogue
- **System Prompt**: Conversational GM persona, rules system knowledge (Fate Accelerated), oracle integration guidance
- **Tools Available**:
  - `roll_dice(notation)`: Roll dice and return result
  - `check_rule(query)`: RAG retrieval of Fate Accelerated rules
  - `resolve_action(approach, difficulty, bonus, roll)`: Execute Fate mechanics
  - `invoke_oracle(question, likelihood)`: Mythic GME yes/no consultation
  - `get_character_state()`: Retrieve current character stats
  - `update_character_state(changes)`: Apply stress, aspects, items, etc.
  - `get_npc(name)`: Retrieve NPC details
  - `create_npc(name, personality, role)`: Generate new NPC
  - `get_scene_context()`: Current location, NPCs present, threads
  - `update_scene(location, npcs, threads)`: Change scene state
- **Context Window**: Character sheet + scene context + recent conversation (last 20-30 turns) + relevant history (RAG retrieval) + rules system docs

#### Combat Agent (Fate Accelerated-Specific) (Decision 007)
- **Role**: Tactical conflict resolution, initiative, stress tracking for multiple combatants
- **System Prompt**: Combat-focused, Fate Conflict rules, turn management
- **Tools Available**: Same as GM Agent + combat-specific tools:
  - `track_npc_stress(npc_id, stress)`: Update NPC stress
  - `apply_npc_consequence(npc_id, consequence)`: NPC takes consequence
  - `get_initiative_order()`: Determine turn order
- **Rationale** (Decision 007): Combat rules vary wildly between systems. Separate agent allows specialized prompting and swappable combat rules per system.
- **Handoff Protocol**:
  - GM Agent detects combat start → passes context to Combat Agent
  - Combat Agent manages conflict → returns control to GM Agent when combat ends

---

### 7.5 Context Management Strategy (Addressing TR-01 Risk)

**Challenge**: Long campaigns (50+ sessions) exceed LLM context windows

**Solution**: Hierarchical Memory (from Technical Assessment)

#### Layer 1: Working Memory (Always in Context)
- Current session narrative (last 10-20 turns)
- Active character state (stats, stress, aspects)
- Current scene (location, NPCs present, active threads)
- **Size**: ~5k-10k tokens

#### Layer 2: Session Memory (Summarized)
- Summary of each past session
- Key events, decisions, NPCs introduced
- Last 10 sessions in full, older sessions summarized
- **Size**: ~500 tokens/session × 10 = 5k tokens

#### Layer 3: Archival Memory (Vector Search)
- Full narrative of all sessions embedded in vector store
- Retrieved on-demand via semantic search
- Query examples: "What happened with the merchant guild?", "Who is Kael?"
- **Size**: Top 3-5 relevant chunks = 2k-5k tokens

#### Layer 4: Static Context
- Rules system documentation (via RAG)
- Character sheet
- Campaign metadata (chaos factor, GM personality)
- **Size**: ~5k-10k tokens

**Total Context Budget**: ~25k-40k tokens (within 128k window)

**Validation**: Technical spike needed for 50+ session campaigns (TR-01 risk)

---

## 8. Out of Scope (MVP)

The following features are explicitly **not included in MVP** but may be considered for future phases:

### 8.1 Voice Interface (Concept 1b)
- **Status**: Validated as future enhancement in Phase 4
- **Rationale**: Text-based chat proves concept first. Voice adds significant complexity (pause detection, TTS, interrupt handling).
- **Future Phase**: Phase 6+ after text interface validation
- **Path**: Add voice input (device speech-to-text) → Add voice output (TTS with personality) → Optimize for voice conversation

### 8.2 Multiple Rules Systems
- **Status**: Architecture designed for modularity, but MVP uses Fate Accelerated only
- **Rationale**: Validate single system first, prove architecture
- **Future Systems**: Tales of the Valiant (D&D 5E variant), others based on user demand
- **Roadmap** (Decision 003):
  - MVP: Fate Accelerated + Mythic GME
  - Phase 2: Add Tales of the Valiant (PO's preferred system)
  - Phase 3: Add additional oracles (Adventure Crafter, etc.)

### 8.3 Mobile Native Optimization
- **Status**: Electron supports mobile via Capacitor/Cordova, but desktop-first for MVP
- **Rationale**: Desktop has larger screen, better for reading/typing. Validate concept on desktop, optimize for mobile later.
- **Future Phase**: Post-MVP mobile optimization (iOS, Android)
- **Considerations**: Mobile requires: collapsible panels, touch-optimized controls, potentially voice input for convenience

### 8.4 Multiplayer / Shared Campaigns
- **Status**: Out of scope - this is a solo RPG tool
- **Rationale**: Different product direction, adds authentication, sync, concurrency complexity
- **Future Consideration**: If user demand emerges, could be separate product/mode

### 8.5 Offline Mode with Local LLM
- **Status**: Cloud LLM (BYOK) acceptable for MVP
- **Rationale**: Local LLM requires significant hardware (GPU), complicates distribution, slower inference
- **Future Option**: Support Ollama (local) via same OpenAI-compatible API for advanced users
- **User Segment**: Privacy-focused users with powerful hardware

### 8.6 Cloud Sync / Backup
- **Status**: Local-first for MVP
- **Rationale**: Adds infrastructure costs, complexity, privacy concerns
- **Future Option**: Optional cloud sync (Dropbox, Google Drive, self-hosted)
- **User Benefit**: Sync campaigns across devices, automatic backup

### 8.7 Rich Character Creation Wizard
- **Status**: Manual character sheet input for MVP
- **Rationale**: Streamlines MVP scope, users can create characters outside app initially
- **Future Enhancement**: Guided wizard with AI-assisted background generation

### 8.8 Campaign Setup Wizard
- **Status**: Minimal setup for MVP (name, character)
- **Rationale**: Setting and initial situation can be handled conversationally with AI
- **Future Enhancement**: Rich setup (genre, setting, tone, initial situation templates)

### 8.9 Advanced Analytics / Insights
- **Status**: Out of scope for MVP
- **Examples**: Session statistics, most-used approaches, NPC relationship graphs, plot thread visualization
- **Future Enhancement**: "Campaign Insights" dashboard for journaling persona (Morgan)

### 8.10 Community / Sharing Features
- **Status**: Out of scope for MVP
- **Examples**: Share session logs publicly, campaign templates, rules modules marketplace
- **Future Consideration**: Community platform for sharing adventures

---

## 9. Open Questions & Risks

### 9.1 Critical Questions (Must answer for MVP)

#### Q1: Dice Rolling UX - Final Decision
**Question**: Physical dice + typing result? Built-in digital roller? Auto-roll option? All three?

**Options**:
1. **Physical only**: Player rolls, types result → Simpler implementation, maintains tactile experience
2. **Digital only**: Click-to-roll → Faster, no external props needed
3. **Hybrid (recommended)**: Physical typing OR click-to-roll + auto-roll setting → Flexibility, user choice

**Recommendation**: Hybrid approach (Option 3)
- Default: Physical rolling with type-in result
- Optional: Click dice icon for digital roll
- Optional: Auto-roll setting for fastest play
- Rationale: Serves all user preferences without forcing one method

**Decision Needed By**: Phase 5 - Week 1
**Owner**: @ux-designer + @tech-lead
**Status**: OPEN - Needs collaboration session

---

#### Q2: Combat/Conflict Handling - Detailed Flow
**Question**: How do turn-based conflicts work conversationally? What UI changes during combat?

**Status**: Requires separate validation walkthrough (identified in Phase 4)

**Key Unknowns**:
- Initiative determination in Fate Accelerated (approach-based or narrative?)
- Turn order display (inline in chat or separate panel?)
- Multi-NPC stress tracking visibility (always visible or on-demand?)
- Transition between GM Agent and Combat Agent (seamless or explicit?)

**Validation Plan**:
- @business-analyst creates combat scenario walkthrough (similar to Phase 4 walkthrough)
- Test with typical combat: 1 PC vs 2-3 NPCs, multiple rounds
- Identify UI requirements, conversation patterns, state tracking needs

**Decision Needed By**: Phase 5 - Week 1
**Owner**: @business-analyst + @ux-designer
**Status**: OPEN - Walkthrough scheduled

---

#### Q3: Rule Knowledge Representation - Implementation Approach
**Question**: How does AI access Fate Accelerated rules? Code-based tools? RAG retrieval? Both?

**Decision Made** (Decision 011): Rules as AI agent knowledge, not compiled code
- **Rules Encoding**: Markdown documents with human-readable rules text
- **Character State**: JSON or markdown (not database entities)
- **AI Interpretation**: AI agent "knows" rules via system prompt + RAG
- **TypeScript Code Limited To**: Dice rolling utilities, file I/O, UI, orchestration
- **Rationale**: More flexible, easier to add new systems, no recompilation needed

**Example**:
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

**AI Workflow**:
1. Player action → AI determines action type and approach
2. AI calls `check_rule("overcome action in Fate")` → RAG retrieval
3. AI interprets rule and applies in conversation
4. AI calls `roll_dice("4dF+3")` → Dice utility validates math
5. AI narrates based on result

**Status**: RESOLVED - Decision 011

---

#### Q4: State Persistence Scope - What Gets Saved?
**Question**: What exactly gets saved in Session Log (Decision 009)? How much history?

**Decision Made** (Decision 010, 012): Hybrid file-based storage with save-after-every-message
- **Session Log** (persisted at session end as markdown file):
  - Narrative summary (2-3 paragraphs)
  - State changes: New NPCs, locations, inventory changes, character state changes
  - Mythic GME updates: Chaos factor change, new threads, thread resolutions
  - Stored as: sessions/session-NNN.md

- **World State** (persisted as markdown files):
  - NPCs: world/npcs/[npc-name].md
  - Locations: world/locations/[location-name].md
  - Factions: world/factions/[faction-name].md
  - Character: character.md

- **Current Conversation** (ephemeral database):
  - Full transcript in conversation-log.db
  - Saved after every message (Decision 012)
  - Cleared after session end (summary saved to markdown)

**Data Model**:
```markdown
# sessions/session-001.md
---
session_number: 1
date: "2025-12-10"
duration_minutes: 90
chaos_factor_change: 0
---

## Summary
[Narrative summary]

## State Changes
- NPCs Introduced: [list]
- Locations Visited: [list]
- Inventory Acquired: [list]
```

**Status**: RESOLVED - Decisions 010, 012

---

### 9.2 Important Questions (Should answer for MVP)

#### Q5: Conversation Length Management
**Question**: When are responses too long? Does user setting solve this?

**Recommendation**: Narration Style setting (FR-015) + AI prompt guidance
- Setting: Terse / Balanced / Rich
- AI system prompt: "Keep responses concise, 2-3 sentences unless describing important scene. Match user's narration style preference."
- Validation: User testing with different style settings

**Status**: Recommendation clear, validation in user testing
**Owner**: @ux-designer

---

#### Q6: NPC Auto-Creation - What Triggers Persistence?
**Question**: When does NPC get persisted? All NPCs or only important ones?

**Recommendation**: Importance-based tiering
- **Tier 1 - Ephemeral**: Unnamed NPCs ("a guard", "the innkeeper") - not persisted
- **Tier 2 - Named**: NPCs with names auto-saved at session end
- **Tier 3 - Major**: NPCs with aspects or relationships auto-promoted to major status, persisted immediately

**Implementation**:
- AI generates NPC with name → Added to temporary NPC list
- Session end: All named NPCs persisted to database
- If NPC gains aspect/relationship mid-session → Immediately promoted to major, persisted

**Status**: Recommendation clear, needs validation
**Owner**: @business-analyst

---

#### Q7: Rule Teaching Balance - Tracking Mechanics Encountered
**Question**: How does AI know player has seen a mechanic before?

**Recommendation**: Per-campaign mechanics tracker
- Database table: `mechanics_encountered` (campaign_id, mechanic_name, first_encounter_session)
- Mechanic examples: "create_advantage", "invoke_aspect", "consequence_selection"
- First encounter: AI explains mechanic in detail
- Subsequent encounters: AI applies silently (player can ask "explain X" anytime)

**Implementation**:
```csharp
public class MechanicsTracker
{
    public bool HasEncountered(Guid campaignId, string mechanic);
    public void MarkEncountered(Guid campaignId, string mechanic, int sessionNumber);
}
```

**Status**: Recommendation clear, needs implementation
**Owner**: @business-analyst + @tech-lead

---

#### Q8: Ambiguous Input Patterns - How to Clarify?
**Question**: What patterns indicate ambiguity? How does AI clarify?

**Recommendation**: Pattern recognition + clarifying questions
- **Ambiguous Patterns**:
  - Vague verbs: "I deal with the guard" → "How do you want to deal with them?"
  - Missing approach: "I try to get past" → "Are you sneaking past (Sneaky) or talking your way through (Clever)?"
  - Unclear target: "I attack" (multiple enemies present) → "Which enemy are you attacking?"
- **AI Response Pattern**: Ask clarifying question naturally, offer 2-3 options if helpful
- **Validation**: Test with intentionally ambiguous inputs during user testing

**Status**: Recommendation clear, needs validation
**Owner**: @ux-designer + @tech-lead

---

#### Q9: Graph RAG for World Knowledge Relationships (NEW)
**Question**: Should we use Graph RAG instead of vector RAG for world knowledge with rich relationships?

**Context** (Decision 013):
- World knowledge has rich relationships: NPC knows NPC, location contains location, faction controls territory
- Standard vector RAG may miss relationship-based queries
- Example query: "Who does the merchant guild have conflicts with?" benefits from graph traversal
- Graph RAG could improve context retrieval for interconnected queries

**Technical Spike Scope**:
- Evaluate graph database options: Neo4j, graph layer on SQLite, or embedded solution
- Test graph RAG vs vector RAG for relationship queries in solo RPG context
- Assess complexity vs benefit for MVP
- Determine if graph is MVP or post-MVP enhancement

**Key Questions**:
1. Does graph RAG significantly improve relationship queries vs vector RAG?
2. What's the implementation complexity (learning curve, dependencies)?
3. Can graph layer coexist with file-based markdown storage (Decision 010)?
4. Is the benefit worth the added complexity for MVP?

**Recommendation**: Technical spike in Phase 5 - Week 2
**Owner**: @tech-lead
**Status**: OPEN - Spike scheduled

---

### 9.3 Nice to Have Questions (Can defer post-MVP)

#### Q10: Conversation Export Format
**Question**: Markdown? PDF? Plain text?

**Status**: Defer to post-MVP - sessions already stored as markdown (Decision 010)
**Recommendation**: Markdown files already available in sessions/ folder

---

#### Q11: GM Personality Customization Depth
**Question**: Just presets or allow full custom description?

**Status**: Presets for MVP (FR-080), custom optional (FR-081, COULD HAVE)

---

#### Q12: Multiple Character Support
**Question**: Single character or party control?

**Status**: Single character for MVP - simplifies pronouns, turn order, UI
**Future**: Post-MVP if user demand

---

#### Q13: Voice Implementation Path (Concept 1b)
**Question**: What tech for voice input/output?

**Status**: Future phase (6+) - not MVP
**Path**: Platform speech-to-text (input) → TTS (output) → Optimize conversation patterns

---

#### Q14: Offline Mode
**Question**: Can app work without internet?

**Status**: Cloud LLM required for MVP
**Future**: Ollama (local) support via same API interface

---

#### Q15: House Rules Customization
**Question**: How does player teach AI house rules?

**Status**: Defer to post-MVP - standard rules sufficient for MVP
**Future**: Custom rules field in settings, prepended to system prompt

---

### 9.4 Technical Risks

#### TR-01: Context Management for Long Campaigns (CRITICAL)
- **Description**: After 50+ sessions, AI loses track of plot threads, forgets NPCs
- **Likelihood**: MEDIUM
- **Impact**: HIGH (campaigns become unplayable)
- **Mitigation**: Hierarchical memory (working + session + archival via vector store), user-curated pins, importance scoring
- **Validation**: Technical spike - simulate 50+ session campaign with memory system
- **Status**: OPEN - Spike needed in Phase 5

---

#### TR-02: Rules Inconsistency Across Sessions (CRITICAL)
- **Description**: AI applies Fate rules differently in different sessions
- **Likelihood**: MEDIUM
- **Impact**: HIGH (breaks game feel, user trust)
- **Mitigation**: Encode mechanics as TypeScript utilities (not AI interpretation), RAG for context, extensive unit tests, version lock rules per campaign
- **Validation**: Extensive testing with Fate rules, validation across multiple sessions
- **Status**: OPEN - Testing in development

---

#### TR-V01: Dice Rolling UX Ambiguity (HIGH)
- **Description**: Walkthrough assumes player types roll results, but interaction not fully specified
- **Likelihood**: HIGH (design incomplete)
- **Impact**: MEDIUM (affects every skill check)
- **Mitigation**: Define exact dice rolling interaction in Phase 5 Week 1 (see Q1)
- **Status**: OPEN - Needs design decision

---

#### TR-V02: Combat Complexity Untested (MEDIUM)
- **Description**: Walkthrough had stealth checks but no full combat scenario
- **Likelihood**: MEDIUM
- **Impact**: MEDIUM (common scenario, more complex than skill checks)
- **Mitigation**: Conduct separate combat walkthrough in Phase 5 (see Q2)
- **Status**: OPEN - Walkthrough scheduled

---

#### TR-V03: AI Verbosity Risk (MEDIUM)
- **Description**: AI responses could become too long, slowing pace
- **Likelihood**: MEDIUM
- **Impact**: MEDIUM (affects pacing, user satisfaction)
- **Mitigation**: Narration Style setting (FR-015), AI prompt guidance for conciseness, user testing
- **Status**: OPEN - Validation in user testing

---

## 10. Appendices

### 10.1 Key Decisions Reference

The following decisions from the Decisions Log inform this PRD:

- **Decision 001**: Deployment Architecture - Local app with cloud LLM (BYOK model)
- **Decision 002**: Internet Requirement - Internet required for MVP, offline possible with local models
- **Decision 003**: MVP Rule System - Fate Accelerated + Mythic GME
- **Decision 004**: Technology Stack - Electron + TypeScript with Vercel AI SDK
- **Decision 005**: Interaction Model - Chat-first conversational interface (no quick-action buttons)
- **Decision 006**: Dice Rolling UX - GM explains and requests rolls conversationally, with optional click-to-roll icon
- **Decision 007**: Combat/Conflict Agent - Separate AI agent for combat resolution
- **Decision 008**: GM Personality Configuration - User-selectable GM personality presets
- **Decision 009**: Session State Model - Two-tier: Chat Session (in-progress) → Session Log (summary at end)
- **Decision 010**: Hybrid Storage Architecture - Player-visible content as markdown files (like Obsidian vault), SQLite for search/indexing, vector store for semantic search
- **Decision 011**: Rules as AI Agent Knowledge - Rules stored as markdown documents, character state as JSON/markdown, AI interprets rules conversationally, TypeScript code limited to dice/file I/O/UI/orchestration
- **Decision 012**: Save After Every Message - Current chat session saves after each message, no auto-save timer, simpler crash recovery
- **Decision 013**: Graph RAG Exploration Spike - Evaluate graph RAG for world knowledge relationship queries
- **Decision 014**: Modular Architecture from Day One - Build pluggable rules/oracle systems even though MVP has only Fate + Mythic GME

### 10.2 Wireframe References

**Note**: Detailed wireframes to be created by @ux-designer in Phase 5, Week 2

**Required Wireframes**:
1. **Campaign List Screen** (FR-053)
2. **Main Play Screen - Desktop Layout** (FR-050, FR-051, FR-052)
   - Character sheet panel (left)
   - Chat interface (center)
   - Scene context panel (header or right)
3. **Main Play Screen - Mobile Layout** (responsive design)
   - Collapsible character sheet
   - Chat-focused layout
4. **Settings Screen** (FR-054)
5. **Combat UI Treatment** (FR-070-072) - pending combat walkthrough
6. **Campaign Creation Flow** (FR-001)

### 10.3 User Flow References

**Validated in Phase 4**:
- Session Start with Recap (FR-003)
- Natural Language Action Input (FR-011)
- Dice Roll in Conversation (FR-016-018)
- Invisible Oracle Consultation (FR-040)
- Session End & Auto-Save (FR-004)

**Pending Validation**:
- Combat Encounter Flow (FR-070-072) - requires separate walkthrough

### 10.4 Glossary

| Term | Definition |
|------|------------|
| **Aspect** | Fate Accelerated mechanic: A phrase describing a character, scene, or story element that can be invoked for mechanical benefit |
| **BYOK** | Bring Your Own Key - User provides their own API key for LLM service |
| **Chaos Factor** | Mythic GME mechanic: A number (1-9) representing how chaotic the campaign is, affecting oracle probabilities |
| **Consequence** | Fate Accelerated mechanic: A negative aspect taken to absorb damage when stress boxes are full (Mild, Moderate, Severe) |
| **Fate Accelerated (FAE)** | Simplified rules system based on Fate Core, uses 6 approaches instead of skills |
| **Invoke** | Fate mechanic: Spend a fate point to get +2 bonus or reroll by citing a relevant aspect |
| **Mythic GME** | Mythic Game Master Emulator - Solo RPG oracle system providing yes/no answers and random events |
| **Oracle** | Solo RPG tool that provides random answers to questions, enabling emergent narrative without a GM |
| **RAG** | Retrieval Augmented Generation - AI technique combining document retrieval with LLM generation |
| **Session Log** | (Decision 009) Summarized record of a completed session, as opposed to full conversation transcript |
| **Stress** | Fate mechanic: Boxes (1-4) that absorb damage before consequences are needed |
| **Thread** | Mythic GME mechanic: An open plot thread or question that drives narrative forward |

---

## Approvals

| Role | Name | Date | Status |
|------|------|------|--------|
| **Product Owner** | User | TBD | Pending Review |
| **Tech Lead** | @tech-lead | TBD | Pending Review |
| **UX Designer** | @ux-designer | TBD | Pending Review |

---

**Next Steps:**
1. **Week 1**: Combat walkthrough (@business-analyst), dice UX decision (@ux-designer + @tech-lead), rules implementation spike (@tech-lead)
2. **Week 2**: Desktop wireframes (@ux-designer), state persistence design (@business-analyst + @tech-lead), context management spike (@tech-lead)
3. **Week 3**: Mobile wireframes (@ux-designer), PRD finalization and approval (@business-analyst), feature backlog creation (@business-analyst)

---

*End of Product Requirements Document*
