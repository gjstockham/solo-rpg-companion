# Technical Feasibility Review: Concept 3 (Director's Cut / Hybrid)

**Project**: Solo RPG App
**Phase**: Phase 3 - Ideation
**Date**: 2025-12-09
**Reviewed by**: @tech-lead
**Concept**: Concept 3 - The Director's Cut (Hybrid)

---

## Executive Summary

**Overall Feasibility**: HIGH ✅ with MEDIUM-HIGH complexity

**Verdict**: Concept 3 is technically feasible and aligns well with the recommended architecture. The hybrid Quick Mode/Detail Mode approach adds complexity but is achievable with the proposed tech stack (Tauri, Python, Microsoft Agent Framework, SQLite + ChromaDB, Claude API).

**Key Findings**:
- Quick Mode is straightforward and low-risk
- Detail Mode adds complexity but leverages existing patterns
- Dual-mode architecture requires thoughtful state management but is manageable
- Context window management is the primary risk area
- MVP simplification (Quick Mode only) is technically sound and recommended

**Biggest Technical Challenges**:
1. Context window management in both modes (especially Detail Mode with longer inputs)
2. AI prompt engineering to calibrate Quick Mode narrative length
3. Seamless mode switching without jarring UX
4. Maintaining narrative coherence across mode changes

**Recommendation**: BUILD Concept 3 with phased rollout - Quick Mode MVP first, Detail Mode in iteration

---

## 1. Overall Feasibility Assessment

### Can We Build This?

**YES** - The recommended tech stack can support this concept:

| Component | Capability | Confidence |
|-----------|------------|------------|
| **Microsoft Agent Framework** | Multi-turn conversation with tool use | HIGH ✅ |
| **Claude API** | High-quality narrative generation, instruction following | HIGH ✅ |
| **SQLite + ChromaDB** | Persistent state + memory retrieval | HIGH ✅ |
| **Tauri + React** | Desktop app with responsive UI | HIGH ✅ |
| **Fate Accelerated rules** | Hybrid encoding (Python + RAG) | MEDIUM-HIGH ⚠️ |

### Technical Alignment

Concept 3 aligns well with technical assessment findings:

✅ **Fits hybrid rules approach** (T2): Quick actions trigger Python tools, Detail Mode allows AI interpretation with rules context

✅ **Leverages tool use pattern** (T1): Quick Mode action buttons map to structured tool calls

✅ **Supports context management** (T5): Hierarchical memory works for both modes

✅ **Local app + cloud LLM** (T3): Architecture already assumed in technical assessment

### Showstoppers?

**NONE identified**, but key risks to monitor:

1. **Context window pressure in Detail Mode**: User writes 300-word detailed action → AI needs context to respond → Context budget tighter than Quick Mode
   - **Mitigation**: Optimize context retrieval, prioritize recent working memory

2. **Mode switching state management**: Transitioning between modes must preserve exact scene state
   - **Mitigation**: Clear state model, extensive testing of transitions

3. **AI response calibration**: Quick Mode needs concise (2-4 paragraphs), Detail Mode needs expansive (3-6 paragraphs)
   - **Mitigation**: Different system prompts per mode, token limits

---

## 2. Flow-by-Flow Technical Analysis

### Flow 1: Session Start (Resume Campaign)

**Steps**: Launch app → Select campaign → AI recap → Scene check (Mythic GME) → Scene setup (Quick Mode)

#### Feasibility: HIGH ✅

| Step | Technical Requirement | Complexity | Risk |
|------|----------------------|------------|------|
| **Campaign list** | SQLite query + UI rendering | LOW | None |
| **Load session state** | SQLite + ChromaDB retrieval | LOW | Data corruption (mitigated by backups) |
| **AI recap generation** | LLM call with campaign context | MEDIUM | Context too long (T5) |
| **Scene check (Mythic GME)** | Dice roll + table lookup (Python) | LOW | None |
| **Scene setup** | AI generates scene description + action buttons | MEDIUM | Action generation quality |

#### Key Technical Requirements

**AI Recap (Step 3)**:
```python
# Context structure for recap
context = {
    "working_memory": last_session_summary,  # ~500 tokens
    "active_threads": get_threads(status="active"),  # ~200 tokens
    "character_state": get_character_snapshot(),  # ~300 tokens
    "last_scene": get_last_scene_description(),  # ~500 tokens
}
# Total: ~1500 tokens → Prompt: "Generate 2-3 paragraph recap"
```

**Performance targets** (from flow doc):
- Campaign list load: <500ms ✅ Easy (SQLite)
- Session state load: <1s ✅ Easy
- AI recap generation: <3s ✅ Achievable with streaming
- Scene check + setup: <2s ✅ Achievable

#### Risks

**Medium Risk: AI Recap Quality** (RT-01)
- **Issue**: Recap might miss important context or be too generic
- **Mitigation**:
  - User-curated "pins" (important facts marked by user)
  - Include thread priority scoring
  - Test with diverse campaign types
- **Contingency**: User can edit/regenerate recap

**Low Risk: Scene Check Feels Mechanical**
- **Issue**: Mythic GME scene check could break immersion
- **Mitigation**: Fast animation, collapsible detail for power users
- **Acceptable**: This is expected by target audience (Alex knows Mythic GME)

#### Verdict: HIGH FEASIBILITY
- No technical blockers
- Performance targets achievable
- Risks are mitigatable

---

### Flow 2: Core Play Loop (Quick Mode)

**Steps**: Present action options → Player selects → AI interprets → Determine roll → Roll dice → AI narrates → Check for story beat → Continue

#### Feasibility: HIGH ✅

| Step | Technical Requirement | Complexity | Risk |
|------|----------------------|------------|------|
| **Action button generation** | LLM generates 3-4 contextual actions | MEDIUM | Quality/relevance |
| **AI interprets intent** | LLM determines mechanic + difficulty | MEDIUM | Misinterpretation |
| **Dice roll** | Python function (4dF) | LOW | None |
| **AI narrates outcome** | LLM generates 2-4 paragraph narrative | MEDIUM | Length calibration |
| **Story beat detection** | LLM evaluates narrative significance | MEDIUM | Over/under-flagging |

#### Key Technical Requirements

**Action Button Generation** (Step 1):
```python
# AI tool: generate_quick_actions
def generate_quick_actions(scene_context, character, recent_actions):
    """Generate 3-4 contextual action buttons"""
    prompt = f"""
    Given scene: {scene_context}
    Character approaches: {character.approaches}
    Recent actions (avoid): {recent_actions}

    Generate 3-4 diverse action options:
    - At least one "safe" (low risk)
    - At least one "interesting" (pushes story forward)
    - Varied approaches (Clever, Flashy, Forceful, etc.)

    Format: [Action text] (Approach)
    """
    # Returns: ["Talk past guards (Clever)", "Sneak around (Sneaky)", ...]
```

**Narrative Generation** (Step 6):
- Challenge: Calibrate length (2-4 paragraphs, not too brief/verbose)
- Solution: Token limit in prompt (e.g., "Generate 100-200 word narrative")
- Test: Compare outputs across diverse actions

**Performance targets** (from flow doc):
- Action interpretation: <500ms ✅ Fast LLM call
- Roll calculation: Instant ✅ Python
- Narrative generation: <3s ✅ Streaming response
- Action button generation: <1s ✅ Lightweight LLM call

#### Risks

**Medium Risk: Narrative Length Calibration** (RT-02)
- **Issue**: AI might be too brief (unsatisfying) or too verbose (slow)
- **Mitigation**:
  - Token limits in system prompt
  - Test diverse action types
  - User setting: "Concise" vs "Descriptive" preference
- **Contingency**: Regenerate button if unsatisfactory

**Medium Risk: Action Button Quality** (RT-03)
- **Issue**: Suggested actions might not match player intent
- **Mitigation**:
  - Always provide custom text input option
  - Learn from user's custom action frequency
  - Test with diverse scene types
- **Contingency**: Custom text input is primary path if buttons fail

**Low Risk: Rules Interpretation Consistency** (T2 from tech assessment)
- **Issue**: AI might apply Fate rules differently across sessions
- **Mitigation**:
  - Encode core mechanics as Python tools (not AI interpretation)
  - AI calls `resolve_action(approach, difficulty, bonus)` tool
  - RAG for edge cases
- **Status**: Already addressed in tech architecture

#### Verdict: HIGH FEASIBILITY
- Core loop is well-defined and maps to technical capabilities
- Risks are acceptable with mitigations
- Performance targets achievable

---

### Flow 2b: Detail Mode (Opt-in)

**Steps**: Enter Detail Mode → Expanded text input → Player writes detailed action → AI narrates (longer response) → Continue or exit Detail Mode

#### Feasibility: MEDIUM-HIGH ⚠️

| Step | Technical Requirement | Complexity | Risk |
|------|----------------------|------------|------|
| **Mode transition** | UI state change + context preservation | LOW | State consistency |
| **Large text input handling** | Text area with markdown support | LOW | None |
| **AI interprets detailed action** | LLM processes 100-500 char player text | MEDIUM | Misinterpretation |
| **AI narrates (detailed)** | LLM generates 3-6 paragraph response | MEDIUM-HIGH | Context window pressure |
| **Mode persistence** | Track mode preference per user | LOW | None |

#### Key Technical Requirements

**Detail Mode Narrative Generation** (Step 5):
```python
# Different system prompt for Detail Mode
detail_prompt = """
You are in DETAIL MODE. The player has provided specific narrative input.

Rules:
1. Honor their exact words - build on, don't rewrite
2. If player wrote dialogue, NPCs respond to those specific words
3. Generate 3-6 paragraphs (200-400 words)
4. Match player's narrative style (formal/casual, descriptive/sparse)
5. "Show don't tell" - more sensory detail

Player input: {player_detailed_text}
Scene context: {scene}
"""
```

**Context Window Challenge**:
- Quick Mode: ~25-30k tokens context budget
- Detail Mode: Player input (500 words = ~700 tokens) + Response needs (400 words = ~550 tokens)
- Net increase: ~1200 tokens per exchange vs ~400 in Quick Mode
- **Impact**: Detail Mode reduces available context for campaign history
- **Mitigation**:
  - Optimize context retrieval (fewer archival chunks)
  - Prioritize recent working memory over old sessions
  - Detail Mode expected to be used sparingly (10-20% of actions)

**Performance targets** (from flow doc):
- Detail Mode AI response: <5s (acceptable - player just wrote 100+ words)
- But: Stream response as it generates (paragraph by paragraph)

#### Risks

**MEDIUM-HIGH Risk: Context Window Pressure** (RT-04)
- **Issue**: Detail Mode exchanges consume more context budget
- **Likelihood**: Medium
- **Impact**: High (might lose campaign history context)
- **Mitigation**:
  - Hierarchical memory with prioritization
  - Aggressive summarization of old sessions
  - Test with realistic Detail Mode usage (20% of actions)
- **Contingency**: Warn user when context budget tight, suggest Quick Mode

**Medium Risk: Player Input Misinterpretation** (RT-05)
- **Issue**: AI might misread player's intent in detailed text
- **Mitigation**:
  - Show "(Interpreted as [approach])" note
  - Offer "Try differently?" regeneration
  - Learn from user corrections
- **Contingency**: User can edit/override AI response

**Low Risk: Mode Switching Feels Jarring**
- **Issue**: Transition between modes could break flow
- **Mitigation**:
  - Smooth visual transitions
  - Clear mode indicator
  - Preserve exact scene state across switch
- **Validation**: UX testing needed

#### Verdict: MEDIUM-HIGH FEASIBILITY
- Detail Mode is technically achievable
- Context window management is primary concern (RT-04)
- Recommend: Launch Quick Mode MVP, add Detail Mode post-validation
- Risk acceptable IF Detail Mode usage stays <30% of actions

---

### Flow 3: Oracle Consultation

**Steps**: Click "Ask Oracle" → Choose question type (Yes/No, Meaning, Inspiration) → Roll/Generate → Show result → Optional AI interpretation → Accept and continue

#### Feasibility: HIGH ✅

| Step | Technical Requirement | Complexity | Risk |
|------|----------------------|------------|------|
| **Fate Chart roll (Yes/No)** | Percentile dice + table lookup (Python) | LOW | None |
| **Meaning tables** | Roll on Mythic tables (Python) | LOW | None |
| **Inspiration generation** | LLM generates NPC/location/object | MEDIUM | Quality variance |
| **AI interpretation** | LLM contextualizes oracle result | LOW | Optional feature |
| **Random event detection** | Chaos factor check (Python) | LOW | None |

#### Key Technical Requirements

**Mythic GME Implementation**:
```python
class MythicOracle:
    def fate_chart(self, likelihood: str, chaos_factor: int) -> str:
        """Mythic GME Fate Chart"""
        probabilities = FATE_CHART[likelihood][chaos_factor]
        roll = random.randint(1, 100)

        if roll <= probabilities['exceptional_yes']:
            return "Exceptional Yes"
        elif roll <= probabilities['yes']:
            return "Yes"
        # ... etc

        # Check for random event
        if roll % 11 == 0:  # Mythic GME random event rule
            return self.random_event()

    def meaning_tables(self, context: str):
        """Roll on Meaning tables"""
        action = random.choice(MEANING_ACTIONS)
        description = random.choice(MEANING_DESCRIPTIONS)
        return f"{action} + {description}"
```

**AI Inspiration Tool**:
```python
def generate_inspiration(category: str, context: str):
    """AI generates NPC, location, object, etc."""
    prompt = f"""
    Generate a {category} for a solo RPG scene.
    Context: {context}
    Campaign genre: {campaign.genre}

    Be specific, evocative, and avoid cliches.
    Output: Name and one distinctive detail.
    """
    return llm.call(prompt)
```

**Performance targets**:
- Dice roll: Instant ✅ Python calculation
- AI interpretation: <2s ✅ Short LLM call
- Modal open/close: Smooth animations ✅ UI only

#### Risks

**LOW Risk: Oracle Results Feel Random/Disconnected**
- **Issue**: Oracle answers might not fit scene context
- **Mitigation**: AI interpretation connects result to situation
- **Acceptable**: Solo RPG players expect this (part of oracle mechanics)

**LOW Risk: Inspiration Generation Quality**
- **Issue**: AI might generate generic/cliche content
- **Mitigation**:
  - Regenerate option
  - Context-aware prompts (avoid recent NPCs/locations)
  - Test with diverse genres
- **Contingency**: User can manually edit generated content

#### Verdict: HIGH FEASIBILITY
- Oracle mechanics are straightforward (dice + tables)
- AI enhancement (interpretation, inspiration) is low-risk addition
- No technical blockers

---

### Flow 4: Combat/Conflict Resolution

**Steps**: Trigger conflict → Set up stakes + opponents → Player exchange (action + roll) → Opponent exchange (AI) → Check conflict end → Resolve → Return to normal play

#### Feasibility: MEDIUM-HIGH ⚠️

| Step | Technical Requirement | Complexity | Risk |
|------|----------------------|------------|------|
| **Conflict detection** | AI or user triggers conflict mode | LOW | False positives |
| **Stakes definition** | AI generates stakes based on context | MEDIUM | Quality/clarity |
| **Stress track management** | Python data structure + UI update | LOW | None |
| **AI opponent tactics** | LLM decides opponent actions | MEDIUM | Predictability |
| **Multi-exchange tracking** | State management across rounds | MEDIUM | State corruption |
| **Resolution narrative** | AI generates climactic outcome | MEDIUM | Quality |

#### Key Technical Requirements

**Conflict State Management**:
```python
class Conflict:
    def __init__(self, participants, stakes):
        self.participants = participants  # Player + NPCs
        self.stakes = stakes  # Victory/defeat conditions
        self.stress_tracks = {p: [0] * p.stress_boxes for p in participants}
        self.consequences = {p: [] for p in participants}
        self.rounds = []
        self.status = "active"

    def resolve_exchange(self, actor, action, target):
        roll = resolve_action(action.approach, action.difficulty, actor.bonus)
        if roll['outcome'] == 'success':
            self.apply_stress(target, roll['shifts'])
        self.rounds.append((actor, action, roll))
        return self.check_conflict_end()
```

**AI Opponent Tactics**:
```python
def ai_opponent_action(opponent, conflict_state, player_state):
    """AI decides opponent's action"""
    prompt = f"""
    You are {opponent.name} in conflict.
    Personality: {opponent.tactics}
    Current state: {conflict_state}
    Player state: {player_state}

    Choose action:
    - Attack (deal stress)
    - Create Advantage (gain boost)
    - Defend (increase defense)
    - Flee/Concede (if appropriate)

    Consider: Are you winning? Losing? Desperate? Confident?
    Output: Action + Approach + Rationale
    """
    return llm.call(prompt)
```

**Performance targets**:
- Conflict Mode UI: <500ms to enter ✅
- Full exchange (player + opponent): <1 minute (includes player decision time)
- AI opponent decision: <2s ✅
- Resolution narrative: <3s ✅

#### Risks

**Medium Risk: Conflict Mode Complexity** (RT-06)
- **Issue**: Conflict tracking is most complex state management
- **Mitigation**:
  - Clear data model
  - Extensive testing of edge cases
  - Rollback capability (undo last exchange)
- **Validation**: Test with multi-round, multi-opponent conflicts

**Medium Risk: AI Opponent Behavior** (RT-07)
- **Issue**: Opponents might feel predictable or illogical
- **Mitigation**:
  - Personality-driven tactics
  - Randomness in decision-making
  - Test diverse opponent types
- **Contingency**: User can override opponent action

**Low Risk: Conflict Pacing**
- **Issue**: Conflicts might drag or feel rushed
- **Mitigation**:
  - Suggest "End this quickly?" after dominant victory
  - Concede option always available
  - Target 3-5 rounds per conflict
- **Acceptable**: User controls pacing via actions

#### Verdict: MEDIUM-HIGH FEASIBILITY
- Conflict mechanics are well-defined (Fate system)
- State management is most complex part of app, but achievable
- AI opponent tactics need careful tuning
- Recommend: Extensive testing, but no showstoppers

---

### Flow 5: Session End

**Steps**: Initiate end → Auto-save → Generate summary → Update chaos factor → Show stats → Export options → Farewell screen

#### Feasibility: HIGH ✅

| Step | Technical Requirement | Complexity | Risk |
|------|----------------------|------------|------|
| **Auto-save** | Write to SQLite + ChromaDB | LOW | Database corruption (mitigated) |
| **Session summary generation** | LLM summarizes session | MEDIUM | Quality variance |
| **Chaos factor adjustment** | Rule-based calculation (Python) | LOW | None |
| **Session stats** | Telemetry aggregation | LOW | None |
| **Export (Markdown/PDF)** | Template rendering + file write | LOW | File permissions |
| **Cloud sync** (future) | Upload to Dropbox/GDrive | MEDIUM | Not MVP |

#### Key Technical Requirements

**Session Summary**:
```python
def generate_session_summary(session_narrative, threads, character_state):
    """AI summarizes session"""
    prompt = f"""
    Summarize this solo RPG session in 2-3 paragraphs.

    Session narrative (key moments):
    {session_narrative.key_moments}

    Active threads: {threads}
    Character progression: {character_state.changes}

    Focus on:
    - Player's key decisions
    - Story progression
    - Cliffhanger/hook for next session

    Tone: Emphasize player agency ("You decided to...")
    """
    return llm.call(prompt)
```

**Export Format** (Markdown):
```markdown
# Session: 2025-12-09
## Campaign: Desert Expedition

**Duration**: 45 minutes
**Scenes**: 1

---

## Scene: The City Gates

[Full narrative with player actions and AI responses]

### Actions Taken
- Talk past guards (Clever +2) → Success
- Find inn (Quick +1) → Success

### Oracle Calls
- Q: Is there a guard in the tower? | A: Yes

---

## Summary
[AI-generated summary]

**Threads**:
- Deliver message to High Merchant: In Progress
- Avoid the Azure Hand: In Progress

**Next Session**: You've entered Kalinth, but the Azure Hand might be on your trail...
```

**Performance targets**:
- Auto-save: <200ms (async) ✅ SQLite fast
- Summary generation: <3s ✅ LLM call
- Export: <5s for typical session ✅ File I/O

#### Risks

**Low Risk: Export Format Quality**
- **Issue**: Exported narrative might not be readable/useful
- **Mitigation**:
  - Test with journaling personas (Morgan)
  - Iterate on template formatting
  - Offer multiple formats (Markdown, PDF, plain text)
- **Validation**: User testing with exported files

**Low Risk: Data Corruption**
- **Issue**: Auto-save or export might corrupt data
- **Mitigation**:
  - Atomic transactions
  - Auto-backup before each session
  - Verify write success
- **Contingency**: Restore from backup

#### Verdict: HIGH FEASIBILITY
- Session end is straightforward
- Export is critical for Morgan persona, but technically simple
- No blockers

---

## 3. Technical Challenges

### Challenge 1: Context Window Management (Dual Modes)

**Problem**: Detail Mode consumes more context budget than Quick Mode, potentially impacting campaign memory retrieval.

**Analysis**:

| Mode | Context Budget per Exchange | Impact |
|------|--------------------------|--------|
| **Quick Mode** | ~400 tokens (short action + 2-4 para response) | Baseline |
| **Detail Mode** | ~1200 tokens (long player input + 3-6 para response) | 3x increase |

**If 20% of actions use Detail Mode**:
- Average context per action: 0.8 × 400 + 0.2 × 1200 = 560 tokens
- Over 50 actions: 560 × 50 = 28,000 tokens
- Remaining budget for campaign history: 128k - 28k - 10k (rules) = 90k tokens ✅ Acceptable

**If 50% of actions use Detail Mode** (Morgan persona):
- Average context per action: 0.5 × 400 + 0.5 × 1200 = 800 tokens
- Over 50 actions: 800 × 50 = 40,000 tokens
- Remaining budget: 128k - 40k - 10k = 78k tokens ✅ Still acceptable, but tighter

**Mitigation Strategy**:
1. Hierarchical memory with aggressive summarization
2. Prioritize recent working memory (last 10 turns always in context)
3. Vector search retrieves only top 3-5 relevant historical chunks
4. Monitor context usage, warn user if approaching limits
5. Test with synthetic long campaigns (50+ sessions, high Detail Mode usage)

**Confidence**: MEDIUM-HIGH
- Within 128k context window IF Detail Mode <50% usage
- Needs spike to validate with realistic long campaigns

---

### Challenge 2: AI Prompt Engineering (Mode Calibration)

**Problem**: AI must generate different narrative lengths and styles for Quick vs Detail Mode.

**Quick Mode Requirements**:
- 2-4 paragraphs (100-250 words)
- Concise but complete
- Fast-paced narrative
- Covers: action → roll → outcome → next situation

**Detail Mode Requirements**:
- 3-6 paragraphs (200-400 words)
- Honors player's specific input
- More sensory detail, "show don't tell"
- Responds to player's exact words (especially dialogue)

**Solution**:
```python
# Quick Mode prompt
quick_mode_system = """
You are a solo RPG GM in QUICK MODE.

Rules:
- Generate 2-4 paragraphs (100-250 words)
- Be concise but complete
- Cover: what happens, how NPCs react, outcome, next situation
- Fast-paced, efficient narrative

Token limit: 350
"""

# Detail Mode prompt
detail_mode_system = """
You are a solo RPG GM in DETAIL MODE.

Rules:
- Generate 3-6 paragraphs (200-400 words)
- Honor player's exact words - build on, don't rewrite
- More sensory detail and "show don't tell"
- If player wrote dialogue, NPCs respond to those specific words
- Match player's narrative style

Token limit: 550
"""
```

**Testing Plan**:
1. Generate 50 Quick Mode responses across diverse actions
2. Measure: word count, paragraph count, quality (subjective)
3. Generate 50 Detail Mode responses with varied player inputs
4. Validate: AI honors player's words, appropriate length
5. Iterate on system prompts based on results

**Confidence**: MEDIUM-HIGH
- Token limits help constrain length
- Testing will reveal calibration needs
- Acceptable risk - can iterate post-MVP

---

### Challenge 3: Seamless Mode Switching

**Problem**: Transitioning between Quick and Detail Mode must preserve exact scene state without jarring UX.

**State to Preserve**:
- Current scene description
- Active NPCs (names, attitudes, states)
- Player character state (stress, aspects, conditions)
- Pending actions or threads
- Last narrated situation

**Technical Approach**:
```python
class SceneState:
    def __init__(self):
        self.description = ""
        self.npcs = []
        self.location = None
        self.aspects = []
        self.last_narrative = ""
        self.pending_threads = []
        self.mode = "quick"  # or "detail"

    def switch_mode(self, new_mode):
        """Preserve state during mode switch"""
        self.mode = new_mode
        # State is immutable - no data loss
        # Only UI presentation changes
```

**UX Considerations**:
1. Visual transition: Smooth animation (Quick Mode UI → Detail Mode UI)
2. Clear mode indicator: Header changes ("⚡Quick Mode" → "🎬 Detail Mode")
3. Context reminder: Show current situation at top of Detail Mode input
4. Exit prompt: "Exit Detail Mode?" when switching back

**Testing Plan**:
1. Test mode switch at various points in play
2. Verify scene state consistency before/after switch
3. User testing: Does transition feel natural or jarring?
4. Edge case: Switch mode mid-conflict (should be prevented)

**Confidence**: HIGH
- State management is straightforward (immutable state model)
- UX smoothness needs user testing but low technical risk

---

### Challenge 4: Real-time vs. Turn-based Processing

**Problem**: Should AI process actions in real-time (streaming) or batch (turn-complete)?

**Current Design** (from flows): Real-time with streaming

**Analysis**:

| Approach | Pros | Cons | Verdict |
|----------|------|------|---------|
| **Real-time streaming** | - Feels responsive<br>- User sees progress<br>- Reduces perceived latency | - More complex to implement<br>- Harder to rollback<br>- UI updates during stream | ✅ Recommended |
| **Batch (wait for complete)** | - Simpler implementation<br>- Easier rollback<br>- Clean UI state | - Feels slow (3-5s wait)<br>- User anxiety ("is it working?") | ❌ Worse UX |

**Recommended**: Real-time streaming with progressive reveal

**Implementation**:
```python
async def generate_narrative_stream(prompt, mode):
    """Stream AI response as it generates"""
    async for chunk in llm.stream(prompt):
        yield chunk  # Send to UI immediately

    # After complete, save full narrative to state
```

**UX Pattern**:
1. Show "Processing..." indicator immediately
2. Stream narrative paragraph by paragraph
3. Show "Continue" button when complete
4. Allow user to skip animation (click to reveal full text)

**Confidence**: MEDIUM-HIGH
- Streaming API available (Claude, OpenAI)
- Adds implementation complexity but better UX
- Test: Streaming reliability over slow networks

---

## 4. MVP Simplification Assessment

### Option A: Quick Mode Only for MVP

**What to Include**:
- ✅ Session start with AI recap
- ✅ Quick Mode core play loop (action buttons + custom text input)
- ✅ Dice rolling and rules enforcement
- ✅ AI narrative generation (2-4 paragraphs)
- ✅ Oracle consultation (Yes/No, Meaning, Inspiration)
- ✅ Conflict resolution (full Fate mechanics)
- ✅ Session end with summary and export

**What to Defer**:
- ❌ Detail Mode (expanded text input, longer narratives)
- ❌ Mode switching UI/UX
- ❌ Detail Mode-specific prompt engineering

**Technical Soundness**: HIGH ✅

**Rationale**:
1. **Validates core value prop**: AI GM + oracle + rules in one tool
2. **Reduces complexity**: Single interaction mode simplifies state management
3. **Faster MVP delivery**: Removes dual-mode architecture
4. **Addressable with custom text input**: Players can still write detailed actions in Quick Mode text field
5. **Clear iteration path**: Add Detail Mode post-MVP based on user feedback

**What We Learn from MVP**:
- Does Quick Mode feel too automated or appropriately helpful?
- Do users want more control (Detail Mode) or is Quick Mode sufficient?
- How often do users use custom text input vs action buttons?
- Is narrative length (2-4 paragraphs) appropriate?

**Risks of MVP Simplification**:
- **Medium Risk**: Morgan persona (journaler) might feel underserved
  - **Mitigation**: Custom text input allows detailed actions
  - **Data point**: Test with Morgan-like users, measure custom text usage
- **Low Risk**: Concept differentiation less clear without dual-mode
  - **Acceptable**: Quick Mode alone is still differentiated (AI + oracle + rules)

**Verdict**: Quick Mode MVP is technically sound and strategically wise

---

### Option B: Full Concept 3 (Quick + Detail Modes)

**What to Include**: Everything in Option A, PLUS:
- ✅ Detail Mode with expanded text input (up to 500 chars)
- ✅ Mode switching UI with smooth transitions
- ✅ Detail Mode-specific narrative generation (3-6 paragraphs)
- ✅ "Go deeper" prompts after story beats
- ✅ Mode preference tracking (learn user's preferred mode)

**Technical Soundness**: MEDIUM-HIGH ⚠️

**Rationale**:
1. **Delivers full vision**: Player-controlled pacing/fidelity
2. **Serves Morgan persona**: Detail Mode for important narrative moments
3. **Differentiates from competitors**: Unique hybrid approach
4. **Validates full concept**: Can test mode switching before committing

**Added Complexity**:
- Dual system prompts (Quick vs Detail)
- Context window management across modes
- State preservation during mode switches
- Mode switching UX (animations, indicators)
- Testing matrix doubles (test both modes + transitions)

**Estimated Additional Effort**: +30-40% over Quick Mode MVP (see estimates below)

**Risks of Full Concept**:
- **Medium Risk**: Detail Mode usage might be lower than expected
  - **Consequence**: Effort spent on rarely-used feature
- **Medium-High Risk**: Context window pressure (RT-04)
  - **Consequence**: Long campaigns might break down in Detail Mode
- **Low Risk**: Mode switching feels jarring
  - **Consequence**: Users stick to one mode, don't switch

**Verdict**: Full Concept 3 is feasible but riskier - recommend phased approach

---

### Recommendation: Phased Rollout

**Phase 1 (MVP)**: Quick Mode Only
- **Timeline**: 8-12 weeks for MVP (see estimates)
- **Delivers**: Core value prop (AI + oracle + rules)
- **Validates**: Narrative generation quality, rules consistency, context management basics
- **User testing**: Does Quick Mode meet user needs? Do they want more?

**Phase 2 (Post-MVP)**: Add Detail Mode
- **Timeline**: +4-6 weeks
- **Condition**: IF user feedback shows demand for more control
- **Delivers**: Full Concept 3 vision
- **Validates**: Mode switching UX, Detail Mode value, context management under pressure

**Why This Works**:
1. **De-risks MVP**: Simpler scope, faster validation
2. **Data-driven iteration**: Add Detail Mode based on user feedback, not assumption
3. **Technical soundness**: Quick Mode MVP proves architecture, Detail Mode builds on solid foundation
4. **Business value**: MVP ships sooner, can start user acquisition

**Confidence**: HIGH ✅

---

## 5. Updated Effort Estimates (T-Shirt Sizing)

### Quick Mode MVP (Recommended)

| Component | Size | Confidence | Key Factors | Risks |
|-----------|------|------------|-------------|-------|
| **Session Start Flow** | S | High | Standard CRUD + AI recap | AI recap quality (RT-01) |
| **Core Play Loop (Quick Mode)** | M | High | Action generation, narrative, state updates | Narrative calibration (RT-02) |
| **Oracle Consultation** | S | High | Mythic GME implementation (tables + dice) | None |
| **Conflict Resolution** | L | Medium | Multi-exchange state management, AI tactics | State complexity (RT-06), AI behavior (RT-07) |
| **Session End Flow** | S | High | Summary, stats, export | Export quality validation |
| **Rules Encoding (Fate)** | M | Medium-High | Hybrid Python + RAG implementation | Rules consistency (T2) |
| **State Persistence** | M | High | SQLite + ChromaDB integration | Database design, backups |
| **Context Management** | M | Medium | Hierarchical memory, vector search | Long campaign validation (T5) |
| **UI/UX (Quick Mode)** | M | High | Tauri + React, responsive design | None |
| **LLM Integration** | M | High | Microsoft Agent Framework + Claude API | API stability |

**Total Estimate**: **M-L** (8-12 weeks with 1 full-time dev)

**Breakdown**:
- Core engine (rules, state, oracle): 3-4 weeks
- LLM integration and context management: 2-3 weeks
- UI/UX (Quick Mode): 2-3 weeks
- Testing and polish: 1-2 weeks

**Confidence**: MEDIUM-HIGH
- Straightforward architecture
- Well-defined flows
- Some unknowns in AI calibration and context management

---

### Full Concept 3 (Quick + Detail Modes)

| Component | Size | Confidence | Key Factors | Risks |
|-----------|------|------------|-------------|-------|
| **All Quick Mode MVP components** | M-L | Medium-High | See above | See above |
| **Detail Mode Implementation** | M | Medium | Expanded input, longer narratives | Context window pressure (RT-04) |
| **Mode Switching Logic** | S | High | State preservation, UI transitions | State consistency |
| **Dual Prompt Engineering** | M | Medium | Calibrate Quick vs Detail narratives | Requires extensive testing |
| **Mode Preference Tracking** | S | High | Learn user's preferred mode | None |
| **Additional Testing** | M | Medium | Test both modes + transitions | Doubles testing matrix |

**Total Estimate**: **L-XL** (12-18 weeks with 1 full-time dev)

**Added Effort over Quick Mode MVP**: +4-6 weeks (30-40% increase)

**Breakdown**:
- Quick Mode MVP: 8-12 weeks
- Detail Mode implementation: 2-3 weeks
- Dual-mode integration and testing: 2-3 weeks

**Confidence**: MEDIUM
- Detail Mode adds significant complexity
- Context window management needs validation
- Testing matrix doubles (both modes + transitions)

---

### Estimation Assumptions

**Included**:
- 1 full-time developer (full-stack: Python backend + React frontend)
- Fate Accelerated rules only (not D&D 5e)
- Desktop app only (not mobile)
- Cloud LLM (Claude/OpenAI) - not local LLM support
- Basic UI/UX (functional, not polished)

**NOT Included**:
- Multiple RPG systems support (plugin architecture designed, but only Fate implemented)
- Cloud sync (local-only for MVP)
- Mobile app (desktop only)
- Local LLM support (Ollama integration)
- Advanced analytics/telemetry
- Onboarding tutorial

**Estimates Could Change IF**:
- Rules consistency (T2) proves harder than expected (+2-4 weeks)
- Context management (T5) needs major rework (+2-3 weeks)
- UI/UX requires significant iteration (add polish time)
- Testing reveals major issues (add debugging time)

---

## 6. Recommendations

### Technical Approach Refinements

#### 1. Context Management Strategy
**Issue**: Detail Mode increases context consumption

**Recommendation**:
- Implement hierarchical memory from day one (working + session + archival)
- Set context budget limits per mode:
  - Quick Mode: Max 30k tokens for working memory
  - Detail Mode: Max 35k tokens for working memory (5k buffer)
- Monitor context usage in real-time, warn user if approaching limits
- Test with synthetic long campaigns (50+ sessions, varied mode usage)

**Why**: Proactive context management prevents late-stage surprises

---

#### 2. Prompt Engineering Approach
**Issue**: AI must calibrate narrative length for both modes

**Recommendation**:
- Define token limits explicitly in system prompts (Quick: 350, Detail: 550)
- Use temperature settings per mode:
  - Quick Mode: temperature 0.7 (balanced, efficient)
  - Detail Mode: temperature 0.8 (more creative, descriptive)
- Test prompt variations with 50+ samples per mode
- Iterate based on qualitative feedback (user testing)

**Why**: Upfront testing reduces post-launch calibration issues

---

#### 3. State Management Design
**Issue**: Mode switching and conflict tracking require robust state model

**Recommendation**:
```python
# Immutable state pattern
class GameState:
    def __init__(self):
        self.character = CharacterState()
        self.scene = SceneState()
        self.campaign = CampaignState()
        self.mode = "quick"  # or "detail"

    def with_changes(self, **kwargs):
        """Return new state with changes (immutable)"""
        new_state = copy.deepcopy(self)
        for key, value in kwargs.items():
            setattr(new_state, key, value)
        return new_state
```

- Use immutable state pattern (functional programming style)
- Every action creates new state (no in-place mutations)
- Easy rollback (keep history of states)
- Clear debugging (state transitions are explicit)

**Why**: Immutable state prevents bugs, simplifies mode switching and rollback

---

#### 4. Rules Encoding Pattern
**Issue**: Fate rules must be consistent across sessions (T2)

**Recommendation**:
- Encode all core mechanics as Python tools (not AI interpretation):
  ```python
  # Tools the AI MUST call (not interpret)
  - resolve_action(approach, difficulty, bonus) → outcome
  - apply_stress(target, shifts) → stress_state
  - create_aspect(type, name, invokes) → aspect
  ```
- Use RAG only for edge cases and flavor ("What does Flashy approach look like?")
- Version lock rules per campaign (rule changes don't affect ongoing campaigns)
- Log all rules calls for debugging and validation

**Why**: Separates mechanical consistency (code) from narrative flexibility (AI)

---

### Spikes Needed Before Implementation

#### Spike 1: Context Management with Detail Mode (High Priority)
**Goal**: Validate context window management with mixed Quick/Detail Mode usage

**Tasks**:
1. Simulate 50-session campaign with 30% Detail Mode usage
2. Measure context consumption per mode
3. Test vector search retrieval quality (does AI recall old events?)
4. Validate summarization quality (does summary lose important details?)

**Success Criteria**:
- Context stays within 128k window for 50+ sessions
- AI recalls important events from 20+ sessions ago
- Summaries capture key plot points and decisions

**Effort**: 1-2 weeks
**Addresses**: RT-04 (context window pressure), T5 (long campaign management)

**Recommendation**: REQUIRED before committing to full Concept 3

---

#### Spike 2: Fate Rules Encoding and Consistency (Medium Priority)
**Goal**: Validate hybrid rules approach (Python + RAG)

**Tasks**:
1. Implement Fate Accelerated core mechanics (approaches, actions, outcomes)
2. Encode rules as Python tools
3. Create RAG corpus from Fate rulebook
4. Test AI rules application across 20 diverse scenarios
5. Measure consistency (does AI apply rules same way each time?)

**Success Criteria**:
- AI correctly interprets player actions → appropriate mechanics
- Dice rolls and outcomes follow Fate rules exactly
- Edge cases handled correctly (AI retrieves rules via RAG)

**Effort**: 1 week
**Addresses**: T2 (rules consistency), RT-02 (rules interpretation)

**Recommendation**: REQUIRED for MVP (validate technical approach)

---

#### Spike 3: AI Narrative Calibration (Medium Priority)
**Goal**: Calibrate AI narrative length and quality for Quick Mode

**Tasks**:
1. Generate 50 Quick Mode narratives across diverse actions
2. Measure word count, paragraph count, readability
3. Qualitative review: Does narrative feel rushed? Too verbose? Just right?
4. Test with users (if possible): Is length appropriate?
5. Iterate on system prompt based on results

**Success Criteria**:
- 90% of narratives fall within 100-250 words
- Narratives feel complete (cover action, outcome, next situation)
- User feedback: Narrative length is appropriate

**Effort**: 3-5 days
**Addresses**: RT-02 (narrative calibration)

**Recommendation**: Recommended before MVP launch (but can iterate post-launch)

---

### Risk Mitigations

#### RT-01: AI Recap Quality (Medium Risk)
**Mitigation**:
- User-curated "pins" (important facts user marks as critical)
- Include thread priority scoring (user marks which threads are active)
- Test recaps with diverse campaign types (fantasy, sci-fi, mystery)
- Allow user to edit/regenerate recap

**Contingency**: Manual recap option (user writes their own)

---

#### RT-02: Narrative Length Calibration (Medium Risk)
**Mitigation**:
- Token limits in system prompts (Quick: 350, Detail: 550)
- Test with 50+ samples per mode
- User setting: "Concise" vs "Descriptive" preference
- Regenerate option if unsatisfactory

**Contingency**: User can manually edit narrative

---

#### RT-03: Action Button Quality (Medium Risk)
**Mitigation**:
- Always provide custom text input option
- Learn from user's custom action frequency (if >50%, improve button generation)
- Test action generation with diverse scene types
- Avoid repetition (track recent actions)

**Contingency**: Custom text input is primary path if buttons fail

---

#### RT-04: Context Window Pressure in Detail Mode (Medium-High Risk)
**Mitigation**:
- Hierarchical memory with aggressive summarization
- Monitor context usage, warn user if approaching limits
- Test with synthetic long campaigns (50+ sessions, high Detail Mode usage)
- Optimize context retrieval (only top 3-5 archival chunks)

**Contingency**: Suggest Quick Mode when context budget tight, or prompt user to archive old sessions

**Status**: REQUIRES SPIKE to validate

---

#### RT-05: Player Input Misinterpretation in Detail Mode (Medium Risk)
**Mitigation**:
- Show "(Interpreted as [approach])" note
- Offer "Try differently?" regeneration
- Learn from user corrections
- Log misinterpretations for model tuning

**Contingency**: User can edit/override AI response

---

#### RT-06: Conflict Mode Complexity (Medium Risk)
**Mitigation**:
- Clear data model (immutable state pattern)
- Extensive testing of edge cases (multi-round, multi-opponent)
- Rollback capability (undo last exchange)
- Test with diverse conflict types (combat, debate, chase)

**Contingency**: User can manually resolve conflict (skip conflict mode)

---

#### RT-07: AI Opponent Behavior (Medium Risk)
**Mitigation**:
- Personality-driven tactics (cowardly vs brave)
- Randomness in decision-making (not purely optimal)
- Test diverse opponent types
- Log opponent decisions for review

**Contingency**: User can override opponent action if illogical

---

## 7. Final Recommendations

### For MVP Development

1. **Start with Quick Mode only** ✅
   - Validates core value prop with lower complexity
   - Faster time to user feedback
   - Proves architecture before adding Detail Mode

2. **Prioritize spikes** ✅
   - Spike 2 (Fate rules encoding) REQUIRED before MVP
   - Spike 3 (narrative calibration) RECOMMENDED before MVP
   - Spike 1 (context management) REQUIRED before adding Detail Mode

3. **Use phased rollout** ✅
   - Phase 1: Quick Mode MVP (8-12 weeks)
   - Validate with users: Do they want more control?
   - Phase 2: Add Detail Mode if validated (4-6 weeks)

4. **Focus on core flows** ✅
   - Session Start → Core Play Loop → Session End
   - Oracle and Conflict are important but secondary
   - Get the core loop right first

5. **Design for iteration** ✅
   - Immutable state pattern (easy rollback)
   - Modular architecture (add Detail Mode later)
   - Extensive logging (debug AI behavior)
   - A/B testing capability (compare prompt variations)

### For Technical Architecture

1. **Use recommended tech stack** ✅
   - Tauri + Python + Microsoft Agent Framework
   - SQLite + ChromaDB for persistence
   - Claude API (or OpenAI) for LLM
   - Hybrid rules encoding (Python tools + RAG)

2. **Implement hierarchical memory from day one** ✅
   - Working memory (recent turns)
   - Session memory (summarized)
   - Archival memory (vector search)
   - Prevents context window issues down the road

3. **Separate mechanics from narrative** ✅
   - Dice rolls and rules in Python (consistent)
   - AI generates narrative only (flexible)
   - Clear separation reduces rules inconsistency risk

4. **Stream AI responses** ✅
   - Better UX (progressive reveal)
   - Lower perceived latency
   - User can skip animation

### For User Testing (Phase 4)

**Key Validation Questions**:
1. Does Quick Mode feel too automated or appropriately helpful?
2. Is narrative length (2-4 paragraphs) appropriate?
3. Do users want Detail Mode, or is Quick Mode sufficient?
4. Is AI recap quality good enough for session resumption?
5. Are action buttons useful, or do users prefer custom text input?
6. Does conflict resolution feel tactical or tedious?
7. Is export format (Markdown) suitable for journaling?

**Test Scenarios**:
- 3-5 users play 2-3 sessions each (total 6-15 sessions)
- Mix of: Quick Mode heavy vs custom text input heavy
- Test: Session start resumption after 1 week gap
- Measure: Mode usage, narrative satisfaction, export usage

---

## 8. Conclusion

### Summary

**Concept 3 (Hybrid / Director's Cut) is technically feasible** with the recommended architecture. The dual-mode approach adds complexity but is achievable.

**Quick Mode MVP is strongly recommended**:
- Delivers core value prop with lower risk
- Validates technical approach before adding Detail Mode
- Faster time to user feedback
- Clear iteration path based on user demand

**Detail Mode can be added post-MVP** if user testing shows demand for more control.

### Technical Confidence Levels

| Component | Feasibility | Confidence | Critical Risks |
|-----------|-------------|------------|----------------|
| **Session Start** | High | High | AI recap quality (mitigatable) |
| **Core Play Loop (Quick)** | High | High | Narrative calibration (mitigatable) |
| **Detail Mode** | Medium-High | Medium | Context window pressure (needs spike) |
| **Oracle Consultation** | High | High | None |
| **Conflict Resolution** | Medium-High | Medium-High | State complexity (manageable) |
| **Session End** | High | High | Export format (testable) |
| **Rules Encoding** | Medium-High | Medium-High | Consistency (needs spike) |
| **Context Management** | Medium | Medium | Long campaigns (needs spike) |

### Overall Recommendation

**BUILD Concept 3 with phased rollout:**
1. **Phase 1**: Quick Mode MVP (8-12 weeks) - Validate core concept
2. **User Testing**: Gather feedback on control needs
3. **Phase 2**: Add Detail Mode if validated (4-6 weeks) - Complete vision

**Spikes Required**:
- Fate rules encoding (1 week) - BEFORE MVP
- Context management (1-2 weeks) - BEFORE Detail Mode
- Narrative calibration (3-5 days) - RECOMMENDED before MVP

**Final Confidence**: MEDIUM-HIGH ✅
- Quick Mode MVP is HIGH feasibility
- Full Concept 3 is MEDIUM-HIGH feasibility (depends on Detail Mode validation)
- No showstoppers identified
- Risks are mitigatable with spikes and testing

---

**Review prepared by**: @tech-lead
**Date**: 2025-12-09
**Next steps**:
1. Review with @business-analyst (requirements definition)
2. Conduct required spikes (Fate rules, context management)
3. User validation (Phase 4) with Quick Mode prototype
4. Decision point: Add Detail Mode based on user feedback
