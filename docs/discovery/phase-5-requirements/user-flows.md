# User Flows: Solo RPG Companion App

**Project**: Solo RPG Companion App
**Phase**: Phase 5 - Requirements Definition
**Date**: 2025-12-10
**Created by**: @ux-designer
**Based on**: Decisions 006-009, PRD v1.0, Solution Concepts

---

## Overview

This document details the key user flows for the Solo RPG Companion App MVP, reflecting final decisions made during Phase 4 validation:

- **Decision 006**: Dice Rolling UX - GM explains rolls conversationally with optional click-to-roll icon
- **Decision 007**: Combat/Conflict Agent - Separate AI agent for combat resolution
- **Decision 008**: GM Personality Selection - User-selectable personality presets
- **Decision 009**: Session State Model - Two-tier Chat Session → Session Log

---

## Flow 1: Core Play Loop (Updated)

### Overview
- **User Goal**: Take an action and see the outcome
- **Entry Point**: During active play session
- **Success State**: Action resolved, narrative continues
- **Frequency**: Most common flow - happens dozens of times per session

### Flow Diagram

```
[Player in Session]
    │
    ▼
┌─────────────────────────────────────┐
│ Player types action in chat         │
│ "I try to convince the guard to     │
│ let me pass"                        │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ GM Agent analyzes intent            │
│ - Action: Overcome (suspicion)      │
│ - Approach: Clever (reasoning)      │
│ - Difficulty: Fair (+2)             │
│ - Roll needed: Yes (risky action)   │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ GM explains roll conversationally   │
│                                     │
│ "That sounds like a Clever approach.│
│ Roll 4dF and add your Clever (+3).  │
│ You're trying to overcome their     │
│ suspicion (difficulty Fair +2)."    │
│                                     │
│ [🎲 Dice icon appears inline]       │
└────────┬────────────────────────────┘
         │
    ┌────┴────┐
    │         │
  Player   Player
  rolls    clicks
  physical  dice
  dice     icon
    │         │
    ▼         ▼
┌────────┐ ┌─────────────────────────┐
│ Types  │ │ System auto-rolls       │
│ result │ │ Shows animated result   │
│ "+2"   │ │ "[-][+][+][0] = +2"     │
└───┬────┘ └──────┬──────────────────┘
    │             │
    └─────┬───────┘
          │
          ▼
┌─────────────────────────────────────┐
│ GM Agent calculates outcome         │
│ - Roll: +2                          │
│ - Bonus: +3 (Clever)                │
│ - Total: +5                         │
│ - vs Difficulty: +2                 │
│ - Margin: +3 → Success with Style   │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ GM narrates outcome                 │
│                                     │
│ "So +5 total - excellent! You       │
│ launch into a convincing story      │
│ about urgent merchant business.     │
│ The older guard's eyes narrow, but  │
│ eventually he sighs. 'Alright,      │
│ merchant. But no trouble.' He       │
│ steps aside."                       │
│                                     │
│ [Character sheet updates if needed] │
└────────┬────────────────────────────┘
         │
         ▼
   [Next Action]
```

### Step Details

#### Step 1: Player Types Action
- **Screen/Location**: Main play screen, chat interface
- **User Action**: Types natural language action in text input
- **Examples**:
  - "I try to convince the guard"
  - "I sneak past the warehouse"
  - "I attack the bandit"
- **System Response**: Message appears in chat as player bubble
- **Data Required**: Active session, current scene context

#### Step 2: GM Agent Analyzes Intent
- **Process**: AI determines action type and approach
- **Checks**:
  - Is roll needed? (risky action vs automatic success/failure)
  - Which Fate action? (Overcome, Create Advantage, Attack, Defend)
  - Which approach? (Careful, Clever, Flashy, Forceful, Quick, Sneaky)
  - What's the difficulty? (based on situation)
- **Ambiguity handling**: If unclear, GM asks clarifying question
- **Example**: "Are you charming them (Flashy) or reasoning with them (Clever)?"

#### Step 3: GM Explains Roll Need
- **Display**: GM message in chat explaining roll
- **Components**:
  - Approach identification: "That sounds like a Clever approach"
  - Dice notation: "Roll 4dF and add your Clever (+3)"
  - Context: "You're trying to overcome their suspicion"
  - Optional: Difficulty revealed: "(difficulty Fair +2)"
- **Visual**: Small dice icon (🎲) appears inline next to roll request
- **Decision 006**: Educational approach - GM explains WHY roll is needed

#### Step 4: Player Provides Roll Result
- **Option A - Physical Dice**:
  - Player rolls physical Fudge dice
  - Types result: "+2", "[-][+][+][0]", or "I got +2"
  - System parses input
- **Option B - Click-to-Roll** (Decision 006):
  - Player clicks dice icon in GM message
  - System rolls 4dF digitally
  - Animated result appears: "🎲 You rolled [-][+][+][0] = +2"
  - Result auto-submitted to GM
- **Option C - Auto-Roll** (if setting enabled):
  - System automatically rolls when GM requests
  - No player action needed
  - GM reports: "I'm rolling for you... You got +2"

#### Step 5: GM Calculates Outcome
- **Backend Process**:
  - Parse roll result (dice total)
  - Add approach bonus (from character sheet)
  - Calculate total
  - Compare to difficulty
  - Determine success level:
    - Beat by 3+: Success with Style
    - Beat by 1-2: Success
    - Tie: Success at Cost
    - Miss by 1-2: Failure
    - Miss by 3+: Failure with Complication
- **Tools Called**: `resolve_action(approach, difficulty, bonus, roll)`

#### Step 6: GM Narrates Outcome
- **Display**: GM message describing result
- **Components**:
  - Arithmetic shown: "So +5 total"
  - Success level implied through narrative richness
  - Consequences described (if any)
  - Next prompt or scene change
- **Updates**:
  - Character sheet updates if state changes
  - Scene context updates if location/NPCs change
  - Visual feedback: brief pulse animation on changed fields

### Alternative Paths

#### Path A: Ambiguous Action
```
Player: "I deal with the guard"
    ↓
GM: "How do you want to deal with them?
     Are you trying to talk your way through,
     sneak past, or intimidate them?"
    ↓
Player clarifies approach
    ↓
[Return to normal flow]
```

#### Path B: Impossible Action
```
Player: "I fly over the wall"
    ↓
GM: "You don't have any magic or equipment
     that would let you fly. You could try to
     climb the wall, or look for another way in?"
    ↓
Player chooses viable alternative
    ↓
[Return to normal flow]
```

#### Path C: No Roll Needed (Automatic Success)
```
Player: "I open the unlocked door"
    ↓
GM: "You turn the handle and step through
     into a dimly lit corridor..."
    ↓
[No roll requested, continues narrative]
```

#### Path D: Aspect Invocation
```
[During roll calculation]
    ↓
GM: "You could invoke your 'Clever Merchant-Spy'
     aspect here - that training in staying calm
     would help. Cost 1 fate point for +2 bonus.
     Want to invoke it?"
    ↓
Player: "Yes" or "No"
    ↓
[If yes: fate point decremented, +2 added to total]
    ↓
GM narrates with aspect context
```

### Edge Cases

**Player Types Unparseable Roll Result**:
- Example: Player types "good roll"
- GM: "I need the actual number - what did the dice show? Like '+2' or '[-][+][+][0]'?"
- Player retries with valid format

**Player Wants to Change Action After Roll**:
- Player: "Wait, I want to sneak instead"
- GM: "No problem, let's back up. You're sneaking past (Sneaky approach). Roll 4dF + your Sneaky (+2)..."
- Previous roll discarded, new roll requested

**Dice Icon Click Fails (Network Error)**:
- System shows error: "Couldn't roll dice - try again or roll physical dice?"
- Player can retry click or type result manually
- No progress lost

---

## Flow 2: Session Lifecycle (New - Decision 009)

### Overview
- **User Goal**: Start, play, and end a session with proper state management
- **Entry Point**: Campaign selection or session start
- **Success State**: Session summary saved, state persisted, ready to resume
- **Decision 009**: Two-tier model - Chat Session (in-progress) → Session Log (summary)

### Flow Diagram

```
[Campaign Selected]
    │
    ▼
┌─────────────────────────────────────┐
│ Load Campaign                       │
│ - Retrieve last Session Log         │
│ - Load character sheet              │
│ - Load scene context                │
│ - Load Mythic GME state             │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Start Session (Resume Campaign)     │
│                                     │
│ GM: "Welcome back! Last time, you   │
│ escaped the bandits and reached the │
│ gates of Kalinth as the sun set.    │
│ Ready to continue?"                 │
│                                     │
│ [Chat Session begins]               │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Chat Session (In-Progress)          │
│                                     │
│ - Full conversation transcript      │
│ - Working state (uncommitted)       │
│ - Real-time interaction             │
│ - Periodic auto-save (every 5 turns)│
│                                     │
│ [Player plays normally]             │
└────────┬────────────────────────────┘
         │
    ┌────┴────┐
    │         │
  Player    App
  says      crashes
  "End      mid-
  session"  session
    │         │
    ▼         ▼
┌─────────┐ ┌─────────────────────────┐
│ Trigger │ │ Recovery on next launch │
│ End     │ │ "Resume from last auto- │
│ Session │ │ save?" → Recovers       │
│ Flow    │ │ (max 5 turns lost)      │
└────┬────┘ └──────┬──────────────────┘
     │             │
     └──────┬──────┘
            │
            ▼
┌─────────────────────────────────────┐
│ End Session Trigger                 │
│ - Detected: "end session", "stop",  │
│   "I'll stop here"                  │
│ - Or: Explicit End Session button   │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Generate Session Summary            │
│                                     │
│ AI analyzes chat session:           │
│ - Key events that occurred          │
│ - Important decisions made          │
│ - Character development             │
│ - Current situation                 │
│                                     │
│ Creates 2-3 paragraph narrative     │
│ summary                             │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Extract State Changes               │
│                                     │
│ AI identifies:                      │
│ - New NPCs met (name, personality,  │
│   relationship)                     │
│ - New locations visited             │
│ - Inventory changes (items acquired/│
│   lost)                             │
│ - Character state (stress, conseq., │
│   fate points, aspects)             │
│ - Thread updates (new threads,      │
│   resolved threads)                 │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Update Mythic GME State             │
│                                     │
│ AI assesses session:                │
│ - Did scene end in control or chaos?│
│ - Chaos Factor adjustment:          │
│   - Control → -1                    │
│   - Chaos → +1                      │
│   - Mixed → 0                       │
│ - Thread list updated (added/       │
│   resolved)                         │
│ - NPC list updated (status changes) │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Present Changes for Player Review   │
│                                     │
│ GM: "Here's what happened this      │
│ session:                            │
│                                     │
│ **Summary:**                        │
│ [AI-generated 2-3 paragraph summary]│
│                                     │
│ **New NPCs:**                       │
│ - Guard Captain Marcus (gruff but   │
│   fair, neutral relationship)       │
│                                     │
│ **New Locations:**                  │
│ - City of Kalinth (fortified        │
│   trading hub)                      │
│                                     │
│ **Inventory Changes:**              │
│ + Silver merchant badge (fake)      │
│                                     │
│ **Chaos Factor:** 5 → 4 (more       │
│ controlled situation)               │
│                                     │
│ Does this look right? You can edit  │
│ anything before I save."            │
└────────┬────────────────────────────┘
         │
    ┌────┴────┐
    │         │
  Player   Player
  confirms  edits
    │         │
    │    ┌────┴────┐
    │    │ Player  │
    │    │ modifies│
    │    │ details │
    │    └────┬────┘
    │         │
    └────┬────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Commit to Session Log               │
│                                     │
│ Database writes:                    │
│ - Session summary (narrative)       │
│ - State changes (structured data)   │
│ - Mythic GME updates                │
│ - Last 50-100 conversation messages │
│ - Session metadata (duration, date) │
│                                     │
│ Session Log becomes canonical record│
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Session Saved                       │
│                                     │
│ GM: "Session saved! See you next    │
│ time. You're currently at the       │
│ Golden Lamb inn with a lead on the  │
│ warehouse mystery."                 │
│                                     │
│ [Returns to campaign list or closes]│
└─────────────────────────────────────┘
```

### Step Details

#### Step 1: Load Campaign
- **Screen/Location**: Campaign list screen → Main play screen
- **User Action**: Selects campaign from list
- **System Response**:
  - Loads last Session Log (summary, not full transcript)
  - Retrieves character sheet (current state)
  - Retrieves scene context (location, NPCs, threads)
  - Loads Mythic GME state (chaos factor, lists)
- **Data Required**: Campaign database, vector store for history
- **Performance**: Loads within 2 seconds

#### Step 2: Start Session (Resume Campaign)
- **Display**: GM message in chat
- **AI generates recap**:
  - Based on last Session Log summary
  - Includes: last scene, last action, current stakes
  - Conversational tone: "Welcome back!"
- **Prompt**: "Ready to continue?" or similar
- **User can**:
  - Confirm and jump in: "Yes, let's go"
  - Ask questions: "What was I doing again?"
  - Start acting immediately: "I approach the inn"
- **Latency**: Recap generated within 30 seconds

#### Step 3: Chat Session (In-Progress)
- **State**: Volatile, in-memory working state
- **Contains**:
  - Full conversation transcript (since session start)
  - Uncommitted state changes (NPCs added, items gained)
  - Current scene context (updated in real-time)
- **Auto-save**: Every 5 conversation turns or 2 minutes
  - Saves to temporary recovery file
  - Enables crash recovery
- **User Experience**: Normal play, unaware of working state vs committed state

#### Step 4: End Session Trigger
- **Trigger Options**:
  - **Explicit**: Player says "end session", "stop here", "I'll stop for tonight"
  - **Button**: End Session button in menu/toolbar
  - **Implicit**: Player closes app (auto-saves current state)
- **Detection**: AI recognizes end session intent in conversation
- **Confirmation**: If implicit close, next launch asks "Resume from last session?"

#### Step 5: Generate Session Summary
- **Process**: AI tool call to summarize Chat Session
- **Input**: Full conversation transcript from session
- **Output**: 2-3 paragraph narrative summary
- **Content**:
  - Key events chronologically
  - Important decisions player made
  - Character development or revelations
  - Current situation at session end
- **Style**: Readable narrative, like session recap you'd write yourself
- **Latency**: Generated within 10-15 seconds

#### Step 6: Extract State Changes
- **Process**: AI analyzes conversation for structured data
- **Extracts**:
  - **New NPCs**: Name, personality, relationship to PC, status
  - **New Locations**: Name, description, parent location
  - **Inventory Changes**: Items acquired or lost
  - **Character State**: Stress, consequences, fate points, new aspects
  - **Thread Updates**: New threads opened, threads resolved/abandoned
- **Format**: Structured JSON output
- **Validation**: AI cross-checks for consistency

#### Step 7: Update Mythic GME State
- **Chaos Factor Assessment**: AI evaluates session
  - Question: "Did the scene end more controlled or more chaotic than it began?"
  - Control indicators: Goals achieved, situations resolved, plans working
  - Chaos indicators: Surprises, complications, plans failing, new problems
  - Adjustment: -1 (control), 0 (mixed), +1 (chaos)
  - Bounds: Min 1, Max 9
- **Thread List**: Updated with new threads, resolved threads marked
- **NPC List**: Status changes (active → resolved, unknown → active)

#### Step 8: Present Changes for Player Review
- **Display**: Formatted summary in chat
- **Sections**:
  - Session Summary (narrative)
  - New NPCs (bullet list with details)
  - New Locations (bullet list)
  - Inventory Changes (+ added, - removed)
  - Threads (new, resolved)
  - Chaos Factor change
- **Interaction**:
  - Player can accept as-is: "Looks good"
  - Player can edit: "Marcus should be 'suspicious' not 'neutral'"
  - Player can add: "I also picked up the guard's note"
- **AI updates based on feedback**

#### Step 9: Commit to Session Log
- **Database Writes**:
  - `sessions` table: New session record with summary, metadata
  - `npcs` table: New NPC records or updates
  - `locations` table: New location records
  - `threads` table: New threads, resolved thread updates
  - `characters` table: Updated character state
  - `conversation_log` table: Last 50-100 messages (for next session context)
  - Campaign `chaos_factor` updated
- **Vector Store**: Embed session summary for semantic search
- **Backup**: Copy database to .backup file before commit
- **Latency**: Completes within 5 seconds

#### Step 10: Session Saved Confirmation
- **Display**: GM confirmation message
- **Content**: "Session saved! See you next time. [Brief reminder of where player is]"
- **Navigation**: Returns to campaign list or closes app
- **State**: Chat Session cleared, Session Log is canonical record

### Alternative Paths

#### Path A: Mid-Session Crash Recovery
```
[App crashes during play]
    ↓
Player relaunches app
    ↓
System detects incomplete session
    ↓
Prompt: "You have an incomplete session from [time].
         Resume from last auto-save? (Max 5 turns lost)"
    ↓
Player confirms
    ↓
Loads last auto-saved Chat Session state
    ↓
GM: "Let's pick up where we left off..."
    ↓
[Resumes play]
```

#### Path B: Player Aborts End Session
```
[End Session flow started]
    ↓
Summary and changes presented
    ↓
Player: "Actually, I want to keep playing"
    ↓
GM: "No problem! The changes aren't saved yet.
     What do you want to do next?"
    ↓
[Returns to Chat Session, changes still in working state]
```

#### Path C: Player Significantly Edits Summary
```
[Changes presented for review]
    ↓
Player: "That's not quite right. I actually
         made friends with Marcus, not neutral."
    ↓
GM: "Got it, updating Marcus to 'friendly' relationship.
     Anything else?"
    ↓
Player: "Also, I didn't get the fake badge yet,
         that's for next session."
    ↓
GM: "Removing fake badge from inventory. Here's
     the updated summary: [revised version]"
    ↓
Player: "Perfect"
    ↓
[Commits revised version to Session Log]
```

### Edge Cases

**Very Short Session (< 10 turns)**:
- Summary might be: "You entered the city and spoke briefly with the guards."
- Still goes through full End Session flow
- Validates that process works for all session lengths

**Very Long Session (100+ turns)**:
- Summary focuses on key events, not everything
- State extraction may take longer (15-20 seconds)
- Player can review in chunks if needed

**No State Changes Detected**:
- Example: Pure roleplay session, no mechanics
- Summary still generated
- State changes section: "No significant changes this session"
- Chaos factor might still adjust

**Player Closes App Without Ending Session**:
- Next launch: "Your last session wasn't formally ended. Resume play or end session?"
- If resume: Loads Chat Session as-is
- If end: Goes through normal End Session flow

---

## Flow 3: Combat Handoff (New - Decision 007)

### Overview
- **User Goal**: Resolve combat encounter with proper rules application
- **Entry Point**: Combat begins during narrative play
- **Success State**: Combat resolved, returns to narrative play
- **Decision 007**: Separate Combat Agent for specialized conflict resolution

### Flow Diagram

```
[Narrative Play - GM Agent Active]
    │
    ▼
┌─────────────────────────────────────┐
│ Combat Trigger Event                │
│                                     │
│ GM: "The two bandits draw their     │
│ weapons. 'Your coin or your life,'  │
│ snarls the larger one. This is      │
│ going to be a fight."               │
│                                     │
│ [GM Agent detects combat initiation]│
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Handoff to Combat Agent             │
│                                     │
│ - Combat Agent activated            │
│ - Context passed:                   │
│   - Character state (stress, etc.)  │
│   - Enemy NPCs (stats, stress)      │
│   - Scene context (battlefield)     │
│   - Current situation               │
│                                     │
│ [Seamless transition]               │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Combat Agent: Initialize Conflict   │
│                                     │
│ Combat GM: "Let's resolve this      │
│ conflict. In Fate, we handle this   │
│ as an exchange - you'll each take   │
│ turns attacking or defending.       │
│                                     │
│ The large bandit attacks first.     │
│ He lunges at you with his blade.    │
│ How do you defend?"                 │
│                                     │
│ [Turn order established]            │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Combat Round(s)                     │
│                                     │
│ [Repeated turn-by-turn combat]      │
│                                     │
│ For each turn:                      │
│ - Combat GM prompts for action      │
│ - Player chooses approach           │
│ - Roll and resolution (standard     │
│   Core Play Loop)                   │
│ - Stress/consequences applied       │
│ - NPC turn(s)                       │
│ - Repeat until combat ends          │
│                                     │
│ [Combat Agent tracks all states]    │
└────────┬────────────────────────────┘
         │
    ┌────┴────┐
    │         │
  Player    Player
  victory   defeat
    │         │
    │         │
    ▼         ▼
┌────────┐ ┌─────────────────────────┐
│ Bandits│ │ Player taken out        │
│ taken  │ │ (stress + consequences  │
│ out    │ │ exceeded)               │
└───┬────┘ └──────┬──────────────────┘
    │             │
    └─────┬───────┘
          │
          ▼
┌─────────────────────────────────────┐
│ Combat Resolution                   │
│                                     │
│ Combat GM: "The large bandit        │
│ collapses, taken out. The smaller   │
│ one throws down his weapon.         │
│ 'Alright, alright! You win!' Combat │
│ is over."                           │
│                                     │
│ [Final stress/consequences updated] │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Return to GM Agent                  │
│                                     │
│ - Combat Agent deactivated          │
│ - Context returned:                 │
│   - Updated character state         │
│   - NPC final states (taken out,    │
│     fled, surrendered)              │
│   - Combat outcome summary          │
│                                     │
│ [Seamless transition]               │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Narrative Play Resumes - GM Agent  │
│                                     │
│ GM: "With the bandits defeated, you │
│ catch your breath. You're hurt      │
│ (stress at 3/4, Bruised Ribs), but  │
│ alive. The road ahead is clear.     │
│ What do you do?"                    │
│                                     │
│ [Back to normal narrative play]     │
└─────────────────────────────────────┘
```

### Step Details

#### Step 1: Combat Trigger Event
- **Screen/Location**: Main play screen, narrative conversation active
- **Trigger Detection**: GM Agent recognizes combat initiation
  - Multiple hostile NPCs present
  - Combat declared by player or NPC
  - Initiative needed for turn-based resolution
- **GM Message**: Narrates combat trigger, signals shift to conflict
- **Player Expectation**: Understands combat is beginning

#### Step 2: Handoff to Combat Agent
- **Backend Process**:
  - GM Agent calls Combat Agent initialization
  - Passes context packet:
    - Character full state (approaches, stress, aspects, fate points, consequences)
    - Enemy NPC stats (generated or retrieved from database)
    - Scene context (battlefield layout, environmental factors)
    - Current situation (who started combat, why)
- **User Experience**: Seamless - no visible "ENTERING COMBAT MODE" message
- **UI Changes** (optional):
  - Combat panel shows initiative order
  - NPC stress/status becomes visible
  - Turn indicator shows whose turn

#### Step 3: Combat Agent Initializes Conflict
- **Combat GM Tone**: More structured than narrative GM
- **First Message**:
  - Brief explanation of combat flow (if first combat in campaign)
  - Establishes turn order (narrative or approach-based)
  - Prompts for first action
- **Tools Available**: Same as GM Agent + combat-specific:
  - `track_npc_stress(npc_id, stress)`
  - `apply_npc_consequence(npc_id, consequence)`
  - `get_initiative_order()`
- **State Tracking**: Combat Agent maintains all combatant states

#### Step 4: Combat Round(s)
- **Turn Structure** (Fate Accelerated - flexible):
  - Player turn: Combat GM prompts for action
  - Player declares: "I attack the large bandit with my sword"
  - Roll resolution: Standard Core Play Loop (approach, roll, outcome)
  - Stress/consequences applied
  - NPC turn: Combat GM narrates NPC action, rolls, applies results
  - Repeat until combat ends
- **Each Turn**:
  - Clear prompt: "It's your turn. What do you do?"
  - Player can Attack, Create Advantage, Defend, or other action
  - Approach selected or clarified
  - Roll and outcome
  - State updates (stress boxes, consequences)
- **NPC Turns**: Combat GM narrates NPC actions, rolls for them, applies outcomes
- **Tracking**:
  - Player stress: 0-4 boxes, consequences (Mild/Moderate/Severe)
  - NPC stress: Varies by importance (mooks 1-2 boxes, important NPCs 3-4)
  - Aspects: Temporary situation aspects from Create Advantage actions
  - Turn order: Who acts next

#### Step 5: Combat Resolution
- **End Conditions**:
  - Player taken out: Stress exceeded, no consequences left
  - All NPCs taken out: Stress exceeded, fled, or surrendered
  - Player concedes: Chooses to give up, takes consequences but defines outcome
- **Final Message**: Combat GM narrates resolution
- **Updates**: All final states committed (stress, consequences, NPC statuses)

#### Step 6: Return to GM Agent
- **Backend Process**:
  - Combat Agent calls GM Agent with combat outcome packet:
    - Character state (stress, consequences, fate points, aspects changed)
    - NPC outcomes (taken out, fled, surrendered, status)
    - Combat summary (who won, significant moments)
  - Combat Agent deactivated
  - GM Agent resumes control
- **User Experience**: Seamless transition back to narrative
- **UI Changes**: Combat-specific UI elements (if any) fade out

#### Step 7: Narrative Play Resumes
- **GM Agent Message**: Acknowledges combat outcome, continues narrative
- **Tone**: Returns to conversational narrative style
- **Context**: Combat consequences visible (stress, consequences on character sheet)
- **Prompt**: "What do you do?" to resume player agency

### Alternative Paths

#### Path A: Player Concedes Mid-Combat
```
[During combat, player losing badly]
    ↓
Player: "I surrender" or "I concede"
    ↓
Combat GM: "You're conceding the conflict. You
            take a consequence and the bandits win,
            but you get to say what that looks like.
            What happens?"
    ↓
Player: "They take my coin pouch and leave me
         beaten on the road"
    ↓
Combat GM: "Got it. Mark a Moderate consequence:
            'Beaten and Robbed'. The bandits laugh
            and disappear into the trees."
    ↓
[Returns to GM Agent, player alive but defeated]
```

#### Path B: Player Flees Combat
```
[During combat, player wants to escape]
    ↓
Player: "I try to run away"
    ↓
Combat GM: "That's an Overcome action to escape.
            Roll Quick to outpace them..."
    ↓
[Roll resolution]
    ↓
If success: "You sprint away and lose them in the
             underbrush. Combat ends."
    ↓
[Returns to GM Agent, combat avoided]
```

#### Path C: NPCs Flee
```
[Combat going badly for NPCs]
    ↓
Combat GM: "The smaller bandit sees his partner fall
            and panics. He throws down his weapon.
            'I give up!' Combat ends."
    ↓
[Returns to GM Agent, player can decide what to do
with surrendered NPC]
```

### Edge Cases

**First Combat in Campaign**:
- Combat GM explains Fate conflict mechanics briefly
- Example: "In Fate, combat works like this: [brief explanation]"
- Marks "combat" as encountered in mechanics tracker
- Subsequent combats skip explanation

**Very Short Combat (1-2 rounds)**:
- Player or NPCs taken out quickly
- Still goes through full handoff process
- Validates smooth transition even for brief conflicts

**Multiple NPCs (3+)**:
- Combat GM tracks each NPC separately
- May simplify: "The three bandits act together"
- Player can target specific NPCs: "I attack the leader"
- NPC stress tracked individually or as group (depending on importance)

**Combat Triggers Mid-Sentence**:
- Example: Player talking to NPC, suddenly attacked
- GM Agent finishes current exchange, then hands off
- Combat GM starts with context: "You were talking to the merchant when suddenly..."

**Player Tries to Negotiate During Combat**:
- Player: "I try to talk them down"
- Combat GM: "That's a Create Advantage action using Clever. Roll to create 'Open to Talk' aspect..."
- If successful: NPCs might pause, potentially end combat
- Roleplay happens within combat structure

---

## Flow 4: GM Personality Selection (New - Decision 008)

### Overview
- **User Goal**: Choose GM narration style that matches preferences
- **Entry Point**: Campaign creation or campaign settings
- **Success State**: Personality selected, narration reflects choice
- **Decision 008**: User-selectable presets rather than adaptive AI

### Flow Diagram

```
[Campaign Creation] OR [Campaign Settings]
    │
    ▼
┌─────────────────────────────────────┐
│ GM Personality Selection Screen     │
│                                     │
│ "Choose your GM's personality:"     │
│                                     │
│ ○ Dramatic Storyteller              │
│   Rich descriptions, cinematic      │
│   narration, emotional tone         │
│                                     │
│ ○ Rules-Focused Tactician           │
│   Explains mechanics clearly, less  │
│   atmosphere, tactical approach     │
│                                     │
│ ○ Comedic Entertainer               │
│   Light-hearted tone, humor, doesn't│
│   take itself too seriously         │
│                                     │
│ ○ Dark & Gritty Realist             │
│   Serious consequences, dangerous   │
│   world, noir atmosphere            │
│                                     │
│ ● Neutral Balanced (default)        │
│   Middle ground, adaptable tone     │
│                                     │
│ ○ Custom (Advanced)                 │
│   Write your own personality        │
│   description                       │
│                                     │
│ [Sample Narration] button for each  │
└────────┬────────────────────────────┘
         │
    ┌────┴────┐
    │         │
  Player   Player
  selects  clicks
  preset   "Sample"
    │         │
    │         ▼
    │    ┌─────────────────────────┐
    │    │ Show sample narration   │
    │    │ for selected personality│
    │    │                         │
    │    │ [Close] [Select This]   │
    │    └──────┬──────────────────┘
    │           │
    │      ┌────┴─────┐
    │      │          │
    │    Close    Select
    │      │          │
    │      └────┬─────┘
    │           │
    └───────┬───┘
            │
            ▼
┌─────────────────────────────────────┐
│ Personality Applied                 │
│                                     │
│ - System prompt modifier set        │
│ - Affects narration style only      │
│ - Rules application unchanged       │
│                                     │
│ "Your GM will be [personality].     │
│ You can change this anytime in      │
│ settings."                          │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Begin Campaign / Return to Settings│
│                                     │
│ [Campaign continues with selected   │
│  personality]                       │
└─────────────────────────────────────┘
```

### Step Details

#### Step 1: GM Personality Selection Screen
- **Screen/Location**: Campaign creation wizard step 3, or Settings screen
- **Display**: Radio button list of personality presets
- **Presets**:
  - **Dramatic Storyteller**: Default for rich narrative
  - **Rules-Focused Tactician**: For players who want mechanical clarity
  - **Comedic Entertainer**: For light-hearted, fun adventures
  - **Dark & Gritty Realist**: For serious, dangerous campaigns
  - **Neutral Balanced**: Middle-ground, adaptable (system default)
  - **Custom**: Free-text field for advanced users
- **Default**: Neutral Balanced pre-selected
- **Actions**: Select preset, view sample, save, or cancel

#### Step 2: View Sample Narration (Optional)
- **Trigger**: Player clicks "Sample Narration" button next to preset
- **Display**: Modal or panel showing example narration
- **Content**: Same scene narrated in different personalities
- **Example Scene**: "You approach the city gates at sunset"

**Dramatic Storyteller Sample**:
```
The sun bleeds crimson across the horizon as you
approach the ancient gates of Kalinth. Towering walls
of weathered stone loom before you, their battlements
crowned with the silhouettes of watchful guards. The
air smells of distant fires and coming rain. Your
heart quickens - beyond these gates lies your destiny.
```

**Rules-Focused Tactician Sample**:
```
You arrive at Kalinth's gates at sunset. The city is
fortified with high stone walls and guard towers. You
see two guards (Fair +2 opposition) blocking the main
entrance. They appear alert. You could try to talk
your way in (Clever), sneak around (Sneaky), or find
another approach.
```

**Comedic Entertainer Sample**:
```
You rock up to Kalinth's gates just as the sun's
checking out for the day. Two guards stand there
looking like they've been on shift for about a
thousand years and are not thrilled to see you. The
tall one yawns. The short one sighs. You get the
feeling this is going to go great.
```

**Dark & Gritty Realist Sample**:
```
You reach Kalinth as dusk falls - that dangerous hour
when honest folk lock their doors and predators emerge.
The gates are iron-bound and scarred, testament to
past violence. Two guards bar your path, hands resting
on sword hilts. Their eyes are cold, assessing. In
this city, trust is expensive and life is cheap.
```

**Neutral Balanced Sample**:
```
You approach the city gates of Kalinth as the sun
sets. Two guards stand watch, weapons at the ready.
They notice you approaching and one steps forward.
"State your business," he says gruffly. What do you do?
```

#### Step 3: Personality Applied
- **Backend Process**:
  - Personality preset saves to campaign settings
  - System prompt modifier prepared:
    - Dramatic: "You are a dramatic storyteller GM. Use rich, atmospheric descriptions. Focus on emotional impact and cinematic moments."
    - Rules-Focused: "You are a rules-focused tactical GM. Explain mechanics clearly. Provide options and difficulty assessments."
    - Comedic: "You are a comedic, light-hearted GM. Find humor in situations. Don't take things too seriously. Keep tone fun."
    - Dark & Gritty: "You are a dark, serious GM. Emphasize danger and consequences. Use noir atmosphere. The world is harsh."
    - Neutral: "You are a balanced GM. Adapt to player tone. Mix narrative and mechanics naturally."
- **Scope**: Affects narration style ONLY
  - Rules application unchanged
  - Dice rolls still explained clearly (even Dramatic)
  - Mechanics still enforced consistently
- **Confirmation**: "Your GM will be [personality]. You can change this anytime in settings."

#### Step 4: Begin Campaign or Return
- **Campaign Creation**: Proceeds to next step (character creation/start)
- **Settings Change**: Returns to settings screen, takes effect next AI response
- **Player Experience**: Next GM message reflects new personality

### Alternative Paths

#### Path A: Custom Personality Description
```
[Player selects "Custom"]
    ↓
Free-text field appears:
"Describe your GM's personality and style:"
    ↓
Player types: "You're a GM who loves urban intrigue
               and political schemes. You focus on NPC
               motivations and social dynamics."
    ↓
[Saves custom description as system prompt modifier]
    ↓
"Custom GM personality saved. You can edit this
 anytime in settings."
```

#### Path B: Change Personality Mid-Campaign
```
[During active campaign]
    ↓
Player opens Settings
    ↓
Changes GM personality from "Neutral" to "Dramatic"
    ↓
System: "GM personality will update after the next
         message. Current conversation style will
         gradually shift."
    ↓
[Next GM response uses Dramatic personality]
    ↓
Player continues playing with new style
```

#### Path C: Sample Multiple Personalities
```
[Selection screen]
    ↓
Player clicks "Sample" for Dramatic
    ↓
[Reads sample]
    ↓
Player clicks "Sample" for Comedic
    ↓
[Reads sample]
    ↓
Player selects Comedic
    ↓
[Personality applied]
```

### Edge Cases

**Player Changes Personality Multiple Times**:
- Each change takes effect immediately (next AI response)
- No limit on changes
- AI adapts naturally - no jarring shift
- Example: "You notice the tone shifts slightly as your GM adjusts their style"

**Custom Personality Too Long/Short**:
- Validation: Min 20 characters, max 500 characters
- If too short: "Please provide more detail about the personality"
- If too long: "Please shorten to 500 characters or less"

**Custom Personality With Conflicting Instructions**:
- Example: "Be comedic but also terrifying"
- System accepts it - AI will try to honor both
- May produce inconsistent results (player can refine)

**Personality Conflicts With Rules System**:
- Example: "Never explain rules" with Rules-Focused personality
- Rules application ALWAYS happens (non-negotiable)
- Personality affects style, not whether rules are applied
- Rules-Focused might say: "Roll 4dF + Clever (+3) vs Fair (+2)"
- Dramatic might say: "The moment demands cleverness - roll your fate dice, adding your Clever nature (+3), against their suspicion (Fair +2)"
- Both explain the roll, just different styles

**Player Forgets Current Personality**:
- Visible in Settings screen
- Visible in Campaign info panel
- Player can check anytime: "What's my GM personality?" → AI responds with current setting

---

## Notes for Implementation

### UI Considerations

**Chat Interface**:
- Clear visual distinction between GM and Player messages
- Markdown rendering for rich text (bold, italic, lists)
- Inline dice icons for click-to-roll (Step 4 in Core Play Loop)
- Smooth scrolling, auto-scroll to latest message
- Message timestamps (optional display)

**Character Sheet Panel**:
- Always visible on desktop (left panel)
- Real-time updates with pulse animation
- Collapsible on mobile
- Shows: Approaches, Aspects, Stress, Consequences, Fate Points, Inventory

**Scene Context Panel**:
- Current location, NPCs present, Active threads
- Updates automatically as scene changes
- Header area or right panel on desktop
- Collapsible on mobile

**Dice Icon Placement**:
- Inline in GM message, next to roll request
- Small, unobtrusive: 🎲
- Click triggers auto-roll
- Animates briefly when roll completes

**Combat UI (Optional)**:
- Turn indicator: "Your Turn" vs "Bandit's Turn"
- Initiative order display (vertical list)
- NPC stress/status visible (optional, for tactical players)
- Fades in when combat starts, fades out when combat ends

### AI Prompt Engineering

**System Prompt Structure**:
```
You are a game master running a solo Fate Accelerated RPG.

[GM Personality Modifier - inserted here based on selection]

Your role:
- Narrate the story conversationally
- Apply Fate Accelerated rules correctly
- Consult Mythic GME oracle invisibly
- Explain mechanics when needed
- Prompt player for actions and decisions
- Track character state and update automatically

Response guidelines:
- Be concise (2-3 sentences) unless describing important scenes
- Explain rolls clearly: approach, dice notation, difficulty
- Surface mechanics naturally within conversation
- Ask clarifying questions if player intent is ambiguous
- Never force predetermined choices on the player
```

**Context Window Structure**:
1. System prompt (with personality modifier)
2. Rules system reference (Fate Accelerated)
3. Character sheet (current state)
4. Scene context (location, NPCs, threads)
5. Recent conversation (last 20-30 turns)
6. Relevant history (RAG retrieval, top 3-5 chunks)

### State Management

**Chat Session (In-Progress)**:
- Full conversation transcript (in-memory)
- Working character state (uncommitted)
- Working NPC states (uncommitted)
- Current scene context
- Periodic auto-save (every 5 turns or 2 minutes)

**Session Log (Persisted)**:
- Narrative summary (2-3 paragraphs)
- Committed character state
- Committed NPC records
- Committed location records
- Committed thread updates
- Mythic GME state (chaos factor, lists)
- Last 50-100 conversation messages (for context)

**Transition**: Chat Session → Session Log at End Session

### Performance Targets

- **Session start**: Campaign loads + AI recap within 2 minutes
- **AI response**: Median 3 seconds, 95th percentile under 8 seconds
- **Dice roll**: Click-to-roll completes within 500ms
- **Auto-save**: Completes within 5 seconds
- **Session end**: Summary generation + state extraction + commit within 30 seconds
- **Combat handoff**: Seamless, no perceptible delay

### Error Handling

**AI API Failure**:
- Display: "Couldn't reach the AI. Check your connection and try again."
- Retry button available
- Conversation state preserved, no data loss

**State Save Failure**:
- Display: "Couldn't save changes. Your progress is safe in memory. Try closing and reopening the app."
- Auto-retry after 5 seconds
- Backup to recovery file

**Unparseable Dice Roll**:
- GM: "I need the actual number - what did the dice show? Like '+2' or '[-][+][+][0]'?"
- Player retries with valid format
- No progress lost

**Combat Agent Handoff Failure**:
- Fallback: GM Agent continues handling combat
- May be less specialized, but functional
- Log error for debugging

---

## Appendix: Flow Summary Table

| Flow | Frequency | Priority | Complexity | Agent(s) | Decisions |
|------|-----------|----------|------------|----------|-----------|
| **Core Play Loop** | Very High (dozens per session) | MUST HAVE | Medium | GM Agent | 006 |
| **Session Lifecycle** | Medium (1-2 per session) | MUST HAVE | High | GM Agent | 009 |
| **Combat Handoff** | Low (0-2 per session) | SHOULD HAVE | High | GM + Combat Agent | 007 |
| **GM Personality Selection** | Very Low (once per campaign) | SHOULD HAVE | Low | None (settings) | 008 |

---

## Next Steps

1. **Validation with Product Owner**: Walk through each flow to confirm understanding
2. **Wireframe Creation**: @ux-designer creates visual wireframes for each screen state
3. **Requirements Refinement**: @business-analyst updates PRD with any clarifications from flows
4. **Technical Assessment**: @tech-lead reviews flows for implementation complexity and estimates
5. **Combat Walkthrough**: @business-analyst + @ux-designer conduct detailed combat scenario walkthrough (Open Question Q2)

---

*Created: 2025-12-10*
*Phase: Phase 5 - Requirements Definition*
*Based on: Decisions 006-009, PRD v1.0, Solution Concepts*
*Status: Draft for review*
*Confidence: High (based on validated decisions)*
