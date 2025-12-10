# Solution Concepts: Solo RPG Companion App

**Project**: Solo RPG App
**Phase**: Phase 3 - Ideation
**Date**: 2025-12-09 (Updated)
**Created by**: @ux-designer

---

## Overview

Based on our research findings and Product Owner feedback, we explored three distinct solution concepts. After evaluation, we have selected **Concept 1: The Conversational GM** as our primary approach for MVP.

**Key decisions:**
- **Selected approach**: Chat-first conversational interface (Concept 1)
- **Tech stack**: .NET MAUI + C# with Microsoft Agent Framework (Decision 004)
- **Future enhancement**: Voice input/output (Concept 1b)
- **Rejected**: Quick-action button approaches (Concepts 2 and 3) - felt too mechanical, like "text adventure game" interaction rather than natural GM conversation

This document describes the selected concept, its future evolution, and archived alternatives.

---

## ✅ SELECTED: Concept 1 - The Conversational GM

### One-Line Summary
A chat-based interface where the AI acts as a conversational game master, with the player typing natural language actions and the AI responding like a real GM would.

### Core Interaction Model

**Primary interface**: Chat window (like messaging with a real person)
- Player types actions in natural language: "I try to convince the guard to let me pass"
- AI responds with narrative, handles mechanics conversationally
- Dice rolls woven into conversation naturally
- Oracle consultations happen invisibly, surfaced as story surprises

**Secondary panels** (minimal UI):
- Character sheet (always visible, updates automatically)
- Scene context (current location, active NPCs, threads)
- Game log (scrollable history)

### Visual Structure

```
┌─────────────────────────────────────────────────────────┐
│ [Campaign: Desert Expedition]              [⚙ Settings] │
├────────────────┬────────────────────────────────────────┤
│                │                                        │
│  CHARACTER     │        CONVERSATION                    │
│                │                                        │
│  ┌──────────┐ │  ┌──────────────────────────────────┐ │
│  │ Zara     │ │  │ GM: You approach the city gates. │ │
│  │ Quick: +2│ │  │ Two guards block your path,      │ │
│  │ Clever:+3│ │  │ weapons at the ready.            │ │
│  │ ...      │ │  └──────────────────────────────────┘ │
│  └──────────┘ │                                        │
│                │  ┌──────────────────────────────────┐ │
│  SCENE         │  │ You: I try to convince them I'm │ │
│  ┌──────────┐ │  │ a merchant with business inside  │ │
│  │City Gates│ │  └──────────────────────────────────┘ │
│  │          │ │                                        │
│  │NPCs:     │ │  ┌──────────────────────────────────┐ │
│  │- Guards  │ │  │ GM: That sounds like a Clever    │ │
│  │  (2)     │ │  │ approach. Roll your 4dF and add  │ │
│  └──────────┘ │  │ your Clever (+3)...              │ │
│                │  └──────────────────────────────────┘ │
│  [Game Log]   │                                        │
│                │  ┌──────────────────────────────────┐ │
│                │  │ You: I got +2 on the dice       │ │
│                │  └──────────────────────────────────┘ │
│                │                                        │
│                │  ┌──────────────────────────────────┐ │
│                │  │ GM: So +5 total - excellent! The│ │
│                │  │ guard sighs. "Fine, merchant.    │ │
│                │  │ But no trouble." He steps aside. │ │
│                │  └──────────────────────────────────┘ │
│                │                                        │
├────────────────┴────────────────────────────────────────┤
│ Type your action...                            [Send]   │
└─────────────────────────────────────────────────────────┘
```

### Key Differentiator
Feels like texting with a real GM. No buttons labeled "TALK TO GUARD" or mechanical prompts. Natural conversation flow where mechanics emerge organically within the narrative.

**What this is NOT:**
- Not a text adventure game ("GO NORTH", "> TALK TO GUARD")
- Not mechanical prompts ("Roll for Clever: [ROLL BUTTON]")
- Not predetermined choices (button A, B, C)

**What this IS:**
- A conversation with someone running your game
- Mechanics explained as they become relevant
- Player agency through natural language
- Surprising GM responses (oracle working behind the scenes)

---

## Detailed User Flows

### Flow 1: Session Start

```
[Start]
    │
    ▼
┌─────────────────┐
│ Open app        │
│ See campaigns   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Select campaign │
│ "Desert Exp"    │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ AI loads chat interface                 │
│ Shows recap in conversation:            │
│                                         │
│ GM: "Welcome back! Last time, you       │
│ escaped the bandits and reached the     │
│ gates of Kalinth as the sun set. Ready │
│ to continue?"                           │
└────────┬────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ Player types: "Yes, let's go"           │
│ or "What was I doing again?"            │
│ or jumps right in: "I approach guards"  │
└────────┬────────────────────────────────┘
         │
         ▼
    [In Session]
```

**Key UX principles:**
- Recap feels conversational, not mechanical ("CAMPAIGN STATUS: ...")
- Player can ask questions naturally
- No forced "session start" ritual - just start playing

---

### Flow 2: Dice Roll in Conversation

```
[Player takes action]
    │
    ▼
┌──────────────────────────────────────────┐
│ Player: "I try to convince the guard to  │
│ let me pass"                             │
└────────┬─────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────┐
│ AI analyzes intent:                      │
│ - Action requires roll (risky)           │
│ - Maps to Clever approach (persuasion)   │
│ - Difficulty: Fair (+2)                  │
│ - Action type: Overcome                  │
└────────┬─────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────┐
│ GM: "That sounds like you're being       │
│ Clever. Roll your 4dF and add your       │
│ Clever (+3). You're trying to overcome   │
│ their suspicion."                        │
│                                          │
│ [Brief dice icon animation in corner]    │
└────────┬─────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────┐
│ Player rolls physically or types result: │
│ "I got +2 on the dice"                   │
│ OR "[-][+][+][0] = +2"                   │
│ OR just "+2"                             │
└────────┬─────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────┐
│ AI calculates:                           │
│ - Roll: +2                               │
│ - Bonus: +3 (Clever)                     │
│ - Total: +5                              │
│ - vs Difficulty +2                       │
│ - Margin: +3 (strong success)            │
└────────┬─────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────┐
│ GM: "So +5 total - excellent! You launch │
│ into a story about urgent merchant       │
│ business. The older guard's eyes narrow, │
│ but eventually he sighs and nods.        │
│ 'Alright, but no trouble.' He steps      │
│ aside and you're through."               │
│                                          │
│ [Character sheet updates: stress, scene] │
└────────┬─────────────────────────────────┘
         │
         ▼
    [Next action]
```

**Key UX principles:**
- GM explains WHY a roll is needed (like a real GM would)
- GM identifies the approach being used
- Player reports dice result (not pushing a button)
- GM narrates outcome based on success level
- Mechanics happen within conversation flow

**Alternative flows:**
- **Auto-roll option**: Player can enable "auto-roll" in settings, AI rolls and reports
- **Failure case**: GM explains consequence, offers follow-up choices conversationally
- **Ambiguous action**: If unclear, GM asks: "Are you trying to charm them (Flashy) or reason with them (Clever)?"

---

### Flow 3: Oracle Consultation (Invisible)

```
[Player asks question]
    │
    ▼
┌──────────────────────────────────────────┐
│ Player: "I ask the guard if there's a    │
│ good inn nearby"                         │
└────────┬─────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────┐
│ AI determines:                           │
│ - This is a yes/no question              │
│ - About world state (not predetermined)  │
│ - Consult oracle: "Is there a good inn?" │
└────────┬─────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────┐
│ AI uses Mythic GME:                      │
│ - Chaos Factor: 5                        │
│ - Likelihood: Likely (guard would know)  │
│ - Roll: d100 = 42                        │
│ - Result: Yes                            │
│ - Random event check: No                 │
└────────┬─────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────┐
│ GM: "The guard grunts. 'Golden Lamb,     │
│ two streets over. Clean beds, decent     │
│ food. Tell Marta I sent you - might get  │
│ a discount.'"                            │
│                                          │
│ [No visible oracle UI - just answer]     │
└────────┬─────────────────────────────────┘
         │
         ▼
    [Next action]
```

**Key UX principles:**
- Oracle is invisible - player experiences only the answer
- No "ROLLING ORACLE..." message
- Feels like GM making a decision (which it is)
- Creates surprise and discovery

**When oracle IS visible:**
- **Player explicitly requests it**: "Ask the oracle if..." triggers visible consultation
- **Settings option**: "Show oracle rolls" for transparency
- **Game log**: Oracle rolls recorded in background log (for review)

---

### Flow 4: Natural Mechanics Surfacing

```
[Player damaged in combat]
    │
    ▼
┌──────────────────────────────────────────┐
│ GM: "The bandit's blade catches your     │
│ shoulder - you take 2 stress. You're at  │
│ 3/4 stress now. If you take one more,    │
│ you'll need to take a consequence."      │
│                                          │
│ [Character sheet updates: stress boxes]  │
└────────┬─────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────┐
│ Player sees stress visually but acts     │
│ narratively: "I fall back and try to     │
│ find cover"                              │
└────────┬─────────────────────────────────┘
         │
         ▼
    [Continues naturally]


[Later, player takes 4th stress]
    │
    ▼
┌──────────────────────────────────────────┐
│ GM: "The second guard lands a solid hit. │
│ Your stress boxes are full - you need to │
│ take a consequence. What happens? Maybe  │
│ a 'Twisted Ankle' or 'Bleeding Wound'?"  │
└────────┬─────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────┐
│ Player: "I'll take 'Bruised Ribs' as a   │
│ mild consequence"                        │
└────────┬─────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────┐
│ GM: "Got it. You feel your ribs ache as  │
│ you move. That'll give you -2 on        │
│ physical actions until you recover.      │
│ What do you do?"                         │
│                                          │
│ [Character sheet adds consequence]       │
└────────┬─────────────────────────────────┘
         │
         ▼
    [Next action]
```

**Key UX principles:**
- Mechanics explained when they become relevant
- GM offers guidance: "You'll need to take a consequence"
- Player participates in mechanical decisions narratively
- Rules surface as conversation, not interruption

---

### Flow 5: AI Signaling (GM Communication Patterns)

The AI needs clear patterns for different types of communication:

#### Pattern A: Narration (GM is telling story)

```
GM: "You push through the crowded marketplace.
The smell of spices and roasted meat fills the
air. Ahead, you spot the Golden Lamb's sign
swinging in the evening breeze."

[No prompt - player can act when ready]
```

**Characteristics:**
- Descriptive, scene-setting
- No immediate question
- Player acts when inspired

#### Pattern B: Prompt for Action (GM needs player input)

```
GM: "The innkeeper eyes you suspiciously.
'We don't get many travelers this time of year,'
she says. 'What brings you to Kalinth?'

What do you say?"

[Clear prompt - player should respond]
```

**Characteristics:**
- Ends with question or prompt
- NPC waiting for response
- Clear moment for player action

#### Pattern C: Mechanical Prompt (dice roll needed)

```
GM: "You hear footsteps behind you - someone's
following. You have a moment to act.

If you want to confront them, that's Forceful.
Slip away unnoticed? That's Sneaky. What do
you do?"

[Explaining options, waiting for approach]
```

**Characteristics:**
- Explains mechanical options
- Clarifies approaches available
- Waits for player decision before rolling

#### Pattern D: Rule Explanation (teaching moment)

```
GM: "Since this is the first time you're creating
an advantage in this campaign, let me explain:
when you succeed, you create a temporary aspect
you can invoke later. You'll get one free use,
then it costs a fate point.

Ready to roll Clever?"

[Educational, then proceeds]
```

**Characteristics:**
- Explicitly teaching
- Clear transition back to action
- Only when needed (first-time, complex rule)

---

### Flow 6: Session End

```
[Player ready to stop]
    │
    ▼
┌──────────────────────────────────────────┐
│ Player: "I think I'll stop here for      │
│ tonight"                                 │
│ OR "End session"                         │
│ OR just closes app                       │
└────────┬─────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────┐
│ GM: "Great session! You're currently at  │
│ the Golden Lamb inn, and you've learned  │
│ about the warehouse fire. Want me to     │
│ summarize where we left off?"            │
└────────┬─────────────────────────────────┘
         │
    ┌────┴────┐
    │         │
   Yes       No
    │         │
    ▼         ▼
┌─────┐   ┌──────┐
│Shows│   │Saves │
│recap│   │state │
└──┬──┘   └──┬───┘
   │         │
   └────┬────┘
        │
        ▼
┌──────────────────────────────────────────┐
│ [Auto-save triggered]                    │
│ - Current scene state                    │
│ - NPC statuses                           │
│ - Threads/aspects                        │
│ - Character sheet                        │
│ - Conversation log (last 50 messages)    │
└────────┬─────────────────────────────────┘
         │
         ▼
   [App closes or
    returns to menu]
```

**Key UX principles:**
- Natural exit ("I think I'll stop here")
- AI offers summary (helps player remember next time)
- Auto-save (no explicit save action needed)
- Can close app anytime (saves on close)

---

## Handling Edge Cases

### Edge Case 1: Ambiguous Player Input

```
Player: "I deal with the guard"

GM: "How do you want to deal with them?
Are you trying to talk your way through,
sneak past, or something else?"

[AI asks for clarification rather than assuming]
```

### Edge Case 2: Impossible Action

```
Player: "I fly over the wall"

GM: "You don't have any magic or equipment
that would let you fly. Did you mean climb
the wall, or look for another way in?"

[AI gently redirects, offers alternatives]
```

### Edge Case 3: Asking About Rules

```
Player: "How does stress work again?"

GM: "You have 4 stress boxes. When you take
a hit, you mark boxes equal to the shifts.
When they're full, you take a consequence
(mild, moderate, or severe) to absorb more
damage. Want me to explain consequences?"

[AI switches to teaching mode, then back to game]
```

### Edge Case 4: Meta Questions

```
Player: "What's my Clever bonus?"

GM: "Your Clever is +3. [It's shown in your
character sheet on the left, too.] What are
you thinking of doing?"

[AI answers directly, guides back to action]
```

### Edge Case 5: Talking to AI vs Talking In-Character

```
Player: "I say 'Hello, guard'"

GM: "The guard nods curtly. 'State your
business.'"

[AI recognizes this as in-character speech]


Player: "Show me my stress"

GM: "You're at 3/4 stress. Your character
sheet on the left shows this too."

[AI recognizes this as meta/UI question]
```

**Pattern recognition:**
- "I say..." = in-character speech
- "Show me...", "What's my...", "How does..." = meta questions
- "I try to...", "I want to..." = action declarations

---

## Implementation Notes

### Visual Design
- **Markdown rendering** for narrative richness (italic for emphasis, bold for mechanics)
- **Clear visual distinction** between GM and player messages
- **Subtle dice icon** appears briefly when rolls happen (corner of message)
- **Character sheet updates** highlighted briefly (pulse animation)
- **Export as markdown** - conversation log becomes readable play report

### AI Prompt Engineering
- **System prompt** establishes conversational GM persona
- **Context window** includes: character sheet, scene state, active threads, recent history
- **Response style guide**: narrative first, mechanics second, always prompt for next action
- **Rule lookup**: AI has Fate Accelerated + Mythic GME rules in context
- **Oracle integration**: Silent unless player explicitly invokes

### Conversation Management
- **Message threading**: Group related exchanges (action → roll → outcome)
- **History limit**: Keep last 50 messages in active view, rest in scrollable log
- **Search/filter**: Player can search history for keywords
- **Bookmarks**: Player can mark important moments

### Mobile Considerations
- Chat interface works well on mobile (familiar pattern)
- Character sheet collapses to icon (tap to expand)
- Scene context in header bar (tap to expand)
- Voice input available (device speech-to-text)
- Future: Native voice mode (Concept 1b)

---

## Strengths of This Approach

1. **Low learning curve** - Everyone knows how to chat
2. **High immersion** - Feels like playing with a real GM
3. **Natural place for AI** - Conversational generation is what LLMs do best
4. **Mobile-friendly** - Chat works great on phones
5. **Handles ambiguity** - AI can ask clarifying questions naturally
6. **Player agency** - Can say anything, not limited to buttons
7. **Surprise friendly** - Oracle works invisibly to create discovery
8. **Accessible** - No complex UI to learn, just type what you want to do
9. **Future-proof** - Easy to add voice input/output (Concept 1b)

---

## Weaknesses & Mitigations

### Weakness 1: Can feel slow (lots of typing)
**Mitigation:**
- Voice input available (device speech-to-text for MVP)
- Quick actions: "I do that" or "Yes" or "Continue"
- Future: Voice mode (Concept 1b)

### Weakness 2: Rules/mechanics less visible
**Mitigation:**
- Character sheet always visible
- Game log shows all rolls and mechanics
- Settings option: "Show detailed mechanics" (more explicit roll messages)
- Help command: "Explain [rule]"

### Weakness 3: Scrolling to find information
**Mitigation:**
- Character sheet panel always visible
- Scene context panel shows current state
- Search/filter in game log
- Bookmarks for important moments

### Weakness 4: Risk of AI being verbose
**Mitigation:**
- AI prompt guidance: "Be concise, 2-3 sentences unless describing important scene"
- User setting: "Narration style" (terse / balanced / rich)
- AI learns from player pace (short responses → shorter GM responses)

### Weakness 5: Hard to "take back" actions
**Mitigation:**
- "Wait, I meant..." is valid input
- AI can rewind: "Let's back up - what did you want to do instead?"
- Explicit "undo last action" command

---

## 🔮 FUTURE: Concept 1b - Voice-Enhanced GM

### One-Line Summary
The conversational GM interface enhanced with voice input/output for hands-free, fully immersive play.

### Addition to Core Interaction
Everything from Concept 1, PLUS:
- **Voice input**: Speak your actions instead of typing
- **Voice output**: AI GM speaks responses (TTS with personality)
- **Mixed mode**: Switch between voice and text seamlessly
- **Natural pauses**: AI detects when you're thinking vs when you're done speaking

### Use Cases
- **Hands-free play**: While commuting, doing chores, lying in bed
- **Accessibility**: For users with typing difficulties
- **Immersion**: Feels even more like playing with a real GM
- **Speed**: Faster than typing for many users

### Implementation Path
1. **MVP**: Text-based chat (Concept 1)
2. **Phase 2**: Add voice input (device speech-to-text)
3. **Phase 3**: Add voice output (TTS with GM personality)
4. **Phase 4**: Optimize for voice conversation (better pause detection, interrupt handling)

### Technical Considerations
- **Voice input**: Use platform speech-to-text (Windows, Mac, iOS, Android all have native support)
- **Voice output**: TTS engines available (.NET speech synthesis, cloud options)
- **Personality**: Adjust TTS parameters (pitch, rate, volume) for "GM voice"
- **Interrupt handling**: Push-to-talk or voice activation
- **Noise environments**: Text fallback always available

### Why Not in MVP?
- Core interaction pattern (conversational) works with text first
- Proves the concept without additional complexity
- Voice is additive enhancement, not required for core experience
- Faster to MVP = faster validation

---

## 📦 ARCHIVED: Alternative Concepts

The following concepts were explored but not selected. They are documented here for reference and to capture the thinking behind the decision.

---

## ❌ ARCHIVED: Concept 2 - The Structured Scene Player

### Why Not Selected
**Rejected by Product Owner** - Button-based actions felt too mechanical, like "text adventure game" interaction (e.g., "> TALK TO GUARD"). This approach creates a "menu-driven" feel rather than natural GM conversation.

### One-Line Summary
A panel-based interface that breaks play into discrete scenes, with structured prompts guiding the player through oracle-driven decisions and clear action choices.

### Core Interaction Model
**Primary interaction**: Button-based actions with occasional text input
- Each scene presents: situation description, possible actions (buttons), and scene status
- Player selects actions from AI-generated options or types custom action
- Oracle mechanics visible and explicit (chaos factor, scene checks)
- Rules calculations shown clearly with visual feedback

### Why This Was Interesting
- Made oracle mechanics transparent
- Gave players clear choices
- Reduced cognitive load through structure
- Good for learning solo RPG systems

### Why It Didn't Work
- Too mechanical - "Press button A or B" vs "What do you do?"
- Reminded PO of text adventure games (The Hobbit on ZX Spectrum)
- Suggested actions might not match player intent
- Felt less like playing with a GM, more like playing a computer game
- Button-heavy UI vs conversational flow

### Lessons Applied to Selected Concept
- Keep mechanics visible through character sheet and game log
- Offer guidance through AI suggestions in conversation, not buttons
- Structure through scene context panel, not rigid scene boundaries

---

## ❌ ARCHIVED: Concept 3 - The Director's Cut (Hybrid)

### Why Not Selected
**Added complexity without clear value** - Two-mode switching (Quick Mode with buttons, Detail Mode with text) added cognitive overhead. The chat-first approach (Concept 1) already supports both quick actions ("I do that") and detailed descriptions naturally, without mode switching.

### One-Line Summary
A hybrid interface with "Quick Mode" (button-based shortcuts) and "Detail Mode" (text input), letting players control fidelity and pacing.

### Core Interaction Model
**Two modes**:
1. **Quick Mode**: Button-based shortcuts for common actions
2. **Detail Mode**: Full text input for important moments
3. **Mode switching**: Player toggles between them

### Why This Was Interesting
- Player controls pacing (fast-forward boring, slow down important)
- Combines speed of buttons with depth of text
- Unique approach to the pacing problem

### Why It Didn't Work
- Mode switching adds cognitive load: "Which mode should I be in?"
- Quick Mode buttons have same problem as Concept 2 (mechanical feel)
- Conversation (Concept 1) already supports quick responses: "Yes", "I do that", "Continue"
- No need for separate mode - just type more or less detail as needed
- More complex to design and implement
- Risk of users staying in one mode and never switching

### Lessons Applied to Selected Concept
- Support variable detail naturally: short or long inputs both work
- AI adapts to player style (short inputs → terser responses)
- No mode switching needed - conversation handles pacing organically

---

## Decision Rationale

### Why Concept 1 (Conversational GM)?

**Alignment with Vision:**
- Product vision: "Feel like playing with a real GM"
- Real GMs don't present button choices - they have conversations
- Most immersive option - AI doing what it does best (conversation)

**User Needs:**
- Alex (primary persona): Wants immersion and surprise, values natural flow
- Morgan (secondary persona): Conversational format produces readable narrative
- Low learning curve - everyone knows how to chat

**Technical Fit:**
- LLMs excel at conversational interaction
- C# + Microsoft Agent Framework has strong conversation support
- Simpler UI to implement than hybrid or button-heavy approaches
- Foundation for voice enhancement (Concept 1b)

**Differentiation:**
- No competitor offers truly conversational solo RPG experience
- Most apps are button-driven or structured
- Voice-enhanced future (Concept 1b) is unique in market

### Trade-offs Accepted

**We're accepting:**
- Some users may prefer explicit button choices (minority based on research)
- Typing may feel slower than buttons for some actions
- Rules/mechanics slightly less visible than structured approach

**We're gaining:**
- Much higher immersion for target users
- Natural AI interaction pattern
- Future voice enhancement path
- Simpler, more focused MVP

---

## Next Steps

1. **Create detailed wireframes** for chat interface
   - Desktop layout (character sheet + chat + scene context)
   - Mobile layout (collapsible panels, chat-focused)
   - Message styling (GM vs Player, mechanics vs narrative)

2. **Define AI conversation patterns**
   - System prompt structure
   - Response templates (narration, prompts, mechanics, teaching)
   - Rule lookup integration
   - Oracle invocation patterns

3. **User flow documentation**
   - Complete session flow (start to end)
   - Combat scenario (multiple rolls, stress, consequences)
   - Oracle surprise flow (random event)
   - Character advancement flow

4. **Handoff to @business-analyst**
   - Requirements for conversation engine
   - Message format specifications
   - Character sheet update triggers
   - Game state persistence requirements

5. **Validation planning** (Phase 4)
   - Test with Alex-like users (narrative explorers)
   - Key questions: Does this feel like a GM? Is it too slow? Are mechanics clear enough?
   - Prototype: High-fidelity chat UI with simulated AI responses

---

*Created: Phase 3 - Ideation*
*Updated: 2025-12-09 after Product Owner feedback*
*Based on: Problem statement, personas, journey maps, competitor analysis, technical assessment*
*Key decisions: Decision 004 (Tech stack), Decision 005 (Interaction model)*
*Status: Concept 1 selected for MVP, Concept 1b planned for future phase*
*Confidence: High (validated with Product Owner)*
