---
name: microsoft-agent-framework
description: Build AI agents using Microsoft Agent Framework. Use when creating agents, multi-agent workflows, function tools, MCP integration, orchestrations (sequential, concurrent, group chat, handoff), or multi-turn conversations. Supports C# (.NET) and Python.
---

# Microsoft Agent Framework

Microsoft Agent Framework is a development kit for building AI agents and agent workflows with a consistent interface across inference services (Azure OpenAI, OpenAI, Anthropic, Ollama).

## Language Selection

**Determine the target language first**, then read the appropriate reference:

- **C# / .NET**: See [references/csharp.md](references/csharp.md) - Covers `AIAgent`, `ChatClientAgent`, `AgentThread`, NuGet packages
- **Python**: See [references/python.md](references/python.md) - Covers `ChatAgent`, async patterns, pip packages

## Feature References

After reading the language guide, load these as needed:

- **Orchestrations** (multi-agent workflows): See [references/orchestrations-csharp.md](references/orchestrations-csharp.md) or [references/orchestrations-python.md](references/orchestrations-python.md)
- **MCP Integration** (Model Context Protocol): See [references/mcp-csharp.md](references/mcp-csharp.md)

## Quick Concept Overview

| Concept | Purpose |
|---------|---------|
| `AIAgent` / `ChatAgent` | Stateless agent that processes messages |
| `AgentThread` | Maintains conversation state across turns |
| Function Tools | Custom functions the agent can call |
| Orchestrations | Multi-agent coordination patterns |
| MCP | Protocol for connecting to external tools/data |

## Key Principle

Agents are **stateless**. Always use `AgentThread` for multi-turn conversations.
