# Technical Landscape Assessment: Solo RPG App

**Project**: AI-powered solo RPG companion (GM + Oracle + Rules + State)
**Assessment Date**: 2025-12-09
**Confidence**: High (based on research and analogous projects)

---

## Executive Summary

**Verdict**: HIGH feasibility for core concept with MEDIUM-HIGH complexity

**Key Findings**:
- AI agent frameworks exist but most are overkill - simple orchestration pattern recommended
- State persistence is straightforward using SQLite + embeddings
- Rules encoding requires hybrid approach: structured data (Python) + RAG for text
- Local app + cloud LLM architecture is proven and flexible
- Several analogous projects exist to learn from

**Biggest Risks**:
1. Context window management for long campaigns (T5)
2. Rules consistency across sessions (T2)
3. Balancing AI creativity with mechanical fidelity

---

## 1. AI Agent Frameworks

### Landscape Analysis

| Framework | Strengths | Weaknesses | Fit for Solo RPG |
|-----------|-----------|------------|------------------|
| **Microsoft Agent Framework** | - Python & C# support<br>- Modern architecture (Nov 2025)<br>- Tool use patterns<br>- Microsoft ecosystem integration | - Newer framework<br>- Evolving documentation | **HIGH** - Well-suited for stateful agent with tools |
| **Claude Agent SDK** | - Built-in tool use<br>- Excellent instruction following<br>- Native multi-turn support | - Newer, smaller ecosystem<br>- Less community examples | **HIGH** - Best for stateful game sessions |
| **LangChain** | - Mature ecosystem<br>- Many integrations<br>- RAG tooling | - Over-engineered for simple cases<br>- Opinionated abstractions<br>- Slower updates | **MEDIUM** - Good for RAG, overkill for orchestration |
| **AutoGen (Legacy)** | - Multi-agent patterns<br>- Conversation management | - Superseded by Agent Framework<br>- Complex for single-agent use | **LOW** - Use Agent Framework instead |
| **CrewAI** | - Task orchestration<br>- Role-based agents | - Adds unnecessary abstraction<br>- Best for multi-agent workflows | **LOW** - Not needed for solo agent |

### Recommended Approach

**Microsoft Agent Framework with C# SDK** (Selected - Decision 004)
- C# SDK provides native support for .NET ecosystem
- Modern tool use patterns align well with RPG agent requirements
- Good fit for single agent with multiple capabilities (GM, oracle, rules)
- PO has strong C# expertise, accelerates development
- Seamless integration with .NET MAUI desktop app

**Why Agent Framework works here**:
- Solo RPG needs ONE agent playing multiple roles (GM, oracle, rules arbiter)
- State management is custom to RPG domain (game state, not just conversation)
- Tool use pattern is core: AI calls tools for dice, rules lookup, state access
- Microsoft Agent Framework provides structured orchestration without over-engineering

**Architecture**:
```
User Input (Chat interface)
    ↓
.NET MAUI Application Layer (C#)
    ↓
Microsoft Agent Framework (C# SDK)
    ↓
LLM API (OpenAI-compatible) with tools:
    - roll_dice(formula)
    - check_rule(system, situation)
    - get_npc(name)
    - update_world_state(changes)
    - invoke_oracle(question, tables)
    ↓
Tools execute → return to LLM → LLM continues
    ↓
Output to user (markdown in chat)
```

**RAG Implementation**:
- Use Semantic Kernel for document retrieval and RAG capabilities
- Provides built-in memory connectors and embeddings support
- Native C# integration with vector stores

---

## 2. Persistence Patterns

### State Requirements

Solo RPG state includes:
- **Character state**: Stats, skills, inventory, conditions
- **World state**: NPCs, locations, factions, relationships
- **Campaign history**: Events, decisions, plot threads
- **Session context**: Recent narrative, pending threads
- **System rules**: Loaded rules modules (Fate, D&D, etc.)

### Recommended Architecture

**Hybrid: Relational + Vector + Document**

#### SQLite for Structured Data (via Entity Framework Core)
```sql
-- Character state (current values)
characters (id, name, system, stats_json, conditions_json, created_at)

-- NPCs (entities with relationships)
npcs (id, name, description, relationships_json, first_met_session)

-- Locations (world geography)
locations (id, name, description, parent_location_id, details_json)

-- Sessions (timeline)
sessions (id, session_number, date, summary, duration_minutes)

-- Campaign metadata
campaigns (id, name, system, oracle, created_at, last_played)
```

**C# Integration**: Use Entity Framework Core for SQLite access - provides LINQ queries, migrations, and type-safe access.

#### Vector Store for Semantic Search
Evaluate C# vector store options:

| Option | Pros | Cons | Verdict |
|--------|------|------|---------|
| **Semantic Kernel Memory Connectors** | Native C# integration, Microsoft ecosystem | Limited to SK-supported stores | ✅ Start here |
| **Qdrant (C# client)** | Production-grade, full-featured | Requires separate process | Future option |
| **LiteDB with vectors** | Embedded, simple | Less mature vector capabilities | Fallback |
| **Python ChromaDB service** | Mature, feature-rich | Cross-process IPC complexity | Avoid for MVP |

**For MVP**: Use Semantic Kernel's memory connectors with Azure AI Search (local) or Qdrant embedded mode.

Campaign history search use cases:
- "What happened with the merchant guild?"
- "Who was that elf we met in the forest?"
- "Tell me about locations near the capital"

```csharp
// Store each session narrative chunk with metadata
var memory = new SemanticTextMemory(store, embeddings);
await memory.SaveInformationAsync(
    collection: "campaign-history",
    text: "You negotiated with the merchant guild leader...",
    metadata: new Dictionary<string, object> {
        ["session"] = 5,
        ["npcs"] = new[] { "Guild Master Thorne" },
        ["locations"] = new[] { "Guild Hall" },
        ["tags"] = new[] { "negotiation", "quest:merchant-crisis" }
    }
);
```

#### Document Store for Rules
Store rules systems as structured documents:
- Fate Accelerated rules as markdown with frontmatter
- Chunk for RAG retrieval when AI needs rules clarification

### Persistence Pattern
```csharp
public class GameState
{
    private readonly CampaignDbContext _db;
    private readonly ISemanticTextMemory _memory;
    private readonly RulesSystem _rules;

    public GameState(string campaignPath)
    {
        _db = new CampaignDbContext(campaignPath);
        _memory = new SemanticTextMemoryBuilder()
            .WithMemoryStore(new QdrantMemoryStore("localhost", 6333))
            .WithTextEmbeddingGeneration(new AzureOpenAITextEmbeddings())
            .Build();
        _rules = RulesLoader.Load("fate_accelerated");
    }

    public async Task SaveTurnAsync(string narrative, StateChanges changes)
    {
        // 1. Write structured changes to SQLite via EF Core
        var character = await _db.Characters.FindAsync(changes.CharacterId);
        character.Stats = JsonSerializer.Serialize(changes.NewStats);

        // 2. Embed narrative for semantic search
        await _memory.SaveInformationAsync(
            collection: "campaign-history",
            text: narrative,
            id: Guid.NewGuid().ToString(),
            metadata: changes.Metadata
        );

        // 3. Commit transaction
        await _db.SaveChangesAsync();
    }

    public async Task<IEnumerable<string>> RecallContextAsync(string query, int k = 5)
    {
        // Vector search for relevant history
        var results = await _memory.SearchAsync(
            collection: "campaign-history",
            query: query,
            limit: k
        );
        return results.Select(r => r.Metadata.Text);
    }
}
```

### Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| **Database corruption** | - Atomic transactions<br>- Auto-backup before each session<br>- Export to JSON for portability |
| **Vector store drift** | - Periodic re-embedding<br>- Versioning of embeddings |
| **Large campaign size** | - Summarization of old sessions<br>- Archive cold data |

**Feasibility**: HIGH - This is a solved pattern. SQLite + ChromaDB handles thousands of sessions.

---

## 3. Rules Encoding

### The Challenge

RPG rules need to be:
1. **Queryable by AI**: "What happens when I try to Fast Talk?"
2. **Executable by code**: "Roll 4dF+3, if ≥ target difficulty..."
3. **Flexible**: Different systems have different mechanics
4. **Maintainable**: Rules change across editions

### Hybrid Approach: Code + RAG

#### Layer 1: Structured Rules (C# Code)
Encode core mechanics as executable code:

```csharp
// FateAccelerated/Mechanics.cs
public class FateAccelerated
{
    public ActionResult ResolveAction(string approach, int difficulty, int bonus)
    {
        var roll = RollFudgeDice(4);  // -4 to +4
        var total = roll + bonus;

        if (total >= difficulty + 3)
            return new ActionResult
            {
                Outcome = "success_with_style",
                Boost = true
            };
        else if (total >= difficulty)
            return new ActionResult { Outcome = "success" };
        else if (total >= difficulty - 2)
            return new ActionResult
            {
                Outcome = "tie",
                Cost = true
            };
        else
            return new ActionResult { Outcome = "failure" };
    }

    private int RollFudgeDice(int count)
    {
        // Returns sum of count dF (each die: -1, 0, or +1)
        var random = new Random();
        return Enumerable.Range(0, count)
            .Sum(_ => random.Next(-1, 2));
    }
}
```

**Advantage**: Consistent, fast, testable, type-safe

#### Layer 2: Rules RAG (Natural Language)
Store rules text for AI to reason about:

```markdown
# Fate Accelerated: Approaches

When you act, choose an approach:
- **Careful**: Precise, cautious action
- **Clever**: Thinking, planning
- **Flashy**: Stylish, attention-grabbing
- **Forceful**: Direct power
- **Quick**: Speed, agility
- **Sneaky**: Misdirection, stealth

Roll 4dF + approach rating vs difficulty.
```

**AI Tool**: `check_rule(query)`
- Retrieves relevant rules via RAG
- AI interprets rule in context
- AI calls executable tool (e.g., `resolve_action`)

### Rules System as Plugins

```
/RulesSystems
  /FateAccelerated
    - Mechanics.cs              # Executable code
    - rules.md                  # Natural language rules
    - CharacterSchema.json      # Data structure
    - FateRulesPlugin.cs        # Plugin interface impl
  /TalesOfTheValiant
    - Mechanics.cs
    - rules.md
    - CharacterSchema.json
    - ToVRulesPlugin.cs
```

Each system provides:
1. **Mechanics API**: C# classes/methods AI can call via tools
2. **Rules corpus**: Markdown for RAG retrieval
3. **Data schemas**: Character/NPC structure
4. **Plugin interface**: Standard contract for rules systems

### AI Workflow

```
User: "I try to Fast Talk the guard (Clever +2)"

AI reasoning:
1. Call check_rule("Fast Talk in Fate Accelerated")
   → Returns: "Overcome action using Clever approach"
2. Call resolve_action(approach="Clever", difficulty=2, bonus=2)
   → Returns: {"outcome": "success", "total": 4}
3. Narrate based on outcome

Output: "You spin a convincing story... Success! The guard waves you through."
```

### Comparison of Approaches

| Approach | Pros | Cons | Verdict |
|----------|------|------|---------|
| **Pure RAG** | Flexible, no coding | Inconsistent, slow, hallucination risk | ❌ Too risky |
| **Pure Code** | Fast, consistent | Rigid, hard to maintain, no context | ❌ Too brittle |
| **Hybrid (Code + RAG)** | Best of both worlds | Requires both systems | ✅ Recommended |
| **Fine-tuned Model** | Internalized rules | Expensive, inflexible, hard to update | ❌ Overkill |

### Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| **AI misinterprets rules** | - Structured tools force correct execution<br>- RAG retrieval provides context<br>- Logging for debugging |
| **Rules inconsistency across sessions** | - Versioning rules modules<br>- Lock system version per campaign |
| **Complex rules hard to encode** | - Start with simple system (Fate) for MVP<br>- Iterate encoding patterns |

**Feasibility**: MEDIUM-HIGH
- Fate Accelerated (MVP): HIGH - Simple, narrative rules
- D&D 5e (future): MEDIUM - Complex, many edge cases
- Approach is proven, but requires careful encoding

---

## 4. Local App + Cloud LLM Architecture

### Recommended Architecture

```
┌──────────────────────────────────────────────────┐
│         .NET MAUI Desktop App (C#)               │
│                                                  │
│  ┌────────────────────────────────────────────┐ │
│  │  UI Layer (XAML / Blazor Hybrid)          │ │
│  │  - Chat interface (Decision 005)          │ │
│  │  - Markdown rendering                      │ │
│  │  - Session/campaign views                  │ │
│  └────────────┬───────────────────────────────┘ │
│               ↓                                  │
│  ┌────────────────────────────────────────────┐ │
│  │  Game Engine (C#)                          │ │
│  │  - Microsoft Agent Framework               │ │
│  │  - State management                        │ │
│  │  - Rules execution (Fate/ToV plugins)      │ │
│  │  - Tool implementations                    │ │
│  └────────────┬───────────────────────────────┘ │
│               ↓                                  │
│  ┌────────────────────────────────────────────┐ │
│  │  Storage Layer                             │ │
│  │  - SQLite via EF Core                      │ │
│  │  - Semantic Kernel Memory                  │ │
│  │  - Vector store (Qdrant/Azure AI Search)   │ │
│  └────────────────────────────────────────────┘ │
└───────────────┬──────────────────────────────────┘
                ↓ HTTPS
        ┌───────────────────┐
        │   Cloud LLM API   │
        │  (OpenAI-compat)  │
        │                   │
        │  • Claude API     │
        │  • OpenAI API     │
        │  • Azure OpenAI   │
        │  • Ollama (local) │
        └───────────────────┘
```

### Technology Choices

#### Local App Framework
**Selected: .NET MAUI (Decision 004)**

| Option | Pros | Cons | Verdict |
|--------|------|------|---------|
| **.NET MAUI** | - True cross-platform (Win/Mac/iOS/Android)<br>- Native C# (PO expertise)<br>- Single codebase<br>- Native UI on each platform<br>- Strong Microsoft ecosystem | - Newer framework<br>- Some platform quirks | ✅ **Selected** |
| **Tauri + Python** | - Small bundle<br>- Python backend | - IPC complexity<br>- Two languages<br>- Packaging challenges | ❌ Too complex |
| **Electron** | - Mature ecosystem | - Large bundle<br>- Memory hungry<br>- Two languages (Node + Python) | ❌ Not ideal |
| **Web App** | - No installation | - Can't access local LLMs<br>- Storage limits | ❌ Loses "local" benefit |

**Architecture**:
```
.NET MAUI (C#)
  ↓
UI Layer (XAML or Blazor Hybrid)
  ↓
Game Engine (C# Services)
  - Microsoft Agent Framework
  - LLM API client (Azure OpenAI SDK / Semantic Kernel)
  - Storage (EF Core + Semantic Kernel Memory)
  - Rules plugins
```

**Key Benefits**:
- Single language codebase (C#) - simpler development
- PO has deep C# expertise - faster implementation
- Native packaging for all platforms
- Strong async/await patterns for LLM calls
- Rich ecosystem for desktop apps

#### LLM API Client
**Use Azure OpenAI SDK or Semantic Kernel**

**Option 1: Azure OpenAI SDK (Direct)**
```csharp
using Azure.AI.OpenAI;

var client = new OpenAIClient(
    new Uri(userConfig.Endpoint),
    new AzureKeyCredential(userConfig.ApiKey)
);

var chatOptions = new ChatCompletionsOptions
{
    DeploymentName = userConfig.Model,
    Messages = { ... },
    Tools = { rollDiceTool, checkRuleTool, ... }
};

var response = await client.GetChatCompletionsAsync(chatOptions);
```

**Option 2: Semantic Kernel (Recommended)**
```csharp
using Microsoft.SemanticKernel;

var kernel = Kernel.CreateBuilder()
    .AddAzureOpenAIChatCompletion(
        deploymentName: userConfig.Model,
        endpoint: userConfig.Endpoint,
        apiKey: userConfig.ApiKey
    )
    .Build();

// Register tools as kernel functions
kernel.ImportPluginFromObject(new GameTools());

var result = await kernel.InvokePromptAsync(prompt, arguments);
```

**Supports**:
- Azure OpenAI: Native integration
- OpenAI: Via OpenAI connector
- Claude API: Via custom connector or HTTP client
- Ollama (local): Via OpenAI-compatible endpoint configuration

**Note**: Semantic Kernel provides better abstraction for tool/function calling and memory management.

#### Storage Strategy
**Local-first, cloud optional**

```
campaign_data/
  ├── campaigns/
  │   ├── my-fantasy-campaign/
  │   │   ├── campaign.db          # SQLite
  │   │   ├── memory.chroma/       # ChromaDB
  │   │   ├── export.json          # Portable backup
  │   │   └── sessions/
  │   │       ├── session-001.md   # Readable log
  │   │       └── session-002.md
```

**Future**: Optional cloud sync (Dropbox, Google Drive, self-hosted)

### API Cost Management

| Provider | Cost per 1M tokens (input) | Typical session cost |
|----------|---------------------------|---------------------|
| **Claude Sonnet 3.5** | $3.00 | $0.15-0.30 (60-90 turns) |
| **GPT-4o** | $2.50 | $0.12-0.25 |
| **Claude Haiku** | $0.25 | $0.01-0.02 |
| **Ollama (local)** | Free | Free (but needs GPU) |

**Strategy**:
- Default to cost-effective model (Haiku, GPT-4o-mini)
- Let users configure model preference
- Show estimated cost per session
- Support local Ollama for free tier

### Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| **API key security** | - Store in OS keychain (not plaintext)<br>- Never log API keys<br>- Use environment variables |
| **Network failures** | - Retry with exponential backoff<br>- Queue requests<br>- Graceful error messages |
| **API changes** | - Use stable SDK versions<br>- Test against multiple providers<br>- Abstract API layer |
| **Local LLM performance** | - Make optional, not required<br>- Document hardware requirements<br>- Test with Ollama (Llama 3, Mistral) |

**Feasibility**: HIGH - This architecture is proven and battle-tested.

---

## 5. Similar Projects & Learning Opportunities

### Direct Analogues

#### 1. AI Dungeon / NovelAI
**What they do**: AI-powered narrative generation
**Architecture**: Web app + Cloud LLM
**Learnings**:
- ✅ Persistent story memory using embeddings
- ✅ User controls AI via "context" settings
- ❌ No game mechanics (pure narrative)
- ❌ No rules systems integration

**Takeaway**: Proves AI narrative generation works, but lacks mechanical depth.

#### 2. Mythic GME Apps (various)
**What they do**: Solo RPG oracle tools
**Architecture**: Mobile/desktop apps, no AI
**Learnings**:
- ✅ Structured randomness (tables, threads, chaos factor)
- ✅ Local-first storage
- ❌ Purely mechanical, no narrative intelligence
- ❌ Clunky UX (lots of manual tracking)

**Takeaway**: Shows demand for solo RPG tools, gap in narrative quality.

#### 3. Roleplayer's AI (hypothetical)
**Status**: No direct competitor found combining AI + mechanics + oracles
**Gap**: This is the opportunity.

### Adjacent Projects to Study

#### 1. LangChain SQL Agent
**Relevance**: Shows tool use for structured queries
**Code**: https://github.com/langchain-ai/langchain/tree/master/templates/sql-agent
**Takeaway**: Pattern for AI querying game state database

#### 2. MemGPT
**Relevance**: Long-term memory management for LLMs
**Code**: https://github.com/cpacker/MemGPT
**Learnings**:
- Hierarchical memory: working memory + archival storage
- Summarization strategies for context management
- Vector search for recall

**Takeaway**: Solutions for context window limits (addresses T5).

#### 3. AutoGen Multi-Agent Examples
**Relevance**: Orchestrating AI with tools
**Code**: https://github.com/microsoft/autogen
**Takeaway**: Patterns for AI calling tools, even though framework itself is overkill.

#### 4. SimulacrumAI / CharacterAI
**Relevance**: Consistent character personas
**Learnings**:
- Character cards with personality data
- Memory anchoring techniques
- Conversation consistency patterns

**Takeaway**: Techniques for consistent NPC personalities.

### Open Source Components to Leverage

| Component | Purpose | Maturity | License |
|-----------|---------|----------|---------|
| **ChromaDB** | Vector storage for campaign memory | Production | Apache 2.0 |
| **LangChain** | RAG for rules lookup | Production | MIT |
| **OpenAI SDK** | LLM API client | Production | MIT |
| **Tauri** | Desktop app framework | Production | MIT |
| **Markdown-it** | Rendering game logs | Production | MIT |

**All compatible with open source commercial use.**

---

## 6. Feasibility Assessment: Technical Assumptions

### T1: AI can effectively play dual role of GM and Oracle
**Confidence**: HIGH ✅

**Evidence**:
- Claude/GPT-4 excel at multi-turn narrative generation
- Tool use enables structured oracle mechanics (roll tables, chaos factor)
- Single agent can play multiple roles via system prompting
- Similar projects (AI Dungeon) prove narrative generation works
- Oracle role is tool invocation (structured), not novel AI capability

**Risks**:
- AI might blend roles confusingly (GM narrating vs oracle consulting)
- **Mitigation**: Clear role separation in prompts, explicit tool calls for oracle functions

**Verdict**: FEASIBLE - Proven capability, low risk.

---

### T2: Rules systems can be encoded in a way AI can apply consistently
**Confidence**: MEDIUM-HIGH ⚠️

**Evidence**:
- Hybrid approach (code + RAG) addresses consistency
- Simple systems (Fate Accelerated) encode easily
- SQL agent patterns show AI can use structured tools
- RAG provides context for edge cases

**Risks**:
- Complex rules (D&D 5e) have many edge cases
- AI might misinterpret rule interactions
- Rules consistency across sessions depends on clear encoding
- **Mitigation**:
  - Start with simple system (Fate) for MVP
  - Encode core mechanics as Python tools (not AI interpretation)
  - RAG for edge cases and context
  - Extensive testing and logging

**Verdict**: FEASIBLE for Fate (MVP), MEDIUM for D&D (future)
- Fate Accelerated: HIGH confidence (simple, narrative-focused)
- D&D 5e: MEDIUM confidence (requires careful encoding, more spikes needed)

---

### T3: Can run locally/self-hosted with acceptable performance
**Confidence**: MEDIUM ⚠️

**Evidence**:
- Local app (Tauri/Electron): HIGH - Proven technology
- Cloud LLM via API: HIGH - Works well, 200-500ms latency typical
- Local LLM (Ollama): MEDIUM - Depends on hardware

**Performance Breakdown**:

| Component | Performance | Requirements |
|-----------|-------------|--------------|
| **Local app + storage** | Excellent | Any modern CPU |
| **Cloud LLM (Claude, GPT-4)** | Good (200-500ms) | Internet, API key |
| **Local LLM (Ollama)** | Variable | GPU recommended (8GB+ VRAM) |

**Local LLM Reality Check**:
- Llama 3 8B: Works on CPU, slow (5-10s per response)
- Llama 3 70B: Requires 48GB+ VRAM (impractical for most)
- Mistral 7B: Good balance, needs 16GB RAM + GPU

**Recommendation**:
- **MVP**: Local app + cloud LLM (Claude/OpenAI)
- **Future**: Local LLM as optional (for privacy-focused users with hardware)

**Verdict**: FEASIBLE
- Local app + cloud LLM: HIGH confidence
- Fully local (including LLM): MEDIUM confidence (hardware dependent)

---

### T4: Persistent storage of game state is straightforward
**Confidence**: HIGH ✅

**Evidence**:
- SQLite: Battle-tested, embedded, perfect for local app
- ChromaDB: Mature vector store, embedded mode, no server
- Combined pattern used successfully in many apps
- Campaign data easily exportable (JSON, markdown)

**Technical Approach**:
```
SQLite (structured data)
  + ChromaDB (semantic search)
  + Markdown exports (human-readable)
  = Robust, portable persistence
```

**Risks**: Minimal
- Database corruption: Auto-backup mitigates
- Storage growth: Summarization + archival handles

**Verdict**: FEASIBLE - This is a solved problem. LOW risk.

---

### T5: Context window management for long campaigns is solvable
**Confidence**: MEDIUM ⚠️ (Highest risk)

**The Challenge**:
- Long campaigns generate huge history (100+ sessions)
- LLM context windows limited (128k-200k tokens)
- Need: Recent context + relevant history + rules

**Strategy: Hierarchical Memory**

#### 1. Working Memory (Always in Context)
- Current session narrative (last 10-20 turns)
- Active character/NPC states
- Current scene/location

**Size**: ~5k-10k tokens

#### 2. Session Memory (Summarized)
- Summary of each past session
- Key events, decisions, NPCs introduced

**Size**: ~500 tokens per session × 10 recent sessions = 5k tokens

#### 3. Archival Memory (Vector Search)
- Full narrative of all sessions embedded
- Retrieved on-demand: "What happened with the merchant guild?"

**Size**: Retrieve top 3-5 relevant chunks = 2k-5k tokens

#### 4. Static Context
- Rules system documentation (via RAG)
- Character sheet
- World state

**Size**: ~5k-10k tokens

**Total Context Budget**: ~25k-40k tokens (well within 128k window)

**Proven Techniques** (from MemGPT, LangChain):
- Session summarization after each game
- Vector search for retrieval of old events
- Importance weighting (recent + relevant prioritized)

**Risks**:
- Lost context: Important plot thread forgotten
- Summarization quality: AI misses nuance
- **Mitigation**:
  - User-curated "pins" (important facts user marks)
  - Importance scoring for plot threads
  - Export full logs (user can reference)
  - Testing with long campaigns (spike needed)

**Verdict**: FEASIBLE but needs validation
- SHORT campaigns (1-10 sessions): HIGH confidence
- MEDIUM campaigns (10-50 sessions): MEDIUM-HIGH confidence
- LONG campaigns (50+ sessions): MEDIUM confidence (needs spike to validate)

**Recommendation**: Implement hierarchical memory from MVP, plan spike to test 50+ session campaign.

---

## 7. Technical Risk Register

### Critical Risks (High Impact × High/Medium Likelihood)

#### TR-01: Context Management Breaks Down in Long Campaigns
- **Description**: After 50+ sessions, AI loses track of plot threads, forgets NPCs
- **Category**: Complexity, Performance
- **Likelihood**: Medium
- **Impact**: High (campaigns become unplayable)
- **Risk Score**: 6/9
- **Mitigation**:
  - Hierarchical memory (working + session + archival)
  - User-curated pins for critical facts
  - Importance scoring for plot threads
  - Testing with synthetic long campaigns
- **Contingency**: Manual context management UI (user refreshes AI memory)
- **Validation**: Technical spike - simulate 50+ session campaign
- **Status**: Open

#### TR-02: Rules Inconsistency Across Sessions
- **Description**: AI applies rules differently in different sessions
- **Category**: Complexity, Technical Debt
- **Likelihood**: Medium
- **Impact**: High (breaks game feel, user trust)
- **Risk Score**: 6/9
- **Mitigation**:
  - Encode mechanics as Python tools (not AI interpretation)
  - RAG for rules context
  - Logging and replay for debugging
  - Version lock rules per campaign
- **Contingency**: User can override/correct AI rules interpretation
- **Validation**: Extensive testing with Fate rules
- **Status**: Open

### Moderate Risks

#### TR-03: Local LLM Performance Insufficient
- **Description**: Users with modest hardware can't run local LLMs acceptably
- **Category**: Technical, User Experience
- **Likelihood**: High
- **Impact**: Medium (limits "fully local" option)
- **Risk Score**: 6/9
- **Mitigation**:
  - Make local LLM optional, not required
  - Default to cloud LLM (Claude, OpenAI)
  - Document hardware requirements clearly
- **Contingency**: Cloud LLM as primary path
- **Validation**: Test with Ollama on CPU-only machines
- **Status**: Accepted (cloud LLM as primary)

#### TR-04: API Cost Management
- **Description**: Users concerned about API costs for long sessions
- **Category**: Business, User Experience
- **Likelihood**: Medium
- **Impact**: Medium (limits usage, user anxiety)
- **Risk Score**: 4/9
- **Mitigation**:
  - Show estimated cost per session
  - Support cost-effective models (Haiku, GPT-4o-mini)
  - Optimize prompts for token efficiency
  - Support local Ollama (free tier)
- **Contingency**: Provide cost calculator, usage tracking
- **Status**: Open

#### TR-05: AI Generates Inappropriate/Unexpected Content
- **Description**: AI narrates content user doesn't want (violence, themes)
- **Category**: User Experience, Safety
- **Likelihood**: Medium
- **Impact**: Medium (user dissatisfaction)
- **Risk Score**: 4/9
- **Mitigation**:
  - Content filters in system prompt
  - User preferences for themes/tone
  - "Regenerate" option for undesired outputs
- **Contingency**: User can edit/override AI output
- **Status**: Open

### Lower Risks

#### TR-06: Modular Architecture Complexity
- **Description**: Supporting multiple rules systems adds maintenance burden
- **Category**: Technical Debt
- **Likelihood**: Medium
- **Impact**: Low (dev productivity)
- **Risk Score**: 3/9
- **Mitigation**:
  - Start with one system (Fate) for MVP
  - Design plugin architecture from day one
  - Thorough testing of plugin interface
- **Status**: Accepted (design decision)

---

## 8. Recommended Technical Approach

### MVP Architecture

```
┌──────────────────────────────────────────────────────────┐
│              .NET MAUI Desktop App (C#)                  │
│                                                          │
│  UI Layer (XAML or Blazor Hybrid)                       │
│    - Chat interface (conversational GM)                 │
│    - Markdown rendering for narrative                   │
│    - Campaign/session management                        │
│                                                          │
│  ──────────────────────────────────────────────────────│
│                                                          │
│  Game Engine (C# Services)                              │
│    ┌─────────────────────────────────────────────┐     │
│    │  Core Services                               │     │
│    │  - State management (EF Core + SQLite)      │     │
│    │  - Rules execution (Fate Accelerated)       │     │
│    │  - Oracle mechanics (Mythic GME)            │     │
│    │  - Memory service (Semantic Kernel)         │     │
│    └──────────────────┬──────────────────────────┘     │
│                       ↓                                  │
│    ┌─────────────────────────────────────────────┐     │
│    │  AI Orchestration                            │     │
│    │  - Microsoft Agent Framework (C# SDK)       │     │
│    │  - Semantic Kernel / Azure OpenAI SDK       │     │
│    │  - Tool definitions (dice, rules, state)    │     │
│    │  - Context management (memory retrieval)    │     │
│    └──────────────────┬──────────────────────────┘     │
└────────────────────────┼──────────────────────────────┘
                         ↓ HTTPS
              ┌─────────────────────┐
              │   Cloud LLM API     │
              │ (Claude, OpenAI, or │
              │  Azure OpenAI)      │
              └─────────────────────┘
```

### Technology Stack

| Layer | Technology | Rationale |
|-------|------------|-----------|
| **Desktop App** | .NET MAUI | Cross-platform, native C#, PO expertise |
| **Agent Framework** | Microsoft Agent Framework (C# SDK) | Native C# support, modern tool use patterns |
| **Backend** | C# (.NET 8+) | Single language, strong async/await, PO expertise |
| **LLM Client** | Semantic Kernel / Azure OpenAI SDK | Native C# LLM tooling, RAG capabilities |
| **Structured Storage** | SQLite via Entity Framework Core | Embedded, reliable, type-safe ORM |
| **Vector Storage** | Semantic Kernel Memory + Qdrant | Native C# integration, embedded or server mode |
| **RAG** | Semantic Kernel | Built-in document chunking, embeddings, retrieval |
| **UI** | XAML or Blazor Hybrid | Native MAUI UI or web-based hybrid |
| **UI Rendering** | Markdig (C# Markdown library) | Renders game logs, portable format |

### Development Phases

#### Phase 1: Core Loop (MVP Foundation)
- Basic game loop: user action → LLM → narrative
- Simple tool use: dice rolling, basic rules
- SQLite persistence (character, basic state)
- Single rules system: Fate Accelerated

#### Phase 2: Memory & Context
- ChromaDB integration for campaign history
- Session summarization
- Vector search for recall
- Improved context management

#### Phase 3: Oracle Integration
- Mythic GME mechanics (structured randomness)
- Adventure Crafter patterns
- Surprise generation

#### Phase 4: Modularity
- Plugin architecture for rules systems
- D&D 5e support (stretch goal)
- Alternative oracle systems

---

## 9. Key Recommendations

### Do This
1. **.NET MAUI + C# stack**: Leverage PO's C# expertise for faster development, single language codebase
2. **Microsoft Agent Framework (C# SDK)**: Native integration with .NET ecosystem, modern tool use patterns
3. **Semantic Kernel for LLM integration**: Provides RAG, memory, and tool calling in native C#
4. **Hybrid rules**: Code (C#) for mechanics, RAG for context - ensures consistency
5. **Local app + cloud LLM**: Best balance of control and performance
6. **SQLite + Semantic Kernel Memory**: Proven persistence with type-safe C# access
7. **Fate Accelerated MVP**: Simple rules to validate approach before adding complexity
8. **Hierarchical memory**: Working + session + archival from day one
9. **Chat-first UI** (Decision 005): Simpler to build, more natural interaction, voice-ready for future

### Don't Do This
1. **Don't use Python or cross-language IPC**: Adds complexity, PO's C# expertise is more valuable
2. **Don't require local LLM for MVP**: Hardware barrier too high, focus on cloud API
3. **Don't fine-tune models**: Expensive, inflexible, unnecessary for this use case
4. **Don't use pure RAG for rules execution**: Too inconsistent, encode mechanics in C# code
5. **Don't build web app**: Loses local-first benefits and LLM flexibility
6. **Don't add quick-action UI buttons**: Chat-first is simpler and more immersive (Decision 005)

### Spike Recommendations
1. **Long campaign context management** (High Priority)
   - Simulate 50+ session campaign
   - Test summarization quality
   - Validate vector retrieval effectiveness
   - **Effort**: 1-2 weeks
   - **Addresses**: TR-01 (context breakdown)

2. **Rules encoding patterns** (Medium Priority)
   - Implement Fate Accelerated rules
   - Test AI rules interpretation with RAG
   - Measure consistency across sessions
   - **Effort**: 1 week
   - **Addresses**: TR-02 (rules inconsistency)

3. **Local LLM viability** (Low Priority)
   - Test Ollama with Llama 3, Mistral
   - Benchmark performance on CPU vs GPU
   - Compare quality to Claude/GPT-4
   - **Effort**: 3-5 days
   - **Addresses**: TR-03 (local performance)

---

## 10. Technology Stack Impact Assessment

### What's Easier with .NET MAUI + C#

**Positive Impacts**:

1. **Development Velocity**
   - PO has deep C# expertise - no learning curve
   - Single language eliminates IPC complexity
   - Strong IDE support (Visual Studio, Rider)
   - Type safety catches errors at compile time

2. **Ecosystem Alignment**
   - Native Microsoft Agent Framework C# SDK
   - Semantic Kernel provides RAG out of the box
   - Azure OpenAI SDK is first-class in C#
   - Entity Framework Core mature and well-documented

3. **Cross-Platform Support**
   - True native apps on Windows, Mac, iOS, Android
   - Single codebase for all platforms
   - Native UI controls on each platform

4. **Async/Await Patterns**
   - C# has excellent async/await support
   - Critical for LLM API calls (long-running)
   - Built into language, not bolted on

5. **Memory Management**
   - Garbage collection handles most concerns
   - Better than manual Python memory management for long sessions

### What's Potentially Harder

**Challenges to Consider**:

1. **Vector Store Maturity**
   - Python ecosystem (ChromaDB, LanceDB) more mature
   - **Mitigation**: Use Qdrant (has C# client) or Semantic Kernel connectors
   - **Risk**: LOW - Qdrant and SK connectors are production-ready

2. **LLM Library Ecosystem**
   - Python has more cutting-edge LLM libraries (LangChain, LlamaIndex)
   - **Mitigation**: Semantic Kernel provides what we need (RAG, tools, memory)
   - **Risk**: LOW - SK is actively developed and Microsoft-backed

3. **MAUI Platform Quirks**
   - .NET MAUI is newer than Electron/Tauri
   - Some platform-specific bugs may surface
   - **Mitigation**: Desktop focus (Windows/Mac) is most stable, mobile later
   - **Risk**: MEDIUM - May hit platform issues, but community is growing

4. **Community Examples**
   - Fewer "AI-powered RPG in C#" examples vs Python
   - **Mitigation**: General patterns apply, PO can translate concepts
   - **Risk**: LOW - PO is experienced enough to adapt patterns

### Updated Risk Assessment

**New Risks**:

#### TR-07: .NET MAUI Platform Issues
- **Description**: Platform-specific bugs or limitations in MAUI
- **Category**: Technical
- **Likelihood**: Low-Medium
- **Impact**: Low (workarounds usually available)
- **Risk Score**: 2-3/9
- **Mitigation**:
  - Focus on Windows/Mac for MVP (most stable)
  - Active MAUI community for support
  - Fallback: WPF (Windows-only) or Avalonia UI if MAUI blocked
- **Status**: Monitoring

**Reduced Risks**:

- **TR-06 (Modular Architecture Complexity)**: LOWER - C# interfaces and dependency injection make plugin architecture cleaner
- **Development Velocity**: HIGHER - Single language, PO expertise accelerates implementation

### Net Assessment

**Overall**: The .NET MAUI + C# decision **IMPROVES** feasibility due to:
1. **PO expertise** - Most significant factor, eliminates learning curve
2. **Single language** - Reduces complexity vs Tauri + Python IPC
3. **Microsoft ecosystem** - Agent Framework, Semantic Kernel, Azure OpenAI all first-class in C#

**Trade-offs are acceptable**:
- Vector store ecosystem slightly less mature in C# → Mitigated by Qdrant and SK
- Fewer AI example projects in C# → PO can translate patterns easily

**Confidence**: HIGH - This stack actually **reduces** technical risk compared to Tauri + Python.

---

## 11. Conclusion

**Overall Feasibility**: HIGH ✅

The solo RPG app concept is technically feasible with manageable risks. The .NET MAUI + C# architecture leverages PO expertise and proven Microsoft technologies (Agent Framework, Semantic Kernel, Entity Framework Core, Azure OpenAI SDK).

**Technology Stack Decision Impact**:
- **.NET MAUI + C#** (Decision 004) **IMPROVES** feasibility vs Tauri + Python
- **Chat-first UI** (Decision 005) **SIMPLIFIES** implementation - no complex action button UI needed

**Strongest confidence**:
- T1 (AI as GM + Oracle): HIGH - Proven capability with Agent Framework
- T4 (Persistent storage): HIGH - EF Core + SQLite is battle-tested
- T3 (Local app performance): HIGH - .NET MAUI native performance excellent
- **PO Expertise**: HIGH - C# mastery accelerates development significantly

**Areas needing validation**:
- T5 (Context management): MEDIUM - Needs spike for long campaigns (apply with Semantic Kernel memory)
- T2 (Rules consistency): MEDIUM-HIGH - Start simple (Fate), validate hybrid C# + RAG approach

**Critical success factors**:
1. **Leverage PO's C# expertise** - Fastest path to working MVP
2. Hierarchical memory architecture via Semantic Kernel (addresses T5)
3. Hybrid rules encoding: C# code + RAG (addresses T2)
4. Chat-first conversational interface (simpler UX, more immersive)
5. Clear separation of AI narrative vs mechanical oracles
6. Extensive testing with realistic campaigns

**Next steps**:
1. Validate approach with rapid C# prototype (core loop + Fate rules + Semantic Kernel)
2. Conduct spike on long campaign context management with SK memory
3. User test with solo RPG players (Phase 4: Validation)
4. Evaluate Qdrant vs SK memory connectors for vector storage

---

**Assessment prepared by**: @tech-lead
**Review recommended**: @business-analyst (technical requirements), @user-researcher (user hardware constraints)
