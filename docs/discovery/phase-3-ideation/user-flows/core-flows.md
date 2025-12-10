# Core User Flows: Solo RPG App (Hybrid Concept)

**Project**: Solo RPG App
**Phase**: Phase 3 - Ideation
**Concept**: Concept 3 - The Director's Cut (Hybrid)
**Date**: 2025-12-09
**Created by**: @ux-designer

---

## Overview

This document defines the core user flows for the hybrid interaction model, where players can quickly direct scenes with shorthand actions (Quick Mode) or dive into detailed narrative input (Detail Mode) for important moments.

**Key principle**: Player controls pacing and fidelity - fast-forward routine actions, slow down for story beats.

---

## Flow 1: Session Start (Resume Campaign)

### Overview
- **User**: Alex (Narrative Explorer) - primary persona
- **Goal**: Resume an existing campaign and begin playing with minimal friction
- **Entry point**: App launch or campaign selection screen
- **Success state**: Player is actively engaged in play within 30 seconds

---

### Flow Diagram

```
[Launch App]
     |
     v
┌─────────────┐
│ Campaign    |
│ List        |
└─────┬───────┘
      |
      v
  ◇ Campaign exists?
 /              \
No              Yes
|                |
v                v
[New Campaign]  [Select Campaign]
(Flow 1b)        |
                 v
            ┌─────────────┐
            │ Load Session|
            │ + AI Recap  |
            └─────┬───────┘
                  |
                  v
            ┌─────────────┐
            │ Scene Check |
            │ (Mythic GME)|
            └─────┬───────┘
                  |
                  v
            ◇ Scene altered?
           /              \
         No                Yes
         |                 |
         v                 v
    Expected scene    Altered scene
         |                 |
         └────────┬────────┘
                  |
                  v
            ┌─────────────┐
            │ Scene Setup |
            │ (Quick Mode)|
            └─────┬───────┘
                  |
                  v
            [Ready to Play]
            (Flow 2)
```

---

### Step Details

#### Step 1: Launch App
- **Screen/Location**: App home / campaign dashboard
- **User Action**: Taps app icon or returns to open app
- **System Response**:
  - Shows campaign list if multiple campaigns exist
  - OR loads last active campaign directly
- **Data Required**:
  - User's campaign list
  - Last active campaign ID
  - Last active session state
- **Error States**:
  - No campaigns exist -> Show "Create Campaign" onboarding
  - Corrupted campaign data -> Show error + option to restore backup

#### Step 2: Select Campaign
- **Screen/Location**: Campaign list screen
- **User Action**: Taps campaign card/row
- **System Response**:
  - Shows loading indicator
  - Begins loading campaign state in background
- **Data Required**:
  - Campaign ID
  - Campaign metadata (name, last played date, current scene)
- **Error States**:
  - Campaign fails to load -> Show error message, offer retry
  - Network error (if cloud sync) -> Load last local state, show sync warning

#### Step 3: Load Session + AI Recap
- **Screen/Location**: Session transition screen / main play interface
- **User Action**: Reads AI-generated recap (passive)
- **System Response**:
  - AI generates 2-3 paragraph recap: "Previously: [last scene summary]. Your goal: [active threads]. You are: [current location/situation]."
  - Loads full game state (character, NPCs, threads, chaos factor)
  - Shows "Continue" button when ready
- **Data Required**:
  - Previous scene notes
  - Active threads/plot points
  - Character state
  - Current chaos factor
- **Error States**:
  - AI recap fails to generate -> Show last scene notes instead
  - Incomplete session state -> Warn user, offer to reconstruct or reload previous good state

**Design note**: Recap is non-blocking - advanced users can skip immediately to scene setup.

#### Step 4: Scene Check (Mythic GME)
- **Screen/Location**: Scene setup interface
- **User Action**: Reviews expected scene, may click "Details" to see chaos factor/roll
- **System Response**:
  - Shows expected scene briefly: "Scene: Enter the city gates"
  - Performs Mythic GME scene check (d10 vs chaos factor)
  - Shows result:
    - "Scene proceeds as expected" (most common)
    - "Scene is altered" + AI suggestion for how
    - "Scene is interrupted" + AI suggestion for interrupt
  - Advances automatically after 2-3 seconds (can be expanded for detail)
- **Data Required**:
  - Expected scene description
  - Current chaos factor
  - Campaign context for generating alterations
- **Error States**:
  - Scene generation fails -> Use expected scene without alteration
  - Invalid chaos factor -> Reset to default (5)

**Design note**: This step is deliberately quick - most scenes proceed as expected. Power users can expand to see the oracle mechanics.

#### Step 5: Scene Setup (Quick Mode)
- **Screen/Location**: Main play interface in Quick Mode
- **User Action**: Reads scene description
- **System Response**:
  - Displays scene description (2-4 paragraphs)
  - Lists NPCs present (if any)
  - Shows 3-4 contextual quick action buttons
  - Shows text input option
  - Displays "Switch to Detail Mode" option
- **Data Required**:
  - Scene description (from expected scene or AI generation)
  - Active NPCs in scene
  - Current threads (shown in sidebar/footer)
  - Character state
- **Error States**:
  - Scene description fails to generate -> Show generic scene prompt + allow player to describe
  - Action buttons fail to generate -> Show text input only

#### Step 6: Ready to Play
- **Screen/Location**: Main play interface
- **User Action**: Selects first action (flow continues to Flow 2)
- **System Response**: See Flow 2 (Core Play Loop)
- **Data Required**: N/A - transitioning to active play
- **Error States**: N/A

---

### Alternative Paths

#### Path A: New Campaign (First Time)
If player has no campaigns or creates new:
1. App shows "Create Campaign" wizard
2. Player enters campaign name
3. Player selects RPG system (Fate Accelerated, D&D 5E variant, etc.)
4. Player creates or imports character
5. Player sets initial scene prompt or uses AI suggestion
6. Proceeds to Step 4 (Scene Check)

#### Path B: Quick Resume (Returning User)
If player closed app mid-session (abnormal exit):
1. App detects unsaved session state
2. Shows prompt: "Resume where you left off?"
3. If yes: Loads exact state (skips recap and scene check)
4. If no: Proceeds to normal session start (Step 3)

#### Path C: Scene-less Resume
If player ended last session cleanly (between scenes):
1. Recap shows campaign status
2. Player prompted to define next expected scene OR let AI suggest
3. Proceeds to Step 4 (Scene Check) with new expected scene

---

### Edge Cases

**Long time since last session** (>7 days):
- Recap is more detailed (4-5 paragraphs covering more history)
- AI highlights forgotten threads
- Suggest "Review Campaign" option before playing

**Campaign at critical story moment**:
- Recap emphasizes the stakes
- Auto-suggests Detail Mode for first action

**No active threads**:
- AI suggests potential new threads based on scene
- Prompt player: "What's your goal here?"

**Technical: Offline mode**:
- If no network, uses last cached campaign state
- Shows indicator: "Playing offline - sync when connected"
- AI features degraded but core play still works

---

### Notes for Implementation

**Performance targets**:
- Campaign list load: <500ms
- Session state load: <1s
- AI recap generation: <3s (can show partial results as streaming)
- Scene check + setup: <2s

**AI prompt engineering**:
- Recap should focus on: immediate situation, active goals, recent events
- Avoid generic summaries - be specific to player's campaign
- Tone should match campaign genre and player's prior narration style

**Accessibility**:
- Recap can be read aloud (text-to-speech)
- Skip recap button clearly visible
- Quick action buttons keyboard-navigable

**State management**:
- Auto-save after every scene resolution
- Maintain last 10 session states for rollback
- Cloud sync optional but recommended

---

## Flow 2: Core Play Loop (Quick Mode)

### Overview
- **User**: Alex (Narrative Explorer)
- **Goal**: Take actions, resolve them, and advance the story efficiently
- **Entry point**: Active scene with Quick Mode enabled (default)
- **Success state**: Action resolves, story progresses, player remains engaged

---

### Flow Diagram

```
[Scene Active]
     |
     v
┌─────────────────┐
│ Player sees:    │
│ - Scene context │
│ - Quick actions │
│ - Custom input  │
└────────┬────────┘
         |
         v
    ◇ Action type?
   /      |      \
Quick   Custom   Oracle
Action  Action   Query
  |       |        |
  v       v        v
[Button] [Type]  [Flow 4]
  |       |
  └───┬───┘
      |
      v
┌─────────────────┐
│ AI interprets   │
│ action intent   │
└────────┬────────┘
         |
         v
    ◇ Roll needed?
   /            \
 Yes             No
  |              |
  v              v
Roll dice    Skip roll
  |              |
  └──────┬───────┘
         |
         v
┌─────────────────┐
│ AI narrates     │
│ outcome         │
│ (2-4 paragraphs)│
└────────┬────────┘
         |
         v
    ◇ Major story beat?
   /                \
 Yes                No
  |                  |
  v                  v
[Offer Detail]  [Continue button]
Mode option          |
  |                  |
  v                  v
Detail Mode      Next action
(Flow 2b)        (loop back)
```

---

### Step Details

#### Step 1: Present Action Options
- **Screen/Location**: Main play interface (Quick Mode)
- **User Action**: Reviews available actions
- **System Response**:
  - Displays scene context at top
  - Shows 3-4 contextual quick action buttons:
    - Example: "Talk past guards", "Sneak around", "Wait and observe"
  - Each button shows what approach it uses (e.g., "Clever roll")
  - Shows text input field: "Or describe your own action..."
  - Shows secondary actions: "Ask Oracle", "Switch to Detail Mode", "End Scene"
- **Data Required**:
  - Current scene state
  - Available approaches (based on character abilities)
  - Recent action history (to avoid repetitive suggestions)
- **Error States**:
  - Action generation fails -> Show generic actions (Investigate, Talk, Act, Wait) + custom input
  - Invalid scene state -> Prompt player to describe what they want to do

**Design note**: Action buttons are dynamic - change based on context. If player is in combat, show "Attack", "Defend", "Maneuver". If in dialogue, show "Persuade", "Intimidate", "Question".

#### Step 2: Player Selects Action
- **Screen/Location**: Same screen
- **User Action**:
  - Taps quick action button, OR
  - Types custom action (20-100 characters), OR
  - Taps "Ask Oracle" (goes to Flow 4)
- **System Response**:
  - Quick action: Highlights selected button, shows "Processing..." indicator
  - Custom action: Shows "Processing..." indicator
  - Both: Begins AI interpretation of intent
- **Data Required**:
  - User's selected action or custom text
  - Current scene context
  - Character abilities
- **Error States**:
  - Empty custom action -> Prompt "What do you want to do?"
  - Ambiguous custom action -> AI makes best interpretation, offers "Redo" option after result

#### Step 3: AI Interprets Intent
- **Screen/Location**: Same screen (processing)
- **User Action**: Waits (passive)
- **System Response**:
  - AI analyzes action intent
  - Determines which game mechanic applies:
    - Fate: Which approach (Careful, Clever, Flashy, etc.) and action (Overcome, Create Advantage, Attack, Defend)
    - OR no roll needed (simple observation, safe action)
  - Determines difficulty (for rolls)
  - Determines if oracle consultation needed (surprise element)
- **Data Required**:
  - Action description
  - Game system rules
  - Current opposition/difficulty factors
  - Chaos factor (for potential complications)
- **Error States**:
  - AI interpretation fails -> Default to most common mechanic (Overcome with most relevant approach)
  - Rules ambiguity -> AI makes judgment, shows "(Interpreted as...)" note

**Design note**: This step happens in <1s and is mostly invisible to user. Only surface level shown is "Processing..."

#### Step 4: Determine if Roll Needed
- **Screen/Location**: Same screen
- **User Action**: None (automatic)
- **System Response**:
  - If roll needed: Proceeds to Step 5
  - If no roll needed: Skips to Step 6 with automatic success
- **Data Required**:
  - Action interpretation result
  - Game rules (which actions require rolls)
- **Error States**: None (deterministic based on rules)

#### Step 5: Roll Dice (If Needed)
- **Screen/Location**: Same screen with roll visualization
- **User Action**: Watches roll (passive) or taps to skip animation
- **System Response**:
  - Shows brief roll visualization:
    - "Rolling Clever (Overcome) - Difficulty: Fair (+2)"
    - Animated dice: "4dF+3 = +4 (rolled +1)"
    - Result: "Success!" with visual indicator (green checkmark)
  - Calculates outcome:
    - Success with style (3+ over target)
    - Success
    - Tie
    - Failure
  - Determines narrative consequences
- **Data Required**:
  - Character bonus for used approach
  - Target difficulty
  - Random roll result
  - Game rules for interpreting results
- **Error States**:
  - Dice roll fails -> Retry automatically
  - Invalid bonus/difficulty -> Use default values, log error

**Design note**: Roll animation is quick (1-2 seconds). Power users can disable animations in settings.

#### Step 6: AI Narrates Outcome
- **Screen/Location**: Same screen, narrative appears below action
- **User Action**: Reads narrative (passive)
- **System Response**:
  - Displays arrow indicator: "▶ You try to talk your way past the guards"
  - Shows roll result (if there was one)
  - Displays AI-generated narrative (2-4 paragraphs):
    - What the player character does
    - How NPCs/environment reacts
    - Outcome of the action
    - What happens next / new situation
  - Updates scene state (NPC attitudes, environment changes, etc.)
  - Updates character state if needed (stress boxes, aspects, etc.)
- **Data Required**:
  - Action description
  - Roll result (if any)
  - Scene context
  - NPC personalities/motivations
  - Campaign tone and style
- **Error States**:
  - Narrative generation fails -> Show basic outcome description, offer "Regenerate" button
  - Narrative too short/long -> Auto-adjust, but log for model tuning

**AI prompt engineering notes**:
- Narrative should be player-character focused (not omniscient)
- Include sensory details and NPC reactions
- Leave some uncertainty for next beat
- Match tone of previous narration
- For success with style, include extra beneficial detail
- For failure, introduce complication (not just "it doesn't work")

#### Step 7: Check for Major Story Beat
- **Screen/Location**: Same screen
- **User Action**: None (automatic detection)
- **System Response**:
  - AI evaluates if this is a significant story moment:
    - First encounter with major NPC
    - Revelation of plot information
    - Character decision with lasting consequences
    - Combat with named enemy
  - If yes: Proceeds to Step 8
  - If no: Proceeds to Step 9
- **Data Required**:
  - Action outcome
  - Campaign context (what's narratively significant)
  - Recent action history (to avoid over-flagging)
- **Error States**: None (binary decision, defaults to "No")

**Design note**: This detection helps prompt players to use Detail Mode for important moments. Threshold should be calibrated to suggest ~1-2 times per session, not every action.

#### Step 8: Offer Detail Mode (For Story Beats)
- **Screen/Location**: Same screen, option appears after narrative
- **User Action**:
  - Taps "Go deeper: [specific prompt]" button, OR
  - Taps "Continue" to stay in Quick Mode
- **System Response**:
  - Shows suggestion: "⚙ Go deeper: What exactly did you say to convince them?"
  - If accepted: Transitions to Detail Mode (Flow 2b)
  - If declined: Proceeds to Step 9 (Continue)
- **Data Required**:
  - Context of what could be elaborated
  - Appropriate prompt for detail expansion
- **Error States**: None

**Design note**: This is a gentle nudge, not a forced transition. Player always has agency to continue in Quick Mode.

#### Step 9: Continue to Next Beat
- **Screen/Location**: Same screen, refreshed with new situation
- **User Action**: Clicks "Continue" button
- **System Response**:
  - Updates scene description based on outcome
  - Generates new quick action buttons (contextual to new situation)
  - Checks if scene should end (natural conclusion reached)
  - If scene continues: Loop back to Step 1
  - If scene ends: Transitions to Flow 5 (Session End)
- **Data Required**:
  - Updated scene state
  - Active threads
  - Scene progress indicators
- **Error States**:
  - Scene state becomes inconsistent -> AI attempts to reconcile, or prompts player "What happens next?"

---

### Alternative Paths

#### Path A: Custom Action Requires Clarification
If player's custom action is ambiguous:
1. AI narrates attempt with best interpretation
2. Shows "(Interpreted as [approach])" note
3. Offers "Try differently?" button after result
4. If clicked, player can refine and re-attempt

#### Path B: Action Triggers Oracle
If action creates uncertainty (e.g., "Is there a guard in the tower?"):
1. System detects question in action
2. Automatically consults oracle (Flow 4, but embedded)
3. Returns answer in narrative
4. Continues with action resolution

#### Path C: Action Results in Combat
If action initiates conflict (Flow 3):
1. After outcome narration, system detects conflict state
2. Shows "Enter Conflict Mode" transition
3. Proceeds to Flow 3 (Combat/Conflict Flow)

---

### Edge Cases

**Player enters extremely long custom action** (>200 chars):
- Accept input but prompt: "That's a lot! Consider Detail Mode for complex actions."
- Offer to switch to Detail Mode

**Action impossible given scene state**:
- AI narrates why: "You reach for your sword, but remember you surrendered it at the gates."
- Offers alternative actions

**Player wants to undo action**:
- Before resolution: "Cancel" button available
- After resolution: "Rewind" option (limited to last action, not entire scene)

**AI generates inappropriate content**:
- Content filter catches it
- Shows generic outcome + "Regenerate" button
- Logs incident for review

**Narrative contradicts established facts**:
- Player can tap "Flag error" on any narrative paragraph
- Provides feedback form
- Allows manual edit of that paragraph

---

### Notes for Implementation

**AI Response Time Targets**:
- Action interpretation: <500ms
- Roll calculation: Instant
- Narrative generation: <3s (stream results as they generate)
- Action button generation: <1s

**Quick Action Button Logic**:
- Generate 3-4 options covering different approaches/tones
- At least one "safe" option (low risk)
- At least one "interesting" option (pushes story forward)
- Avoid repetition of recent actions
- Match player's historical preferences over time

**Narrative Style Calibration**:
- Learn from player's Detail Mode inputs (when they elaborate, match that style)
- Track player preference: concise vs descriptive
- Adjust paragraph count based on action significance

**State Management**:
- Auto-save after every action resolution
- Maintain action history (unlimited for session, summarized for long-term storage)
- Track all scene state changes for potential rollback

**Performance Optimization**:
- Pre-generate next action buttons while player reads narrative
- Cache common roll results
- Optimize AI prompts for speed vs quality trade-off

---

## Flow 2b: Detail Mode (Opt-in)

### Overview
- **User**: Alex, when reaching an important story moment OR Morgan (Journaler persona)
- **Goal**: Provide detailed input for a specific action to create richer narrative
- **Entry point**: Player switches from Quick Mode, or accepts "Go deeper" prompt
- **Success state**: Detailed narrative generated that honors player's specific vision

---

### Flow Diagram

```
[Quick Mode Active]
     |
     v
◇ How to enter Detail?
/                    \
Player              System
switches           suggests
manually           (story beat)
|                      |
v                      v
[Tap Detail Mode button]
        |
        v
┌─────────────────┐
│ Interface       │
│ transitions to  │
│ Detail Mode     │
└────────┬────────┘
         |
         v
┌─────────────────┐
│ Expanded text   │
│ input appears   │
└────────┬────────┘
         |
         v
┌─────────────────┐
│ Player writes   │
│ detailed action │
│ or dialogue     │
└────────┬────────┘
         |
         v
    ◇ Complete?
   /          \
 Yes           No (editing)
  |             |
  v             └──┐
┌─────────────┐   |
│ Select      │   |
│ approach    │   |
│ (if needed) │   |
└────────┬────┘   |
         |        |
         v        |
┌─────────────┐   |
│ Submit      │   |
│ detailed    │   |
│ action      │   |
└────────┬────┘   |
         |        |
         v        |
[Resolution - same as Quick Mode]
         |
         v
    ◇ Stay in Detail?
   /              \
 Yes               No
  |                |
  v                v
Loop back    [Exit Detail Mode]
to input     Return to Quick Mode
```

---

### Step Details

#### Step 1: Enter Detail Mode
- **Screen/Location**: Transition from Quick Mode interface
- **User Action**:
  - Taps "Switch to Detail Mode" button, OR
  - Accepts "Go deeper" prompt after story beat
- **System Response**:
  - Smooth visual transition (Quick Mode UI elements fade/slide)
  - Header changes: "⚡Quick Mode" -> "🎬 Detail Mode"
  - Text input expands to larger text area (5-10 lines visible)
  - Quick action buttons fade out (still accessible via "Quick actions..." button)
  - Shows context reminder at top (current scene situation)
- **Data Required**:
  - Current scene state
  - Last narrated situation (context for what to elaborate)
  - If triggered by "Go deeper", specific prompt to answer
- **Error States**: None (UI transition only)

**Design note**: Transition should feel like "zooming in" on the moment, not switching to a different app.

#### Step 2: Present Expanded Input
- **Screen/Location**: Detail Mode interface
- **User Action**: Sees expanded writing space
- **System Response**:
  - Shows large text area with placeholder based on context:
    - From "Go deeper" prompt: "What exactly did you say to convince them?"
    - From manual switch: "Describe your action in detail..."
  - Shows character limit indicator (0/500 characters)
  - Shows approach selector dropdown (Careful, Clever, Flashy, etc.)
  - Shows "Send" button (primary) and "Exit Detail Mode" (secondary)
  - Shows optional "Markdown formatting" help tooltip
- **Data Required**:
  - Context for placeholder text
  - Character's available approaches
- **Error States**: None

#### Step 3: Player Writes Detailed Input
- **Screen/Location**: Same screen
- **User Action**:
  - Types detailed description of action, dialogue, or internal thoughts
  - Optionally selects specific approach (if not, AI infers)
  - May edit and revise text
- **System Response**:
  - Character count updates in real-time
  - Auto-saves draft every 10 seconds (restored if app closes)
  - Shows warning if approaching character limit
  - Enable "Send" button once minimum text entered (20+ chars)
- **Data Required**:
  - Player's text input (saved to draft state)
  - Selected approach (optional)
- **Error States**:
  - Text too short (<20 chars) -> "Send" button disabled
  - Text exceeds limit (>500 chars) -> Prevent further input, show "Consider splitting into multiple actions"

**Design note**: This is the core creative space for player expression. Should feel like journaling, not form-filling.

#### Step 4: Submit Detailed Action
- **Screen/Location**: Same screen
- **User Action**: Taps "Send" or presses Ctrl+Enter
- **System Response**:
  - Saves player's exact text (for export/journaling purposes)
  - Shows "Processing..." indicator
  - AI interprets detailed action with full context
  - Determines mechanics (roll needed, difficulty, etc.)
  - Proceeds to roll and resolution (same as Quick Mode Flow 2, Step 5-6)
- **Data Required**:
  - Player's detailed text
  - Selected approach (or AI-inferred)
  - Scene context
- **Error States**:
  - AI interpretation fails -> Prompt player to simplify or rephrase
  - Network error -> Save draft locally, retry when connected

**Design note**: Player's text should be preserved verbatim in the session log, with AI's response clearly distinguished.

#### Step 5: AI Narrates Outcome (Detail Mode)
- **Screen/Location**: Same screen, narrative appears below input
- **User Action**: Reads narrative (passive)
- **System Response**:
  - Shows player's original text in distinct formatting:
    - "🎬 You: [player's exact text]"
  - Shows roll result (if applicable)
  - Shows AI's response, which should:
    - Honor the specific details player provided
    - Extend and build on player's narrative
    - Respond to NPC dialogue if player wrote speech
    - Be more detailed than Quick Mode responses (3-6 paragraphs)
  - Updates scene state
- **Data Required**:
  - Player's input text
  - Roll result
  - Scene context
  - NPC characterization (for dialogue responses)
- **Error States**:
  - AI response contradicts player's input -> Allow player to regenerate with different prompt
  - AI response too brief -> Regenerate with longer response

**AI prompt engineering notes**:
- Emphasize: "Build on player's exact words, don't rewrite or ignore"
- If player wrote dialogue, NPCs should respond to those specific words
- Match player's narrative style (formal/casual, descriptive/sparse)
- In Detail Mode, "show don't tell" - more sensory detail, less summary

#### Step 6: Continue or Exit Detail Mode
- **Screen/Location**: Same screen, after narrative
- **User Action**: Decides whether to stay in Detail Mode
- **System Response**:
  - Shows two options:
    - "Continue in Detail Mode" -> Text input clears, ready for next action
    - "Exit Detail Mode" -> Returns to Quick Mode
  - Default: Stay in Detail Mode (less friction for Morgan who prefers this)
  - Auto-exit if player doesn't interact for 2 minutes (assume switching contexts)
- **Data Required**:
  - Updated scene state
- **Error States**: None

**Design note**: Detail Mode should feel "sticky" - easy to stay in for multiple exchanges. Not a mode you're rushed to leave.

---

### Alternative Paths

#### Path A: Mid-Action Switch to Detail Mode
If player realizes mid-Quick-Mode they want more control:
1. Before action resolves, player taps "Wait, switch to Detail Mode"
2. Action cancelled
3. Enters Detail Mode with context of what they almost did
4. Can now elaborate or change entirely

#### Path B: Detail Mode Used for Dialogue
Specialized flow when Detail Mode is dialogue-heavy:
1. Player writes dialogue in quotes: "Guard, I must speak with the High Merchant immediately."
2. AI responds with NPC's specific reply
3. Player can continue dialogue back-and-forth in Detail Mode
4. When dialogue concludes, player writes action or exits Detail Mode

#### Path C: Split Action Across Multiple Inputs
If player's intended action is complex:
1. Player writes first part, sends
2. After AI responds, player writes next part in same Detail Mode
3. Chains multiple exchanges to describe a complex sequence
4. Treats it as continuous action rather than separate beats

---

### Edge Cases

**Player writes action contradicting scene state**:
- AI gently corrects in narrative: "You reach for the rope, but there isn't one nearby. Instead, you..."
- Or asks for clarification: "I don't see that in the scene. Did you mean [alternative]?"

**Player writes extremely creative/unexpected action**:
- AI rolls with it, even if not "optimal"
- Applies appropriate mechanics
- Narrates consequences (positive or negative)

**Player uses Detail Mode for simple action**:
- Allow it (no judgment)
- AI responds proportionally (don't over-elaborate a simple action)

**Player writes vulgar/inappropriate content**:
- Content filter blocks submission
- Shows: "That content doesn't match our guidelines. Please revise."
- Allows player to edit

**Player writes in non-standard format** (e.g., third person, out of character):
- AI adapts to match player's style
- Responds in same person/tense
- System is flexible, not prescriptive

**Player abandons Detail Mode mid-input**:
- Auto-save draft every 10 seconds
- When player returns (even next session), offer to restore draft

---

### Notes for Implementation

**Text Input UX**:
- Support markdown formatting (bold, italic)
- Auto-capitalize first letter
- Smart quotes
- Spell check enabled
- Keyboard shortcuts (Ctrl+Enter to send)
- Mobile: Larger touch targets, auto-focus keyboard

**AI Response Quality in Detail Mode**:
- Higher quality model for Detail Mode vs Quick Mode (worth the latency)
- Longer context window (include more campaign history)
- Specialized prompt: "This is a detailed player action. Honor their specific words."

**Performance**:
- Detail Mode AI response: <5s acceptable (player just wrote 100+ words, they'll wait)
- But stream response as it generates (show paragraph by paragraph)

**Accessibility**:
- Text area supports screen readers
- Voice input option (speech-to-text)
- Can export all Detail Mode inputs as standalone narrative

**Learning from Player**:
- Track: How often player uses Detail Mode? (0-10% vs 90-100%?)
- Adjust Quick Mode narrative length to match player's Detail Mode style
- If player never uses Detail Mode, don't prompt for it (they prefer Quick)

**Journaling Integration**:
- Flag Detail Mode inputs as "player-authored" in export
- Option to edit past Detail Mode inputs (refine for story)
- Morgan persona specifically values these sections

---

## Flow 3: Oracle Consultation

### Overview
- **User**: Alex or Jordan, when uncertainty arises
- **Goal**: Ask the oracle a yes/no question or query for inspiration
- **Entry point**: Click "Ask Oracle" button during active play
- **Success state**: Receives oracle answer that surprises and guides play forward

---

### Flow Diagram

```
[Active Play]
     |
     v
[Player clicks "Ask Oracle"]
     |
     v
┌─────────────────┐
│ Oracle modal    │
│ appears         │
└────────┬────────┘
         |
         v
    ◇ Question type?
   /         |        \
Yes/No   Meaning    Inspiration
question  check     prompt
  |         |          |
  v         v          v
[Fate Chart] [Meaning Tables] [Detail Generator]
  |         |          |
  └────┬────┴────┬────┘
       |         |
       v         v
 ┌─────────────────┐
 │ Show result     │
 │ (with context)  │
 └────────┬────────┘
          |
          v
     ◇ Need interpretation?
    /              \
  Yes               No
   |                |
   v                v
[AI interprets] [Close modal]
 result             |
   |                |
   └────────────────┘
          |
          v
[Return to active play with new info]
```

---

### Step Details

#### Step 1: Trigger Oracle
- **Screen/Location**: Main play interface
- **User Action**: Clicks "Ask Oracle" button (visible in footer or sidebar)
- **System Response**:
  - Pauses current flow
  - Opens oracle modal (overlays current screen)
  - Shows oracle interface with three tabs/options:
    - "Yes/No Question" (Fate Chart)
    - "What does X mean?" (Meaning tables)
    - "Give me an idea" (Inspiration prompt)
  - Default tab based on context (usually Yes/No)
- **Data Required**:
  - Current chaos factor (for Fate Chart)
  - Scene context (for contextual questions)
- **Error States**: None

**Design note**: Oracle should feel like consulting a helpful tool, not leaving the game. Modal overlay maintains context.

#### Step 2a: Ask Yes/No Question (Fate Chart)
- **Screen/Location**: Oracle modal, Yes/No tab
- **User Action**:
  - Types question in text field: "Is there a guard in the tower?"
  - Selects likelihood (dropdown): "Very Unlikely" to "Very Likely"
  - Clicks "Consult Oracle" button
- **System Response**:
  - Shows Mythic GME Fate Chart probability
  - Rolls percentile dice (d100 or 2d10)
  - Shows result with visual indicator:
    - "Exceptional Yes" (green, with icon)
    - "Yes" (green)
    - "No" (red)
    - "Exceptional No" (red, with icon)
  - Optionally checks for random event (based on chaos factor)
  - If random event: Shows "Random Event!" prompt with type
- **Data Required**:
  - Player's question (saved to log)
  - Selected likelihood
  - Current chaos factor
  - Fate Chart probabilities
- **Error States**:
  - No question entered -> Disable "Consult Oracle" button
  - Invalid likelihood -> Default to "50/50"

**Design note**: Fate Chart is core Mythic GME. Keep it transparent so users trust the oracle.

#### Step 2b: Ask Meaning Check
- **Screen/Location**: Oracle modal, Meaning tab
- **User Action**:
  - Types prompt: "What is the guard's attitude?"
  - Clicks "Roll Meaning"
- **System Response**:
  - Rolls on Mythic Meaning tables (Action + Description)
  - Shows result: "Gratify + Hostile"
  - AI interprets in context: "The guard seems hostile, perhaps you could gratify them somehow (bribe? flatter?)"
- **Data Required**:
  - Player's prompt
  - Mythic Meaning tables
  - Scene context for interpretation
- **Error States**:
  - Meaning tables unavailable -> Generate conceptual prompt using AI
  - AI interpretation fails -> Show raw table result, let player interpret

#### Step 2c: Ask for Inspiration
- **Screen/Location**: Oracle modal, Inspiration tab
- **User Action**:
  - Selects category: "NPC", "Location", "Object", "Event", "Complication"
  - Optionally adds context: "Medieval merchant"
  - Clicks "Generate"
- **System Response**:
  - AI generates contextual detail:
    - NPC: Name, brief description, one distinctive trait
    - Location: Evocative name and key feature
    - Object: Unusual detail that sparks ideas
    - Event: Something that just happened or is about to
    - Complication: A new problem or twist
  - Shows result with "Regenerate" option if not satisfied
- **Data Required**:
  - Selected category
  - Optional context text
  - Campaign setting/genre
  - Recent scene history (avoid repetition)
- **Error States**:
  - Generation fails -> Offer to try again or use random table fallback
  - Result contradicts established facts -> Allow regenerate

**Design note**: This is pure GM Emulator function - generating content player doesn't want to create themselves.

#### Step 3: Display Result
- **Screen/Location**: Same oracle modal
- **User Action**: Reviews result
- **System Response**:
  - Shows result prominently
  - If exceptional result or random event, highlights with visual emphasis
  - Shows brief explanation if helpful ("Exceptional Yes means yes AND something extra positive")
  - Offers optional AI interpretation button
  - Shows "Accept & Continue" button
- **Data Required**:
  - Oracle result
  - Context for explanation
- **Error States**: None

#### Step 4: Optional AI Interpretation
- **Screen/Location**: Same modal, expandable section
- **User Action**: Clicks "How does AI interpret this?" (optional)
- **System Response**:
  - AI provides contextual interpretation:
    - Connects result to current situation
    - Suggests implications
    - Offers narrative hook
  - Example: "Exceptional Yes - there's a guard, AND he recognizes you (positively or negatively?)"
  - This is advisory, not prescriptive
- **Data Required**:
  - Oracle result
  - Player's original question
  - Scene context
- **Error States**:
  - AI interpretation fails -> Hide this option

**Design note**: Interpretation is help for newer players or inspiration for experienced ones. Always optional.

#### Step 5: Accept and Continue
- **Screen/Location**: Modal closes
- **User Action**: Clicks "Accept & Continue"
- **System Response**:
  - Closes oracle modal
  - Logs oracle question and result to session history
  - May auto-update scene description if result changes situation significantly
  - Returns player to active play (Quick Mode or Detail Mode)
  - AI incorporates oracle result into next narrative response
- **Data Required**:
  - Oracle result to log
  - Updated scene state
- **Error States**: None

---

### Alternative Paths

#### Path A: Random Event Triggered
When Fate Chart roll triggers random event:
1. After showing Yes/No result, shows "Random Event!" alert
2. Rolls event type: "NPC Action", "New NPC", "Progress/Regress Thread", etc.
3. Rolls event focus from campaign threads/NPCs or generates new
4. Shows: "Random Event: NPC Action - [random NPC from campaign]"
5. AI suggests what might happen (player decides if it works)
6. Player accepts or rerolls

#### Path B: Embedded Oracle (Mid-Action)
If player's action contains implicit question:
1. AI detects question: "I check if the door is locked"
2. Auto-consults oracle with appropriate likelihood
3. Shows mini-oracle result inline: "🎲 Oracle: Likely... Yes!"
4. Continues action resolution with that answer
5. No modal interruption (seamless)

#### Path C: Complex Oracle Chain
Player asks follow-up oracle questions:
1. First question: "Is someone in the room?" -> Yes
2. Player immediately asks: "Is it hostile?" -> No
3. Then asks: "Do I know them?" -> Yes
4. Oracle modal stays open, logs each question/answer
5. When done, closes and returns to play

---

### Edge Cases

**Player asks non-yes/no question in Yes/No field**:
- "What is the guard's name?"
- AI detects and suggests: "Try the Inspiration tab for names" OR auto-switches to Inspiration tab

**Oracle result seems illogical given context**:
- Player can click "Reroll" with note
- Or choose to accept and let AI interpret surprisingly
- System doesn't force realism - solo RPG embraces chaos

**Player spams oracle for every tiny detail**:
- Allow it (no judgment), but AI can suggest: "You could decide that yourself!"
- Track usage patterns (if >10 oracle calls per scene, may suggest trusting instincts)

**Random event completely derails scene**:
- Player can dismiss random event ("Not now")
- Or queue it for next scene
- Oracle is tool, not dictator

**AI interpretation contradicts player's vision**:
- Always show it as "AI suggests" not "This means"
- Player can ignore interpretation entirely

---

### Notes for Implementation

**Oracle UI/UX**:
- Fast access: Keyboard shortcut (e.g., 'O' key)
- Oracle modal maintains scene context (shows current situation at top)
- Mobile: Full-screen oracle on small devices, modal on tablets/desktop
- Haptic feedback on dice roll (mobile)

**Mythic GME Integration**:
- Implement authentic Fate Chart (don't simplify)
- Use official Meaning tables or licensed alternatives
- Track chaos factor changes (goes up when scene gets chaotic, down when controlled)
- Random event frequency based on chaos factor (authentic Mythic)

**AI Enhancements to Oracle**:
- Context-aware likelihood suggestions: "Given the setting, 'Likely' seems appropriate"
- Learn player's oracle usage patterns (do they prefer surprising results?)
- Auto-detect when oracle would be helpful: "This seems uncertain - ask oracle?"

**Performance**:
- Dice roll: Instant (visual animation <1s)
- AI interpretation: <2s
- Modal open/close: Smooth animations

**Accessibility**:
- Screen reader announces roll results
- Keyboard navigation through oracle tabs
- Color-blind friendly indicators (not just red/green)

**Oracle History**:
- Maintain log of all oracle calls in session
- Exportable oracle log (separate from narrative)
- Review past oracle results (useful for checking if NPC should remember something)

---

## Flow 4: Combat/Conflict Resolution

### Overview
- **User**: Alex or Jordan, when physical or social conflict arises
- **Goal**: Resolve multi-exchange conflicts (combat, debate, chase) efficiently with tactical clarity
- **Entry point**: Action initiates conflict OR oracle/AI introduces hostile encounter
- **Success state**: Conflict resolved with clear outcome, story progresses

---

### Flow Diagram

```
[Active Play]
     |
     v
◇ Conflict triggered?
/                  \
Player action    AI introduces
(attack, etc.)   (encounter)
\                  /
 \                /
  v              v
┌─────────────────┐
│ Conflict Mode   │
│ activates       │
└────────┬────────┘
         |
         v
┌─────────────────┐
│ Set up conflict │
│ - Define stakes │
│ - Show opponents│
│ - Stress tracks │
└────────┬────────┘
         |
         v
     ┌───┴───┐
     │ ROUND │
     └───┬───┘
         |
         v
┌─────────────────┐
│ Player exchange │
│ - Choose action │
│ - Roll dice     │
│ - Apply result  │
└────────┬────────┘
         |
         v
┌─────────────────┐
│ Opponent        │
│ exchange (AI)   │
│ - AI decides    │
│ - Roll for NPC  │
│ - Apply result  │
└────────┬────────┘
         |
         v
    ◇ Conflict over?
   /              \
 Yes               No
  |                |
  v                v
[Resolve       [Next round]
conflict]       (loop back)
  |
  v
┌─────────────────┐
│ Narrate outcome │
│ - Winner        │
│ - Consequences  │
│ - Concessions   │
└────────┬────────┘
         |
         v
[Return to normal play]
```

---

### Step Details

#### Step 1: Trigger Conflict
- **Screen/Location**: Main play interface
- **User Action**:
  - Takes action that initiates conflict: "I attack the guard"
  - OR responds to AI-introduced encounter: "The bandit draws their sword!"
- **System Response**:
  - Detects conflict situation (combat, debate, chase, etc.)
  - Shows transition message: "Entering Conflict..."
  - Interface shifts to Conflict Mode layout
  - Changes visual tone (darker/red for combat, blue for debate, etc.)
- **Data Required**:
  - Triggering action
  - Opponent(s) - NPCs or environmental opposition
  - Conflict type (determines mechanics)
- **Error States**:
  - Unclear if conflict warranted -> AI asks: "Do you want to resolve this as a conflict or single roll?"

**Design note**: Not every hostile action needs full conflict. Quick skirmishes can be single rolls. Conflicts are for dramatic, multi-exchange confrontations.

#### Step 2: Set Up Conflict
- **Screen/Location**: Conflict Mode interface
- **User Action**: Reviews conflict setup (passive, but can modify)
- **System Response**:
  - Defines stakes clearly:
    - Victory condition: "If you win: enter the city. If they win: you're arrested."
  - Lists all participants:
    - Player character(s)
    - Opponent(s) with brief description
  - Shows mechanical setup:
    - Stress tracks (physical/mental for Fate)
    - Consequences available
    - Environmental aspects (if any)
  - Shows "Begin Conflict" button
  - Optionally, player can negotiate stakes or flee before conflict begins
- **Data Required**:
  - Conflict stakes (generated by AI based on context)
  - Opponent stats (name, approaches, stress track length)
  - Available approaches for player
  - Scene aspects that apply
- **Error States**:
  - Opponent stats missing -> Generate average opponent
  - Stakes unclear -> Default to "Win: proceed, Lose: complication"

**Design note**: Stakes definition is key - players should know what they're fighting for.

#### Step 3: Player Exchange (Round Start)
- **Screen/Location**: Conflict Mode, player's turn
- **User Action**:
  - Selects action type: Attack, Defend, Create Advantage, Overcome
  - Describes action briefly (Quick Mode) or in detail (Detail Mode available)
  - Selects approach: "Forceful", "Quick", etc.
  - Clicks "Roll"
- **System Response**:
  - Shows action description in conflict log
  - Rolls 4dF + approach bonus vs opponent's defense
  - Calculates outcome:
    - Hit: Apply stress/consequences
    - Miss: Opponent gains advantage or counterattacks
    - Tie: Boost to next roll
  - Updates stress tracks visually
  - Narrates exchange briefly (1-2 sentences)
  - Advances to opponent's turn
- **Data Required**:
  - Player's action and approach
  - Opponent's relevant defense value
  - Current stress and consequences
- **Error States**:
  - Invalid approach for action -> Suggest valid approach
  - Opponent stress track full but should be taken out -> Auto-resolve

**Design note**: Conflict rounds should feel fast-paced, not laborious. Aim for <30s per exchange.

#### Step 4: Opponent Exchange (AI Turn)
- **Screen/Location**: Same screen, opponent's turn
- **User Action**: Passive (watches opponent act)
- **System Response**:
  - AI decides opponent's action based on:
    - Opponent personality/tactics
    - Current conflict state (winning? desperate?)
    - Available approaches
  - Shows opponent's action: "Guard swings forcefully at you!"
  - Rolls 4dF + opponent's approach vs player's defense
  - Calculates outcome
  - Updates player's stress track if hit
  - Narrates exchange briefly
  - Checks if conflict should end
- **Data Required**:
  - Opponent's stats and tactics
  - Player's defense values
  - Current conflict state
- **Error States**:
  - AI selects invalid action -> Default to Attack
  - Roll calculation error -> Reroll automatically

**AI tactics notes**:
- Varied opponent behavior (not always attacking)
- Desperate opponents take risks when losing
- Smart opponents exploit player's weaknesses
- Group opponents coordinate actions

#### Step 5: Check Conflict End
- **Screen/Location**: Same screen, between rounds
- **User Action**: None (automatic)
- **System Response**:
  - Checks win conditions:
    - Opponent taken out (stress full + consequence)?
    - Player taken out?
    - Someone concedes (gives up)?
    - Stakes condition met?
  - If yes: Proceed to Step 6
  - If no: Start new round (back to Step 3)
- **Data Required**:
  - All participant stress/consequences
  - Defined stakes
  - Round count (if time-limited conflict)
- **Error States**: None (deterministic check)

**Design note**: Conflicts should end decisively, not drag on. If >5 rounds, consider prompting: "Getting long - want to resolve differently?"

#### Step 6: Resolve Conflict
- **Screen/Location**: Conflict Mode, resolution screen
- **User Action**: Reviews outcome (passive)
- **System Response**:
  - Declares winner clearly
  - Shows final stress/consequence state
  - If player lost, shows concession (what opponent demands)
  - If player won, shows victory benefit
  - AI generates narrative resolution (2-4 paragraphs):
    - Climactic moment
    - How conflict ended
    - Immediate aftermath
    - What happens next
  - Updates character state (stress carries forward, consequences have recovery time)
  - Shows "Continue" button
- **Data Required**:
  - Final conflict state
  - Defined stakes
  - Campaign context for narrative resolution
- **Error States**:
  - Narrative generation fails -> Show basic outcome text

#### Step 7: Return to Normal Play
- **Screen/Location**: Transition back to main play interface
- **User Action**: Clicks "Continue"
- **System Response**:
  - Closes Conflict Mode
  - Returns to normal play interface (Quick Mode or Detail Mode)
  - Scene reflects conflict outcome
  - Player can continue with next action
- **Data Required**:
  - Updated character state
  - Updated scene state reflecting outcome
- **Error States**: None

---

### Alternative Paths

#### Path A: Player Concedes Mid-Conflict
If player is losing and chooses to give up:
1. Player clicks "Concede" button (available during their turn)
2. System prompts: "Concede and accept a compromise?"
3. Player optionally narrates how they concede
4. AI determines reasonable concession (less harsh than full loss)
5. Conflict ends immediately
6. Proceeds to Step 6 (Resolve) with concession terms

#### Path B: Multiple Opponents
If conflict has 2+ opponents:
1. Setup shows all opponents with separate stress tracks
2. Player can target different opponents each exchange
3. AI handles opponent turns in sequence (or simultaneously if grouped)
4. Conflict continues until all opponents defeated OR player concedes/is defeated

#### Path C: Environmental Conflict
If conflict is against environment (chase, avoiding hazard, etc.):
1. Opponent is abstract (The Clock, The Storm, The Trap)
2. Stress represents "progress" vs "harm"
3. AI describes environmental challenges each round
4. Victory condition is completing progress track

#### Path D: Social Conflict (Debate/Persuasion)
If conflict is social:
1. Visual theme changes (no combat graphics)
2. Stress tracks labeled "Composure" not "Physical"
3. Actions use Careful, Clever, Flashy (social approaches)
4. AI generates argumentative exchanges, not physical blows
5. Victory means convincing opponent, not defeating them

---

### Edge Cases

**Conflict becomes trivial** (player clearly winning):
- After 2 rounds of dominant victory, AI offers: "End this quickly?"
- Player can fast-forward to victory

**Conflict becomes hopeless** (player clearly losing):
- AI suggests concession option
- Or introduces story element (ally arrives, distraction occurs)
- Avoid guaranteed player defeat unless stakes allow for it

**Player wants to flee mid-conflict**:
- Available as action: "Overcome to Escape"
- Difficulty based on opponent's speed/situation
- Success: Conflict ends, player escapes (but may have consequences)
- Failure: Continue conflict

**Player has multiple characters in conflict**:
- Each character acts in sequence (player controls all)
- Opponents act between or after
- Track stress separately per character

**Opponent should logically flee or surrender**:
- AI evaluates after each exchange
- If opponent is overwhelmed, they may concede or flee
- AI narrates this dramatically

**Complex battlefield situation** (terrain, cover, etc.):
- Use Fate aspects to represent: "Behind Stone Wall", "Muddy Ground"
- Player/opponents can invoke/create aspects
- Keep manageable (max 3-4 environmental aspects)

---

### Notes for Implementation

**Conflict Mode UI**:
- Clear visual distinction from normal play
- Stress tracks prominently displayed (visual bars, not just numbers)
- Consequences shown with severity (mild/moderate/severe)
- Action log on side (scrollable history of exchanges)
- Color coding: Player actions (blue), opponent actions (red), system (gray)

**Speed Optimization**:
- Pre-calculate opponent's likely actions
- Animate simultaneously when possible (roll + narrative)
- Skip animations option for experienced players
- Target: Full exchange (player + opponent) in <1 minute

**Tactical Clarity**:
- Show odds before rolling ("Difficulty: Fair, You have: +3")
- Highlight current tactical situation (who's winning, by how much)
- Suggest tactics: "Create Advantage might help here"
- But don't make it chess - keep narrative focus

**AI Opponent Behavior**:
- Personality-driven tactics (cowardly opponent flees when hurt, brave opponent fights to end)
- Tactical variety (don't always Attack)
- Smart use of Create Advantage
- Dramatic pacing (AI doesn't optimize perfectly - makes interesting choices)

**Fate-Specific Mechanics**:
- Proper implementation of Aspects, Invokes, Compels
- Fate points economy during conflicts
- Stress vs Consequences tradeoffs
- Team conflicts (multiple PCs)

**Alternative Systems**:
- System-agnostic conflict resolution possible
- Map other RPG systems' combat to this structure
- D&D 5E: HP as stress track, AC as defense, advantage/disadvantage system
- System complexity impacts MVP scope (start with Fate Accelerated)

**Accessibility**:
- Conflict log is screen-reader friendly
- Visual stress bars have numeric backups
- Color-blind safe indicators (not just red/green)
- Pause/resume conflict option

---

## Flow 5: Session End

### Overview
- **User**: Alex (wants clean stopping point)
- **Goal**: Wrap up current scene, save progress, prepare for next session
- **Entry point**: Player decides to end session OR reaches natural scene conclusion
- **Success state**: Session saved, recap prepared, player can leave guilt-free

---

### Flow Diagram

```
[Active Play]
     |
     v
◇ How to end session?
/              \
Natural scene   Player initiates
conclusion      end mid-scene
|                    |
v                    v
[Scene End]      [Mid-Scene End]
|                    |
└────────┬───────────┘
         |
         v
┌─────────────────┐
│ Wrap up actions │
│ - Auto-save     │
│ - Update state  │
└────────┬────────┘
         |
         v
┌─────────────────┐
│ Scene Summary   │
│ (AI generated)  │
└────────┬────────┘
         |
         v
┌─────────────────┐
│ Update Chaos    │
│ (if scene ended)│
└────────┬────────┘
         |
         v
┌─────────────────┐
│ Session Stats   │
│ - Duration      │
│ - Scenes played │
│ - Progress      │
└────────┬────────┘
         |
         v
    ◇ Export session?
   /              \
 Yes               No
  |                |
  v                v
[Export          [Skip]
options]           |
  |                |
  └────────┬───────┘
           |
           v
┌─────────────────┐
│ "Until next     │
│  time..." screen│
└────────┬────────┘
         |
         v
[Close app or return to campaign list]
```

---

### Step Details

#### Step 1: Initiate Session End
- **Screen/Location**: Main play interface
- **User Action**:
  - Clicks "End Scene" button (if at scene conclusion), OR
  - Clicks "Pause Session" button (if mid-scene), OR
  - Closes app (automatically saves)
- **System Response**:
  - If mid-action: Prompts "Complete this action before ending?"
  - If safe point: Shows "Ending session..." indicator
  - Begins auto-save process
  - Transitions to wrap-up screen
- **Data Required**:
  - Current scene state
  - Any unsaved actions
- **Error States**:
  - Unsaved conflict state -> Prompt: "Conflict in progress - concede or save here?"

**Design note**: Never lose player progress. Even hard app close should auto-save.

#### Step 2: Wrap Up Actions
- **Screen/Location**: Session end screen
- **User Action**: Passive (automatic processing)
- **System Response**:
  - Auto-saves all session data:
    - Character state
    - Scene progress
    - Oracle calls log
    - Narrative text
    - NPC states
  - Uploads to cloud (if enabled)
  - Confirms save with checkmark indicator
- **Data Required**:
  - All session state
  - User account (for cloud save)
- **Error States**:
  - Save fails -> Retry 3 times, then save to local only with warning
  - Cloud sync fails -> Save locally, queue for later sync

#### Step 3: Generate Scene Summary
- **Screen/Location**: Same screen
- **User Action**: Reads summary (passive)
- **System Response**:
  - AI generates brief summary of scene (if scene completed):
    - 2-3 paragraphs covering main events
    - Emphasizes player choices and outcomes
    - Ends with cliffhanger or hook for next scene
  - If mid-scene, summary covers progress so far
  - Shows "What happens next" prompt for next session
- **Data Required**:
  - Scene narrative log
  - Key actions taken
  - Current situation
- **Error States**:
  - Summary generation fails -> Show last narrated paragraph as summary

**Design note**: This summary is useful for recaps next session, but also psychologically satisfying - reinforces the story created.

#### Step 4: Update Chaos Factor (If Scene Ended)
- **Screen/Location**: Same screen
- **User Action**: Passive (automatic)
- **System Response**:
  - If scene ended cleanly at expected conclusion:
    - Shows: "Chaos Factor: 5 -> 4 (scene went as expected)"
  - If scene was chaotic (many surprises, conflicts):
    - Shows: "Chaos Factor: 5 -> 6 (things got unpredictable)"
  - If mid-scene: Skip this step (chaos adjusts at scene end only)
- **Data Required**:
  - Current chaos factor
  - Scene events (conflicts, random events, oracle surprises)
- **Error States**: None (chaos factor bounded 1-9)

**Design note**: Transparent Mythic GME mechanic. Players should understand why chaos changes.

#### Step 5: Show Session Stats
- **Screen/Location**: Same screen
- **User Action**: Reviews stats (optional)
- **System Response**:
  - Displays session statistics:
    - Session duration: "45 minutes"
    - Scenes completed: "1 full scene"
    - Actions taken: "12 actions"
    - Oracle calls: "3 questions asked"
    - Threads progressed: "Deliver message (in progress)"
  - Shows visual progress bars for active threads
  - Shows character XP/milestones (if system uses)
- **Data Required**:
  - Session telemetry
  - Thread progress
  - Character advancement tracking
- **Error States**:
  - Stats fail to calculate -> Show basic "Session complete"

**Design note**: Stats are motivating and help player see progress. Especially valuable for Morgan (journaler) who wants to see story arc.

#### Step 6: Export Options (Optional)
- **Screen/Location**: Same screen, expandable section
- **User Action**:
  - Clicks "Export Session" button (optional)
  - Selects export format:
    - Markdown (for Obsidian/journaling)
    - PDF (printable story)
    - Plain text
  - Selects what to include:
    - Full narrative (with player actions and AI responses)
    - Player actions only (Detail Mode inputs)
    - Summary only (AI-generated recap)
  - Clicks "Export"
- **System Response**:
  - Generates export file
  - Downloads or shares file (platform dependent)
  - Shows success: "Exported to Downloads/session-2025-12-09.md"
- **Data Required**:
  - Session narrative log
  - Selected format and options
  - File system access
- **Error States**:
  - Export fails -> Offer to copy to clipboard instead
  - No storage permission -> Prompt for permission

**Design note**: Export is KEY for Morgan persona. Must be seamless and produce readable narrative.

#### Step 7: Farewell Screen
- **Screen/Location**: Session end screen
- **User Action**: Reviews summary
- **System Response**:
  - Shows encouraging message:
    - "Until next time, [Character Name]..."
    - "Your story continues: [current thread cliffhanger]"
  - Shows "Continue Campaign" button (returns to campaign dashboard)
  - Shows "Close" button (exits to app home)
  - After 30 seconds of inactivity, auto-closes to campaign list
- **Data Required**:
  - Character name
  - Next story hook
- **Error States**: None

---

### Alternative Paths

#### Path A: Emergency Exit (App Crash/Force Quit)
If app closes unexpectedly:
1. App automatically saves state every 30 seconds during play
2. Next launch detects incomplete session
3. Offers: "Resume last session?" with last auto-save timestamp
4. If resumed, loads exactly where player was
5. Shows "(Auto-saved)" indicator to confirm

#### Path B: Quick Exit (Time Pressure)
If player is in hurry:
1. Taps "Quick End" button (always visible)
2. Immediately saves state
3. Skips summary and stats screens
4. Shows brief: "Session saved. See you next time!"
5. Auto-generates summary in background for next session recap

#### Path C: End with Threads Complete
If player completed major thread(s):
1. Session end shows "Thread Completed!" celebration
2. Shows completed thread summary
3. Offers to set new thread or continue with remaining
4. Character advancement opportunity (if applicable)

---

### Edge Cases

**Very short session** (<10 minutes):
- Still save and summarize, but acknowledge: "Quick session! Progress saved."
- No judgment - respect player's time constraints

**Very long session** (>2 hours):
- Suggest break: "You've been playing for 2 hours. Consider ending scene?"
- But allow infinite play if player wants
- Health/wellness reminder (optional setting)

**Player ends without completing scene**:
- Save exactly where they are
- Next session: "Resume mid-scene or start fresh scene?"
- Allow choice - some players prefer clean scene boundaries

**Multiple scenes in one session**:
- Session summary covers all scenes
- Stats aggregate across scenes
- Export includes full session (all scenes)

**Network issues during save**:
- Always save locally first (guaranteed)
- Queue cloud sync for later
- Show indicator: "Saved locally, will sync when online"

**Player wants to "undo" session**:
- Campaign dashboard shows session history
- Can restore previous session state (like version control)
- Current session becomes "branch" to compare

---

### Notes for Implementation

**Auto-Save Strategy**:
- Save after every action resolution (incremental)
- Keep last 10 auto-save points (circular buffer)
- Full session save on explicit end
- Cloud sync on WiFi only (optional setting)

**Summary Generation Quality**:
- Trained model or template for consistency
- Emphasize player agency ("You decided to...")
- Connect to threads and goals
- End with forward momentum

**Export Format Specifications**:

**Markdown export structure**:
```markdown
# Session: [Date]
## Campaign: [Name]

**Duration**: 45 minutes
**Scenes**: 1

---

## Scene: [Scene Name]

[Full narrative with player actions and AI responses]

### Actions Taken
- [Action 1]
- [Action 2]

### Oracle Calls
- Q: [Question] | A: [Answer]

---

## Summary
[AI-generated summary]

**Threads**:
- [Thread 1]: [Status]

**Next Session**: [Hook]
```

**Performance**:
- Auto-save: <200ms (asynchronous, doesn't block play)
- Summary generation: <3s (but player can skip if in hurry)
- Export: <5s for typical session

**Stats Tracking**:
- Store telemetry: action types, modes used, oracle calls, time played
- Aggregate for long-term insights (show player trends over campaign)
- Privacy-conscious: All data local unless cloud sync opted-in

**Accessibility**:
- Session summary can be read aloud
- Stats presented in text and visual formats
- Export includes alt-text for screen readers

**Motivational Design**:
- Positive reinforcement: "Great session!", "Story is developing!"
- Progress visualization (thread completion %)
- Optional: Streaks (days played), achievements (non-intrusive)

---

## Summary: Core Flows Defined

These five flows cover the essential user journeys for the Solo RPG App hybrid concept:

1. **Session Start** - Fast re-entry with AI recap and scene setup (30s to play)
2. **Core Play Loop** - Quick Mode efficiency with Detail Mode depth (player's choice)
3. **Oracle Consultation** - Mythic GME integration for uncertainty and surprise
4. **Combat/Conflict** - Structured multi-exchange resolution with tactical clarity
5. **Session End** - Clean wrap-up with summary, stats, and export options

**Cross-flow principles**:
- Player agency: Always in control of pacing and depth
- Seamless transitions: Flows connect naturally without jarring mode switches
- Persistent context: Character, threads, chaos factor visible throughout
- Surprise and structure: Balance of Mythic GME oracle mechanics with AI narration
- Journaling support: All flows produce exportable narrative

**Next steps** (for Phase 4 - Validation):
- Create interactive prototype or high-fidelity wireframes of these flows
- Test with Alex persona (primary): Does hybrid model work?
- Test with Morgan persona (secondary): Is export quality sufficient?
- Validate flow transitions feel natural
- Measure time-to-action and engagement

---

*Created: 2025-12-09 - Phase 3 Ideation*
*Based on: Concept 3 (Hybrid), Current Journey Map, Personas*
*For: @business-analyst (requirements definition), @tech-lead (feasibility), validation testing*
*Confidence: High (detailed, grounded in research)*
