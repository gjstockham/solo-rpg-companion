# Recommended Claude Code Skills/Agents for Implementation

Based on the PRD, MVP scope, and technical architecture (.NET MAUI + C# + Semantic Kernel), here are the skills recommended for implementing the Solo RPG Companion App.

---

## Skill Definitions

### 1. `dotnet-maui` - .NET MAUI Development Expert

**Purpose:** Specialized knowledge for building cross-platform desktop apps with .NET MAUI

**Should know:**
- MAUI project structure and configuration
- XAML vs Blazor Hybrid UI patterns
- Platform-specific code (Windows/macOS)
- Dependency injection in MAUI
- Navigation patterns
- SecureStorage for API keys (FR-054)
- File system access for campaign folders
- Hot reload and debugging

**When to use:** Creating UI components, setting up project structure, handling platform-specific behaviors

---

### 2. `semantic-kernel` - Semantic Kernel & LLM Integration

**Purpose:** AI orchestration using Microsoft Semantic Kernel

**Should know:**
- Semantic Kernel setup and configuration
- Chat completion with Azure OpenAI / OpenAI-compatible APIs
- Tool/function calling patterns
- Memory connectors (Qdrant, Azure AI Search)
- RAG implementation (chunking, embedding, retrieval)
- Prompt engineering best practices
- Context window management
- Retry patterns and error handling

**When to use:** Implementing the AI conversation engine (FR-010), rules RAG (FR-031), vector search (FR-023), tool registration

---

### 3. `fate-accelerated` - Fate Accelerated Rules System

**Purpose:** Deep knowledge of Fate Accelerated mechanics for correct AI application

**Should know:**
- All 6 approaches and when to use them
- 4 action types (Overcome, Create Advantage, Attack, Defend)
- Roll resolution (4dF + bonus vs difficulty)
- Success levels (Success with Style, Success, Tie, Failure)
- Aspect invocation mechanics
- Fate point economy
- Stress and consequences
- Conflict/combat rules

**When to use:** Creating the Fate Accelerated knowledge pack (FB-020), testing rules consistency (Spike 2), AI prompt engineering for rules application

---

### 4. `mythic-gme` - Mythic GME Oracle System

**Purpose:** Mythic Game Master Emulator mechanics for invisible oracle integration

**Should know:**
- Fate Chart and probability calculations
- Chaos Factor (1-9) and how it affects probabilities
- Random event checks and triggers
- NPC/Thread/Location list management
- Scene transitions and chaos adjustment
- Event meaning tables
- Exceptional yes/no interpretation

**When to use:** Implementing oracle integration (FR-040-044), testing surprise generation, AI tool implementation for `invoke_oracle`

---

### 5. `ef-core-sqlite` - Entity Framework Core + SQLite

**Purpose:** Data persistence layer for campaign indexing

**Should know:**
- Entity Framework Core setup with SQLite
- Migrations and database creation
- LINQ queries and async patterns
- Repository patterns
- Connection handling for embedded databases
- Index optimization
- Concurrent access patterns

**When to use:** Building the SQLite search indexes (FB-064), conversation log persistence (FB-062), campaign metadata storage

---

### 6. `markdown-frontmatter` - Markdown + YAML Frontmatter Processing

**Purpose:** Reading and writing campaign files in the hybrid storage architecture

**Should know:**
- Markdig library for markdown parsing/rendering
- YamlDotNet for frontmatter parsing
- File watching for external changes
- Atomic file writes (temp file + rename pattern)
- Markdown structure for session logs, NPCs, locations
- Character sheet markdown format

**When to use:** Implementing markdown file management (FB-060), character sheet storage, session log writing, world wiki files

---

### 7. `ai-agent-tools` - LLM Tool/Function Implementation

**Purpose:** Creating the tools the AI agent calls during gameplay

**Should know:**
- Tool definition patterns for Semantic Kernel
- Input/output schemas
- Error handling in tools
- State mutation patterns
- Returning structured data to LLM
- Tool chaining considerations

**Tools to implement:**
- `roll_dice(notation)` - Dice rolling with cryptographic RNG
- `check_rule(query)` - RAG retrieval of rules
- `resolve_action(approach, difficulty, bonus, roll)` - Fate mechanics
- `invoke_oracle(question, likelihood)` - Mythic GME consultation
- `get_character_state()` / `update_character_state(changes)`
- `get_npc(name)` / `create_npc(name, personality, role)`
- `get_scene_context()` / `update_scene(location, npcs, threads)`

**When to use:** Implementing all AI tool functionality (FR-010 and related features)

---

### 8. `code-reviewer` - C# Code Quality Review

**Purpose:** Automated code review for quality, patterns, and best practices

**Should know:**
- C# coding conventions and best practices
- Async/await patterns
- SOLID principles
- Common security issues (API key handling, input validation)
- .NET MAUI gotchas
- Performance considerations
- Unit testability

**When to use:** After completing significant code changes, before commits

---

### 9. `test-writer` - Unit and Integration Test Generation

**Purpose:** Creating comprehensive tests for game mechanics and state management

**Should know:**
- xUnit/NUnit/MSTest patterns
- Mocking with Moq or NSubstitute
- Testing async code
- Testing LLM integrations (mocking API responses)
- Testing Fate Accelerated mechanics (deterministic dice for tests)
- Integration test patterns for SQLite

**When to use:** Writing tests for rules consistency (Spike 2), dice rolling, state persistence, tool implementations

---

### 10. `prompt-engineer` - AI System Prompt Development

**Purpose:** Crafting and refining prompts for GM agent and Combat agent

**Should know:**
- System prompt structure for game masters
- Response pattern definitions (Narration, Prompt for Action, Mechanical Prompt, Rule Explanation)
- Personality presets implementation
- Narration style modifiers (Terse/Balanced/Rich)
- Tool use guidance in prompts
- Context management strategies

**When to use:** Developing AI conversation patterns (FR-012), GM personality presets (FR-080), combat agent system prompt

---

## Implementation Priority

| Skill | Phase | Features It Supports |
|-------|-------|---------------------|
| `dotnet-maui` | A (Weeks 1-3) | All UI components |
| `semantic-kernel` | A (Weeks 1-3) | FB-010, FB-011, FB-012 |
| `fate-accelerated` | A (Weeks 1-3) | FB-020, FB-021, FB-026 |
| `ai-agent-tools` | A (Weeks 1-3) | FB-014, FB-021-028 |
| `markdown-frontmatter` | A (Weeks 1-3) | FB-060 |
| `ef-core-sqlite` | B-C (Weeks 4-10) | FB-062, FB-064 |
| `mythic-gme` | B (Weeks 4-6) | FB-040-044 |
| `prompt-engineer` | B-D (Weeks 4-14) | All AI behavior |
| `test-writer` | All phases | Spike 2, ongoing quality |
| `code-reviewer` | All phases | Ongoing quality |

---

## Quick Start: First 3 Skills to Create

For Phase A kickoff, create these three skills first:

1. **`semantic-kernel`** - Core to all AI functionality
2. **`fate-accelerated`** - Essential for the rules knowledge pack
3. **`ai-agent-tools`** - Enables the core gameplay loop

---

## Skill File Structure

Each skill should be created as a markdown file in `.claude/skills/` with the following structure:

```markdown
# Skill Name

Brief description of what this skill provides.

## Knowledge Areas

- Key topic 1
- Key topic 2
- ...

## References

- Link to documentation
- Link to examples
- ...

## Common Patterns

### Pattern Name
Description and code example...
```

---

## Notes

- Skills should be domain-specific and focused
- Each skill file should contain enough context for Claude to apply expertise effectively
- Consider adding code examples and common patterns to each skill
- Update skills as the implementation progresses and patterns emerge
