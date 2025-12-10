# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Solo RPG Companion App - An AI-powered conversational game master for solo tabletop RPG players. The app handles narration, rules application (Fate Accelerated), oracle functions (Mythic GME), and state persistence through a chat interface.

**Status**: Pre-development (documentation and specification phase complete)

## Technology Stack (Planned)

- **Framework**: Electron (cross-platform desktop: Windows 10+, macOS 11+, Linux)
- **Language**: TypeScript
- **UI**: React (tentative)
- **AI Integration**: Vercel AI SDK
- **LLM**: OpenAI-compatible APIs (Claude, OpenAI, Azure OpenAI, Ollama)
- **Storage**: Hybrid architecture - Markdown files (player-visible) + SQLite (indexes) + Vector store (semantic search)

## Key Architecture Decisions

- **Hybrid Storage (Decision 010)**: Campaign data stored as markdown files in an Obsidian-like folder structure. SQLite for indexing only.
- **Rules as AI Knowledge (Decision 011)**: Rules stored as markdown documents, interpreted by AI via RAG - not hard-coded business logic.
- **Save After Every Message (Decision 012)**: No auto-save timer; messages persist immediately.
- **Modular Plugin Architecture (Decision 014)**: Rules and oracle systems are self-contained "knowledge packs".

## Campaign Folder Structure

```
Campaign Folder/
├── sessions/           # Session logs (session-NNN.md)
├── world/
│   ├── npcs/           # NPC markdown files
│   ├── locations/      # Location markdown files
│   └── factions/       # Faction markdown files
├── character.md        # Character sheet (markdown with YAML frontmatter)
├── campaign.md         # Campaign metadata and Mythic GME state
└── .appdata/           # SQLite indexes, vector store (internal)
```

## Available Skills

Use these skills when working on implementation:

- **prompt-engineering**: LLM prompt optimization and technique selection

## Specification Commands

Custom slash commands for the speckit workflow:
- `/speckit.specify` - Create feature specifications
- `/speckit.plan` - Generate implementation plans
- `/speckit.tasks` - Generate task lists from specs
- `/speckit.implement` - Execute implementation tasks
- `/speckit.clarify` - Identify underspecified areas

## Implementation Reference

See [specs/implementation-order.md](specs/implementation-order.md) for the phased development checklist (Phases A-D, 10-14 weeks).

Key documents:
- [docs/discovery/phase-5-requirements/prd.md](docs/discovery/phase-5-requirements/prd.md) - Full product requirements
- [docs/discovery/phase-6-mvp/mvp-scope.md](docs/discovery/phase-6-mvp/mvp-scope.md) - MVP feature backlog

## Development Guidelines

When implementing features:
1. Follow the hybrid storage architecture - markdown files are source of truth for player-visible content
2. Use AI interpretation for rules/oracle logic rather than hard-coding business logic
3. Respect the two-tier session model: Chat Session (in-progress, SQLite) → Session Log (persisted, markdown)
4. Use Vercel AI SDK for LLM abstraction and tool registration
5. Use Electron's main process for file system operations and SQLite access
