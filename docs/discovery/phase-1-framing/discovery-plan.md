# Discovery Plan

## Project Overview

**Product concept**: AI-powered solo RPG companion that handles GM duties, oracle functions, and record-keeping so players can focus on playing.

**Product Owner**: Solo RPG enthusiast with domain expertise in target user needs.

**Distribution model**: Open source, self-hosted.

---

## Discovery Approach

This is a Q&A-based discovery where the Product Owner provides domain expertise. We'll supplement with:
- Competitor research (desk research)
- Technical feasibility spikes
- Community validation (optional, if PO wants external input)

---

## Phase Plan

### Phase 1: Framing (Current)

**Objective**: Align on problem, document assumptions, identify risks.

**Activities**:
- [x] Problem space exploration (Q&A)
- [x] Draft problem statement
- [x] Create assumptions log
- [x] Discovery plan
- [ ] Review and approve artifacts

**Outputs**:
- [problem-statement.md](problem-statement.md)
- [assumptions-log.md](assumptions-log.md)
- [discovery-plan.md](discovery-plan.md) (this document)

**Gate**: PO approves problem statement and assumptions are logged.

---

### Phase 2: Research & Exploration

**Objective**: Validate assumptions, understand landscape, deepen user understanding.

**Activities**:
| Activity | Owner | Approach |
|----------|-------|----------|
| Competitor analysis | BA | Desk research on existing solo RPG tools, AI RPG projects |
| Community sentiment | User Researcher | Review Reddit r/solorpg, forums for pain points |
| Technical landscape | Tech Lead | Review AI agent frameworks, persistence patterns |
| User personas | UX Designer | Based on PO knowledge + community research |
| Current journey map | UX Designer | Map how PO plays today |

**Key questions to answer**:
1. What tools do solo RPG players currently use?
2. Are there AI-powered competitors? What do they lack?
3. What agent frameworks suit this use case?
4. What's the spectrum of solo RPG players (casual to hardcore)?

**Outputs**:
- Research findings summary
- Competitor analysis
- Personas (1-2)
- Current state journey map
- Updated assumptions log

**Gate**: Key assumptions validated or flagged, clear understanding of landscape.

---

### Phase 3: Ideation & Concept Development

**Objective**: Generate solution concepts, evaluate feasibility.

**Activities**:
| Activity | Owner | Approach |
|----------|-------|----------|
| Solution brainstorming | UX Designer | Q&A with PO on solution ideas |
| Technical feasibility | Tech Lead | Spike on AI + game state |
| Concept documentation | BA | Document 2-3 approaches |
| Evaluation criteria | PO | Define what matters most |

**Key decisions**:
- Platform (web, CLI, filesystem-based)
- Architecture (monolith vs. modular agents)
- AI model approach (local vs. cloud, which models)
- Rules encoding approach

**Outputs**:
- 2-3 concept descriptions
- Feasibility assessment
- Evaluation matrix
- Selected concept with rationale

**Gate**: One concept selected for deeper development.

---

### Phase 4: Concept Validation

**Objective**: Stress-test the concept, identify gaps.

**Activities**:
| Activity | Owner | Approach |
|----------|-------|----------|
| Concept walkthrough | All | Review against user needs |
| Technical prototype | Tech Lead | Minimal spike to test core mechanic |
| Edge case identification | BA | Q&A on failure modes |
| Refinement | UX Designer | Iterate based on findings |

**Key questions**:
- Does the AI maintain coherent state?
- Does structured randomness create surprise?
- Can rules be applied consistently?
- What happens when AI makes mistakes?

**Outputs**:
- Validation findings
- Refined concept
- Technical spike learnings
- Go/no-go decision

**Gate**: Confidence that concept is viable, or pivot decision.

---

### Phase 5: Requirements Definition

**Objective**: Translate concept into clear requirements.

**Activities**:
| Activity | Owner | Approach |
|----------|-------|----------|
| Requirements elicitation | BA | Structured Q&A |
| User flows | UX Designer | Key interaction paths |
| NFR definition | Tech Lead | Performance, scale, security |
| Wireframes | UX Designer | Key screens |
| PRD creation | BA | Consolidate all requirements |

**Outputs**:
- Product Requirements Document (PRD)
- User flows
- Wireframes
- Domain glossary
- Success metrics

**Gate**: PRD complete and approved.

---

### Phase 6: MVP Scoping & Prioritisation

**Objective**: Define what to build first.

**Activities**:
| Activity | Owner | Approach |
|----------|-------|----------|
| Feature extraction | BA | From PRD |
| Effort estimation | Tech Lead | T-shirt sizing |
| Prioritisation | PO | Value vs. effort |
| MVP scope | PO | Draw the line |
| Roadmap | BA | Sequence features |

**Outputs**:
- Feature backlog
- MVP scope definition
- Feature roadmap
- Risk register

**Gate**: Clear MVP scope ready for implementation planning.

---

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| AI can't maintain coherent game state | Medium | High | Early technical spike in Phase 3-4 |
| Rules encoding too complex | Medium | High | Start with simpler systems (Fate, Ironsworn) |
| No market beyond PO | Low | Medium | Community research in Phase 2 |
| Scope creep (too many systems) | High | Medium | MVP focuses on one rules + one oracle system |
| "Surprise" mechanic doesn't work | Medium | High | Test structured randomness early |

---

## Next Steps

1. **PO to review** problem statement and assumptions log
2. **Approve or refine** Phase 1 artifacts
3. **Proceed to Phase 2** research activities

---

*Created: Phase 1 - Framing*
