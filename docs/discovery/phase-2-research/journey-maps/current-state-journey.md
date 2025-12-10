# Current State Journey Map

## Overview

How a solo RPG player (Product Owner) currently plays, highlighting pain points and opportunities.

**Tools used today**:
- Laptop with Obsidian vault (one per game)
- Mythic GME app (oracle/scene management)
- Adventure Crafter PDF (plot generation)
- Ruleset PDF/book (D&D 5E variant, Traveller)

---

## Journey Phases

### 1. Session Setup

```
┌─────────────────────────────────────────────────────────────────┐
│ SETUP (5-10 mins)                                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Open laptop → Launch Obsidian → Open game vault                │
│       │                                                         │
│       ▼                                                         │
│  Open Mythic GME app                                            │
│       │                                                         │
│       ▼                                                         │
│  Have Adventure Crafter PDF accessible                          │
│       │                                                         │
│       ▼                                                         │
│  Have ruleset PDF/book nearby                                   │
│                                                                 │
│  😐 Friction: Multiple apps/windows to juggle                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Actions**: Open 4+ different tools, arrange windows
**Feeling**: Administrative, not yet "in the game"
**Pain point**: Context switching between multiple tools before play even begins

---

### 2. Session Start / Re-entry

```
┌─────────────────────────────────────────────────────────────────┐
│ RE-ENTRY (2-5 mins)                                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Sessions end at scene boundaries (deliberate practice)         │
│       │                                                         │
│       ▼                                                         │
│  New scene starts with "story so far" recap                     │
│       │                                                         │
│       ▼                                                         │
│  Review last scene notes in Obsidian                            │
│       │                                                         │
│       ▼                                                         │
│  Ready to play                                                  │
│                                                                 │
│  ✅ Works well: Scene-based structure aids continuity           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Actions**: Read previous scene notes, mentally reconstruct context
**Feeling**: Transitioning into game headspace
**What works**: Ending at scene boundaries makes pickup easier
**Opportunity**: Automated recap could speed this up

---

### 3. Active Play Loop

```
┌─────────────────────────────────────────────────────────────────┐
│ PLAY LOOP (25-50 mins)                                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────┐       │
│  │              MYTHIC GME SCENE STRUCTURE              │       │
│  │                                                      │       │
│  │   Scene Setup → Scene plays out → Scene ends         │       │
│  │        │              │                              │       │
│  │        ▼              ▼                              │       │
│  │   Chaos Factor    Fate Questions                     │       │
│  │   Scene Check     (Yes/No oracle)                    │       │
│  │                                                      │       │
│  └──────────────────────────────────────────────────────┘       │
│                         │                                       │
│                         ▼                                       │
│         ┌───────────────────────────────────┐                   │
│         │      DURING SCENE PLAY            │                   │
│         ├───────────────────────────────────┤                   │
│         │                                   │                   │
│         │  Player decides action            │                   │
│         │       │                           │                   │
│         │       ▼                           │                   │
│         │  Need oracle? ──Yes──► Mythic app │                   │
│         │       │                   │       │                   │
│         │       No                  │       │                   │
│         │       │                   ▼       │                   │
│         │       │          Interpret result │                   │
│         │       │                   │       │                   │
│         │       ▼                   │       │                   │
│         │  Need rules? ──Yes──► Lookup PDF  │ 😐 FRICTION       │
│         │       │                   │       │                   │
│         │       No                  │       │                   │
│         │       │                   ▼       │                   │
│         │       │          Apply rules      │                   │
│         │       │                   │       │                   │
│         │       ▼                   │       │                   │
│         │  Need content? ─Yes─► Create it   │ 😫 FRICTION       │
│         │  (NPC, place,     (on the fly)    │                   │
│         │   encounter)              │       │                   │
│         │       │                   │       │                   │
│         │       No                  │       │                   │
│         │       │                   ▼       │                   │
│         │       └──────► Record in Obsidian │                   │
│         │                       │           │                   │
│         │                       ▼           │                   │
│         │               Next beat           │                   │
│         │                                   │                   │
│         └───────────────────────────────────┘                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Recording structure**:
- One markdown page per scene
- Separate folders for: NPCs, Worldbuilding, etc.
- Manual cross-linking in Obsidian

**Pain points identified**:
1. **Rules lookup** - Breaks flow, switch to PDF, find rule, switch back
2. **On-the-fly content creation** - Need an encounter? NPC? Location? Must create it yourself while also being the player who wants to be surprised

---

### 4. Friction Points (Detail)

| Friction | Frequency | Severity | Current Workaround |
|----------|-----------|----------|-------------------|
| Rules lookup | Every few scenes | Medium | Know common rules, skip edge cases |
| Create encounter on the fly | 1-2 per session | High | Random tables, but still creative burden |
| Create NPC on the fly | 1-2 per session | Medium | Quick name + trait, flesh out later |
| Worldbuilding details | Occasional | Low | Vague it, note for later |
| Juggling multiple apps | Constant | Low-Medium | Muscle memory, but cognitive load |
| Recording while playing | Constant | Low | Brief notes, expand later |

**Highest friction**: Creating content (encounters, NPCs) while trying to stay in player mindset

---

### 5. Session End

```
┌─────────────────────────────────────────────────────────────────┐
│ SESSION END (2-5 mins)                                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Scene reaches natural conclusion                               │
│       │                                                         │
│       ▼                                                         │
│  Finish writing scene notes                                     │
│       │                                                         │
│       ▼                                                         │
│  Update NPC/location files if needed                            │
│       │                                                         │
│       ▼                                                         │
│  Close apps                                                     │
│                                                                 │
│  ✅ Works well: Natural scene endings                           │
│  😐 Could improve: Manual file updates                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Key Insights

### What Works Well
- **Scene-based structure** (from Mythic GME) provides natural session boundaries
- **Obsidian vault** keeps everything organised and searchable
- **Markdown** is readable and portable

### Biggest Opportunities
1. **Unified interface** - One app instead of 4+ tools
2. **AI-generated content** - NPCs, encounters, worldbuilding on demand
3. **Rules integration** - No PDF lookup, system knows the rules
4. **Automatic recording** - Game state tracked without manual notes
5. **Intelligent recap** - "Previously on..." generated automatically

### Emotional Journey

```
Setup      Re-entry     Play (flow)    Friction      Recovery     End
  😐    →    🙂     →      😊      →     😫      →     😐     →   🙂
Admin      Getting      Immersed       Pulled out    Back to      Satisfied
           into it                     of flow       playing
```

The goal: Maximise time in 😊 (flow), minimise 😫 (friction).

---

*Created: Phase 2 - Research*
*Source: Product Owner Q&A*
