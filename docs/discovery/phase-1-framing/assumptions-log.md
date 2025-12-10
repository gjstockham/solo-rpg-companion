# Assumptions Log

Track assumptions throughout discovery. Update confidence as we learn more.

## Confidence Levels
- **Validated**: Confirmed through research or testing
- **High**: Strong evidence or direct PO domain expertise
- **Medium**: Reasonable belief, needs validation
- **Low**: Hypothesis, significant uncertainty
- **Invalidated**: Proven false

---

## User & Problem Assumptions

| ID | Assumption | Confidence | Evidence/Source | Risk if Wrong |
|----|------------|------------|-----------------|---------------|
| U1 | Solo RPG players want to focus on "being the player" not managing the game | **Validated** | Community research: 70%+ mention creative fatigue as top challenge | Core value prop fails |
| U2 | 30-60 minute sessions are typical | Medium | PO experience; community research inconclusive | Session design wrong |
| U3 | Players use multiple RPG systems, not just one | **Validated** | Community research: System Explorer segment (25%) rotates frequently | Over-engineer modularity |
| U4 | Players value "surprise" in narrative - want to not know what's coming | **Validated** | Community quotes: "I want to be surprised by the story" | AI approach wrong |
| U5 | Existing tools (Mythic app, VTTs, generic AI) don't solve this well | **Validated** | Competitor analysis: no tool bridges mechanics + AI + persistence | Competitors already solve this |
| U6 | Other solo RPG players share these pain points | **Validated** | Community research: creative fatigue, record-keeping, rules lookup universal | No market beyond PO |

## Solution Assumptions

| ID | Assumption | Confidence | Evidence/Source | Risk if Wrong |
|----|------------|------------|-----------------|---------------|
| S1 | Modular architecture (rules system + oracle system) is the right model | High | Matches how solo RPG works; community wants flexibility | Architecture rework |
| S2 | Structured randomness (Adventure Crafter-style) creates better surprises than pure AI | Medium | PO belief; community skeptical of pure AI ("railroading" concern) | Core mechanic wrong |
| S3 | AI can effectively GM/narrate while respecting rules system constraints | High | Tech assessment: feasible with hybrid approach (code + RAG) | Technical feasibility |
| S4 | Markdown/readable output format is important to users | **Validated** | Community: Journaler segment (40%) values readable output | Over-engineer portability |
| S5 | Local app with BYOK cloud API is the right model | High | PO decision; addresses privacy concerns from community | Distribution model fails |
| S6 | "Player provides dice roll, app interprets" is the right interaction model | Medium | PO preference; needs UX validation | UX friction |
| S7 | AI must be "collaborator not replacement" - suggest, don't dictate | **Validated** | Community research: 60% positive on AI IF agency preserved | Users reject product |

## Technical Assumptions

| ID | Assumption | Confidence | Evidence/Source | Risk if Wrong |
|----|------------|------------|-----------------|---------------|
| T1 | AI can effectively play dual role of GM and Oracle | High | Tech assessment: tool use pattern, proven in similar projects | Core technical risk |
| T2 | Rules systems can be encoded in a way AI can apply consistently | Medium-High | Tech assessment: hybrid approach (Python + RAG) feasible | Major technical risk |
| T3 | Can run locally/self-hosted with acceptable performance | Medium | Tech assessment: local app easy, local LLM needs good hardware | Distribution model fails |
| T4 | Persistent storage of game state is straightforward | High | Tech assessment: SQLite + vector DB proven pattern | Low risk |
| T5 | Context window management for long campaigns is solvable | Medium | Tech assessment: summarization + vector search, needs spike | Campaigns break down |

## Business/Market Assumptions

| ID | Assumption | Confidence | Evidence/Source | Risk if Wrong |
|----|------------|------------|-----------------|---------------|
| B1 | Solo RPG is a meaningful niche with active players | **Validated** | Competitor analysis: 50-100k active players, 20-30% YoY growth | No audience |
| B2 | Open source is viable distribution model for this | High | PO preference; community values transparency | Need monetisation |
| B3 | No direct competitor solves this well today | **Validated** | Competitor analysis: gap between mechanical oracles and AI storytelling | Build vs. use existing |

---

## Research Phase Summary

### Questions Answered

1. **Market validation (B1, U6)**: ✅ Validated
   - 50,000-100,000 active solo RPG players globally
   - Growing 20-30% annually
   - Pain points (creative fatigue, record-keeping, rules lookup) universal

2. **Competitor landscape (B3, U5)**: ✅ Validated
   - No tool combines: AI GM + oracle + rules + persistence
   - Traditional tools: mechanical only (Mythic GME apps)
   - AI tools: narrative only, no game mechanics (AI Dungeon, NovelAI)

3. **Technical feasibility (T1, T2, S3)**: ✅ Feasible with caveats
   - T1 (AI as GM+Oracle): High confidence
   - T2 (Modular rules): Medium-High confidence with hybrid approach
   - T3 (Self-hosted): Medium confidence; recommend cloud LLM for MVP

4. **Surprise mechanics (S2)**: ⚠️ Still needs validation
   - Community supports structured randomness over pure AI
   - Needs prototype testing to confirm

### Remaining Unknowns

| ID | Unknown | How to Validate | Priority |
|----|---------|-----------------|----------|
| S2 | Structured randomness vs pure AI for surprise | Prototype testing | High |
| S6 | Dice input interaction model | UX prototype | Medium |
| U2 | Typical session length | User survey | Low |
| T5 | Context management for long campaigns | Technical spike | High |

---

*Last updated: Phase 2 - Research*
*Next update: Phase 4 - Validation*
