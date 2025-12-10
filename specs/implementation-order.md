# Implementation Order Checklist

Recommended development order for Solo RPG Companion App MVP, organized by phase with dependencies respected.

---

## Phase A: Core Loop & Foundation (Weeks 1-3)

### Week 1: Project Setup & Basic UI
- [ ] Project Setup (Electron + React scaffolding, TypeScript config, build tooling)
- [ ] [FB-003] Chat Interface UI
- [ ] [Spike 4] Combat Validation Walkthrough (parallel)

### Week 2: AI Integration & Rules Foundation
- [ ] [FB-010] AI Conversation Engine
- [ ] [FB-020] Fate Accelerated Rules Package
- [ ] [FB-060] Markdown File Management
- [ ] [Spike 3] Dice Rolling UX Decision

### Week 3: Dice Rolling & Character Display
- [ ] [FB-021] Dice Roll Request & Explanation
- [ ] [FB-022] Physical Dice Result Input
- [ ] [FB-023] Click-to-Roll Digital Dice
- [ ] [FB-026] Action Intent Mapping
- [ ] [FB-004] Character Sheet Panel
- [ ] [FB-011] Natural Language Action Input
- [ ] [FB-012] AI Response Patterns
- [ ] [FB-014] AI Tool Registration

**Phase A Validation Checkpoint**

---

## Phase B: Oracle & Rules Integration (Weeks 4-6)

### Week 4: Oracle Foundation
- [ ] [FB-040] Mythic GME Yes/No Oracle
- [ ] [FB-041] Chaos Factor Tracking
- [ ] [FB-025] Rules RAG Implementation

### Week 5: Random Events & RAG Validation
- [ ] [FB-042] Random Event Checks
- [ ] [Spike 2] Rules Consistency Validation
- [ ] [FB-044] Oracle Transparency Setting

### Week 6: Aspects, Consequences & World Files
- [ ] [FB-027] Aspect Invoke Prompting
- [ ] [FB-028] Consequence Selection Flow
- [ ] [FB-043] NPC/Thread/Location Lists
- [ ] [FB-056] NPC/Location File Generation
- [ ] [FB-005] Scene Context Panel

**Phase B Validation Checkpoint**

---

## Phase C: Session Lifecycle & Persistence (Weeks 7-10)

### Week 7: Campaign Management
- [ ] [FB-001] Campaign Folder Selection
- [ ] [FB-002] Campaign Creation
- [ ] [FB-050] Campaign Loading

### Week 8: Session Flow
- [ ] [FB-051] Session Start with AI Recap
- [ ] [FB-052] Chat Session (In-Progress)
- [ ] [FB-054] Message-by-Message Save & Recovery
- [ ] [FB-061] Session State Model (Two-Tier)

### Week 9: Session End & Character State
- [ ] [FB-053] Session End & Summary Generation
- [ ] [FB-055] Character State Auto-Update
- [ ] [FB-062] Conversation Log Persistence

### Week 10: Search & Context
- [ ] [FB-063] Vector Store for Semantic Search
- [ ] [FB-064] SQLite Search Indexes
- [ ] [FB-013] Context Management
- [ ] [Spike 1] Long Campaign Context Management

**Phase C Validation Checkpoint**

---

## Phase D: Polish & Validation (Weeks 11-14)

### Week 11: Settings & UI Polish
- [ ] [FB-006] Settings Screen
- [ ] [FB-007] Conversation History Display
- [ ] [FB-008] Markdown Rendering in Chat
- [ ] [FB-065] Campaign Export
- [ ] [FB-084] Session Export (Documentation)

### Week 12: Additional Features
- [ ] [FB-024] Auto-Roll Dice Setting
- [ ] [FB-029] First-Time Mechanic Explanation
- [ ] [FB-080] GM Personality Presets (stretch)
- [ ] [FB-082] Narration Style Preference (stretch)

### Week 13: User Testing & Bug Fixes
- [ ] Beta Testing (5-10 users)
- [ ] Bug Fixes

### Week 14: Final Polish & Release Prep
- [ ] Performance Optimization
- [ ] Final Testing
- [ ] Beta Release Preparation

### Stretch Goals (if time permits)
- [ ] [FB-070] Combat Encounter Detection
- [ ] [FB-071] Combat Agent Implementation
- [ ] [FB-072] Initiative & Turn Order
- [ ] [FB-073] Multi-NPC Stress Tracking

**Phase D Validation Checkpoint**

---

## Post-MVP (Phase 2+)

- [ ] [FB-081] Custom Personality Description
- [ ] [FB-083] Conversation Search & Filter
- [ ] [Spike 5] Graph RAG Exploration
- [ ] Tales of the Valiant Rules System (validates modularity)
