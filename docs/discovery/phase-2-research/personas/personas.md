# User Personas

## Overview

Three personas representing the spectrum of solo RPG players. Based on Product Owner domain expertise and community research.

**Primary target:** Narrative Explorer (matches PO profile, largest segment)

---

## Persona 1: The Narrative Explorer (Primary)

### Profile

| Attribute | Detail |
|-----------|--------|
| Name | Alex |
| Archetype | Story-focused solo player |
| Experience | Veteran RPG player (10+ years) |
| Play style | Narrative-heavy, character-driven |
| Session length | 30-60 minutes |
| Frequency | 2-3 times per week |

### Context

Alex has played tabletop RPGs for years but struggles to find a regular group due to work and family commitments. Solo RPG lets them scratch the itch on their own schedule. They're drawn to the emergent storytelling that comes from oracle-driven play.

### Current Setup
- **Rules**: D&D 5E variants, Traveller, Fate
- **Oracle**: Mythic GME + Adventure Crafter for plot generation
- **Recording**: Obsidian vault with markdown files per scene
- **Platform**: Laptop

### Goals
- Experience surprising, emergent narratives
- Focus on playing their character, not managing the game
- Build rich worlds with persistent NPCs and locations
- Resume sessions easily after days/weeks away

### Frustrations
- Creative fatigue from generating content while trying to be surprised
- Rules lookup breaks immersion
- Juggling multiple apps (Obsidian, Mythic app, PDFs)
- Creating encounters/NPCs on the fly

### Quote
> "I want to be surprised by the story. But when I'm the one making up the NPC's reaction, it's hard to feel that surprise."

### What Success Looks Like
- Sit down, open one app, be "in the game" in 2 minutes
- AI generates content that genuinely surprises them
- Never need to look up a rule mid-scene
- Everything tracked automatically

---

## Persona 2: The Journaler (Secondary)

### Profile

| Attribute | Detail |
|-----------|--------|
| Name | Morgan |
| Archetype | Creative writer using RPG as framework |
| Experience | Moderate RPG experience (2-5 years) |
| Play style | Journaling, prose-heavy, light mechanics |
| Session length | 45-90 minutes |
| Frequency | Weekly |

### Context

Morgan discovered solo RPG through journaling games like Ironsworn and Thousand Year Old Vampire. They're less interested in tactical mechanics and more in using RPG structure as a creative writing prompt. The oracle provides just enough randomness to spark unexpected story directions.

### Current Setup
- **Rules**: Ironsworn, Wanderhome, light/narrative systems
- **Oracle**: Built into the game system, or simple d6 tables
- **Recording**: Longform prose in dedicated writing app or physical journal
- **Platform**: Mix of digital and analog

### Goals
- Create compelling written narratives
- Use randomness as creative catalyst
- Build character-driven stories
- Produce something they can read back later

### Frustrations
- Mechanics can feel intrusive to writing flow
- Generic AI output feels "soulless"
- Wants evocative prompts, not fully-written content

### Quote
> "I don't want the AI to write my story. I want it to throw interesting curveballs that I then write about."

### What Success Looks Like
- Evocative prompts that inspire, not replace, creativity
- Minimal mechanical interruption
- Beautiful output format for their journal
- Tone matching their preferred genre

### Relevance to Our Product
- Secondary user - may use some features
- Key insight: AI should prompt, not write for them
- Export/markdown output matters to this persona

---

## Persona 3: The System Tester (Tertiary)

### Profile

| Attribute | Detail |
|-----------|--------|
| Name | Jordan |
| Archetype | RPG collector and system explorer |
| Experience | Deep RPG knowledge, owns many systems |
| Play style | One-shots, system evaluation |
| Session length | 1-2 hours |
| Frequency | Sporadic (when new system acquired) |

### Context

Jordan owns dozens of RPG PDFs and enjoys trying new systems before introducing them to their group. Solo play is a testing ground - they want to understand how a system feels in play, not just read the rules.

### Current Setup
- **Rules**: Whatever's new (rotates frequently)
- **Oracle**: Flexible tools that work with any system
- **Recording**: Quick notes, not detailed journals
- **Platform**: Desktop with multiple monitors for PDFs

### Goals
- Quickly learn how a system plays
- Test character builds and mechanics
- Evaluate if system is worth running for group
- Minimal setup time per system

### Frustrations
- Adapting group-focused rules for solo
- Constant alt-tabbing between oracle, PDF, notes
- Forgetting rules between different systems
- Setup overhead for one-shot exploration

### Quote
> "I probably own 50 RPG PDFs. I love trying new systems solo before committing to a group campaign."

### What Success Looks Like
- Add a new system quickly (days, not weeks)
- Rules accessible without PDF diving
- Flexible oracle that adapts to any system
- Low friction one-shot setup

### Relevance to Our Product
- Tertiary user for MVP
- Key insight: Modularity matters - easy to add new systems
- Validates the multi-system architecture vision

---

## Persona Prioritisation

| Persona | Priority | Rationale |
|---------|----------|-----------|
| Alex (Narrative Explorer) | Primary | Matches PO, largest segment (~40%), clearest problem-solution fit |
| Morgan (Journaler) | Secondary | Partial overlap, values AI collaboration over AI generation |
| Jordan (System Tester) | Tertiary | Validates modularity, but MVP focuses on one system |

### MVP Focus: Build for Alex

**Core features:**
- AI-powered GM/oracle with surprise generation
- Persistent game state (NPCs, locations, history)
- Fate Accelerated rules integration
- Mythic GME oracle integration
- Single unified interface

**Features that also serve Morgan:**
- Quality narrative output
- Markdown/export options
- Evocative (not prescriptive) prompts
- Player agency preserved

**Features deferred (Jordan's needs):**
- Multi-system support (post-MVP)
- Quick system onboarding
- System comparison tools

---

## Key Design Principles (From Personas)

1. **AI as collaborator, not author** - Suggest, don't dictate
2. **Player agency is sacred** - Always allow override/edit
3. **Reduce friction, not creativity** - Handle tedious tasks, enhance creative ones
4. **One tool, not five** - Unified experience beats best-of-breed
5. **Memory matters** - Campaign continuity is a core value proposition

---

*Created: Phase 2 - Research*
*Sources: Product Owner domain expertise, community research*
*Confidence: High (primary persona), Medium (secondary/tertiary)*
