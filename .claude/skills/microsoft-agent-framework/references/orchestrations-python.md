# Orchestrations - Python

Multi-agent workflow patterns for coordinating multiple agents.

## Sequential

Agents process in order, passing results forward:

```python
from agent_framework import SequentialBuilder

workflow = SequentialBuilder().participants([translator, summarizer]).build()

async for event in workflow.run_stream(messages):
    if event.is_agent_update:
        print(f"{event.executor_id}: {event.data}")
```

## Concurrent

Agents work in parallel on the same input:

```python
from agent_framework import ConcurrentBuilder

researcher = chat_client.create_agent(instructions="Research perspective.")
marketer = chat_client.create_agent(instructions="Marketing perspective.")
legal = chat_client.create_agent(instructions="Legal perspective.")

workflow = ConcurrentBuilder().participants([researcher, marketer, legal]).build()

# All agents run simultaneously
async for event in workflow.run_stream(messages):
    print(f"{event.executor_id}: {event.data}")
```

### Custom Aggregator

```python
from agent_framework import ConcurrentBuilder

async def custom_aggregator(results):
    """Synthesize all agent responses."""
    combined = "\n".join(r.text for r in results)
    return f"Combined analysis:\n{combined}"

workflow = ConcurrentBuilder()\
    .participants([agent1, agent2, agent3])\
    .aggregator(custom_aggregator)\
    .build()
```

## Group Chat

Collaborative conversation with manager-controlled flow:

```python
from agent_framework import GroupChatBuilder, RoundRobinManager

writer = chat_client.create_agent(name="Writer", 
    instructions="Write creative copy.")
reviewer = chat_client.create_agent(name="Reviewer",
    instructions="Review copy. Say APPROVED when satisfied.")

workflow = GroupChatBuilder()\
    .manager(RoundRobinManager(max_iterations=6))\
    .participants([writer, reviewer])\
    .build()
```

## Magentic Orchestration

Dynamic coordination inspired by MagenticOne:

```python
from agent_framework import MagenticBuilder

researcher = chat_client.create_agent(name="Researcher",
    instructions="Research and gather information.")
coder = chat_client.create_agent(name="Coder",
    instructions="Write and debug code.")
reviewer = chat_client.create_agent(name="Reviewer",
    instructions="Review work quality.")

workflow = MagenticBuilder()\
    .participants([researcher, coder, reviewer])\
    .on_agent_selected(lambda agent: print(f"Selected: {agent.name}"))\
    .on_plan_created(lambda plan: print(f"Plan: {plan}"))\
    .build()

# Manager dynamically selects agents based on task needs
result = await workflow.run("Build a web scraper for news headlines")
```

### Human-in-the-Loop Plan Review

```python
workflow = MagenticBuilder()\
    .participants([researcher, coder])\
    .enable_plan_review(True)\
    .build()

# Will pause for human approval of the plan
async for event in workflow.run_stream(task):
    if event.is_plan_review_request:
        approved = input("Approve plan? (y/n): ").lower() == "y"
        await event.respond(approved)
```

## Handoff

Dynamic agent switching:

```python
from agent_framework import HandoffBuilder

triage = chat_client.create_agent(name="Triage",
    instructions="Route to Billing or Technical based on query.")
billing = chat_client.create_agent(name="Billing")
technical = chat_client.create_agent(name="Technical")

workflow = HandoffBuilder(triage)\
    .add_target(billing, condition=lambda msg: "billing" in msg.text.lower())\
    .add_target(technical, condition=lambda msg: "technical" in msg.text.lower())\
    .build()
```

## Custom Executors

Wrap agents with additional logic:

```python
from agent_framework import Executor

class LoggingExecutor(Executor):
    def __init__(self, agent):
        self.agent = agent
    
    async def execute(self, messages):
        print(f"[{self.agent.name}] Processing...")
        result = await self.agent.run(messages)
        print(f"[{self.agent.name}] Complete")
        return result

workflow = ConcurrentBuilder()\
    .participants([LoggingExecutor(agent1), LoggingExecutor(agent2)])\
    .build()
```
