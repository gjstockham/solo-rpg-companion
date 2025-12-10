# Microsoft Agent Framework - Python Guide

## Installation

```bash
pip install agent-framework
```

## Create an Agent

```python
from agent_framework.azure import AzureOpenAIChatClient
from azure.identity import AzureCliCredential

agent = AzureOpenAIChatClient(credential=AzureCliCredential()).create_agent(
    instructions="You are a helpful assistant.",
    name="MyAgent"
)

result = await agent.run("Hello!")
print(result.text)
```

## Multi-Turn Conversations

Agents are stateless. Use threads for conversation context:

```python
thread = agent.get_new_thread()
result1 = await agent.run("Tell me a joke.", thread=thread)
print(result1.text)

result2 = await agent.run("Make it funnier.", thread=thread)
print(result2.text)
```

## Function Tools

```python
from agent_framework import function_tool

@function_tool
def get_weather(location: str) -> str:
    """Get weather for a location."""
    return f"Weather in {location}: Sunny, 22°C"

agent = AzureOpenAIChatClient(credential=AzureCliCredential()).create_agent(
    instructions="You are a helpful assistant.",
    tools=[get_weather]
)
```

## Streaming

```python
async for chunk in agent.run_stream("Tell me a story."):
    if chunk.text:
        print(chunk.text, end="", flush=True)
```

## Different Agent Types

### Azure OpenAI Chat Completion
```python
from agent_framework.azure import AzureOpenAIChatClient
from azure.identity import AzureCliCredential

agent = AzureOpenAIChatClient(credential=AzureCliCredential()).create_agent(
    instructions="You are helpful."
)
```

### Azure AI Foundry Agent
```python
from agent_framework.azure import AzureAIAgentClient
from azure.identity.aio import DefaultAzureCredential

async with DefaultAzureCredential() as credential:
    agent = AzureAIAgentClient(async_credential=credential).create_agent(
        instructions="You are helpful."
    )
```

### OpenAI
```python
from agent_framework.openai import OpenAIChatClient

agent = OpenAIChatClient(api_key="...").create_agent(
    instructions="You are helpful."
)
```

### Anthropic
```python
from agent_framework.anthropic import AnthropicClient

agent = AnthropicClient().create_agent(
    instructions="You are helpful.",
    max_tokens=4096
)
```

## Environment Variables

```bash
export AZURE_OPENAI_ENDPOINT="https://<resource>.openai.azure.com"
export AZURE_OPENAI_CHAT_DEPLOYMENT_NAME="gpt-4o-mini"
# Optional
export AZURE_OPENAI_API_VERSION="2024-10-21"
```

## Thread Storage by Service

| Service | Storage |
|---------|---------|
| Azure OpenAI ChatCompletion | In-memory |
| Azure AI Agents | Service-managed |
| OpenAI Responses | Service-managed or in-memory |
| OpenAI Assistants | Service-managed |

## Async Context Manager Pattern

```python
from agent_framework import ChatAgent
from agent_framework.azure import AzureAIAgentClient
from azure.identity.aio import DefaultAzureCredential

async with (
    DefaultAzureCredential() as credential,
    ChatAgent(
        chat_client=AzureAIAgentClient(async_credential=credential),
        instructions="You are helpful"
    ) as agent
):
    response = await agent.run("Hello!")
    print(response.text)
```

## Custom Message Stores

For in-memory threads, provide custom storage:

```python
thread = agent.get_new_thread()
# Thread can be serialized for persistence
serialized = thread.serialize()
# And restored later
restored_thread = agent.deserialize_thread(serialized)
```
