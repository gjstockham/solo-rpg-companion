# Prompting Techniques Reference

Detailed guide to prompting techniques with selection criteria.

## Technique Selection Matrix

| Technique | Best For | Avoid When | Model Size |
|-----------|----------|------------|------------|
| Zero-shot | Simple tasks, clear requirements | Complex reasoning, consistency needed | Any |
| Few-shot | Format consistency, edge cases | Token-limited, simple tasks | Any |
| Chain-of-Thought | Math, logic, multi-step reasoning | Simple factual, latency-critical | Large preferred |
| ReAct | Tool use, agents, dynamic tasks | Static content generation | Large |
| Self-Consistency | High-stakes accuracy | Cost-sensitive, simple tasks | Large |
| Prompt Chaining | Complex workflows, long outputs | Simple tasks, real-time needs | Any |
| Role Prompting | Tone/style control, expertise | Factual accuracy critical | Any |
| Structured Output | Parsing required, APIs | Freeform creative content | Any |

---

## Core Techniques

### Zero-Shot Prompting

Direct instruction without examples.

**When to use**: Simple classification, straightforward tasks, when examples aren't available, token-constrained scenarios.

**When to avoid**: When output format must be precise, complex reasoning required, or model struggles without examples.

**Pattern**:
```
[Task description]
[Input]
[Output format specification]
```

---

### Few-Shot Prompting

Provide examples demonstrating the expected behavior.

**When to use**: Format consistency critical, edge cases need demonstration, model misunderstands zero-shot, domain-specific patterns.

**When to avoid**: Examples don't fit context window, task is simple enough without them, examples might bias incorrectly.

**Best practices**:
- 2-5 examples typically sufficient
- Include diverse cases (easy, hard, edge cases)
- Format examples exactly as expected output
- Order can matter: put most relevant examples last

**Pattern**:
```
[Task description]

Example 1:
Input: [example input]
Output: [example output]

Example 2:
Input: [example input]
Output: [example output]

Now process:
Input: [actual input]
Output:
```

---

### Chain-of-Thought (CoT)

Encourage step-by-step reasoning before the final answer.

**When to use**: Math problems, logical reasoning, multi-step analysis, when you need to verify reasoning, complex decision-making.

**When to avoid**: Simple factual questions, latency-critical applications, very small models (may produce nonsense reasoning).

**Variants**:
- **Zero-shot CoT**: Add "Let's think step by step" or "Think through this carefully"
- **Few-shot CoT**: Provide examples with reasoning steps
- **Structured CoT**: Define specific reasoning steps to follow

**Pattern (Zero-shot)**:
```
[Problem]

Let's work through this step by step:
```

**Pattern (Few-shot)**:
```
Q: [example question]
A: Let's think step by step.
1. [reasoning step]
2. [reasoning step]
Therefore, [answer].

Q: [actual question]
A: Let's think step by step.
```

---

### ReAct (Reasoning + Acting)

Interleave reasoning with tool/action calls for agents.

**When to use**: Agents with tools, dynamic information retrieval, tasks requiring external actions, multi-step problem solving with real-world interaction.

**When to avoid**: Static content generation, no tools available, simple Q&A.

**Pattern**:
```
You have access to these tools:
- search(query): Search for information
- calculate(expression): Perform calculations

For each step:
Thought: [reasoning about what to do]
Action: [tool_name(parameters)]
Observation: [tool result]
... repeat until solved ...
Thought: I have enough information
Answer: [final response]
```

---

### Self-Consistency

Generate multiple reasoning paths, select the most common answer.

**When to use**: High-stakes accuracy, math/logic problems, when single-pass errors are costly.

**When to avoid**: Cost-sensitive applications, latency-critical, creative tasks (no single "right" answer).

**Implementation**: Generate 3-5+ completions with temperature > 0, aggregate answers (majority vote or weighted).

---

### Prompt Chaining / Decomposition

Break complex tasks into sequential subtasks.

**When to use**: Complex workflows, outputs exceeding context limits, tasks with clear stages, when intermediate validation needed.

**When to avoid**: Simple tasks, real-time requirements, tightly coupled subtasks.

**Pattern**:
```
Chain 1: Extract key information from document
Chain 2: Analyze extracted information
Chain 3: Generate recommendations based on analysis
Chain 4: Format final report
```

**Best practices**:
- Each chain should have clear input/output
- Validate intermediate outputs
- Pass only necessary context between chains

---

### Role / Persona Prompting

Assign a specific role or persona to influence style and approach.

**When to use**: Tone/style requirements, domain expertise simulation, consistent voice across interactions.

**When to avoid**: When factual accuracy is paramount (personas may hallucinate "expertise"), objective analysis needed.

**Pattern**:
```
You are a [role] with expertise in [domain]. 
Your communication style is [characteristics].
[Task]
```

**Caution**: Roles affect style more reliably than knowledge. Don't rely on "expert" roles for factual accuracy.

---

### Structured Output

Constrain output to specific formats (JSON, XML, etc.).

**When to use**: Programmatic parsing required, API responses, database entries, consistent data extraction.

**When to avoid**: Freeform creative content, when format flexibility is acceptable.

**Pattern**:
```
Extract the following information and respond in JSON format:

{
  "field1": "description of what goes here",
  "field2": "description",
  "field3": ["array", "if", "applicable"]
}

Input: [content to process]
```

**Best practices**:
- Provide exact schema with field descriptions
- Include example output if format is complex
- Use XML for nested/hierarchical data with LLMs that handle it well
- Consider JSON mode / grammar constraints if available

---

## Advanced Techniques

### Least-to-Most Prompting

Decompose problem into subproblems, solve easiest first, build up.

**When to use**: Complex problems with clear subproblem structure, educational contexts, when full problem overwhelms the model.

**Pattern**:
```
To solve this problem, let's break it into smaller parts:
1. First, [simplest subproblem]
2. Using that result, [next subproblem]
3. Finally, [combine to solve original problem]
```

---

### Generated Knowledge Prompting

First generate relevant knowledge, then use it to answer.

**When to use**: Knowledge-intensive tasks, when relevant context improves accuracy, commonsense reasoning.

**Pattern**:
```
Step 1: Generate relevant facts about [topic]
Step 2: Using these facts, answer [question]
```

---

### Self-Refine / Iterative Refinement

Generate initial output, critique it, improve based on critique.

**When to use**: Quality-critical content, writing tasks, code generation, when first-pass quality is insufficient.

**Pattern**:
```
[Generate initial response]

Now review your response for:
- Accuracy
- Completeness  
- Clarity

Provide an improved version addressing any issues found.
```

---

### Directional Stimulus Prompting

Provide hints or guidance toward the desired reasoning direction.

**When to use**: When model tends toward wrong approaches, domain-specific reasoning patterns needed.

**Pattern**:
```
[Problem]

Hint: Consider [relevant concept or approach]
```

---

### Negative Prompting / Constraints

Explicitly state what NOT to do.

**When to use**: Common failure modes to avoid, style constraints, safety requirements.

**Caution**: Positive instructions often more effective. Use sparingly for critical constraints.

**Pattern**:
```
[Task]

Important constraints:
- Do NOT [undesired behavior]
- Avoid [common mistake]
- Never [safety constraint]
```

---

## Microsoft Agent Framework Patterns

### Agent System Prompt Structure

```
## Role
[Clear definition of agent's purpose and capabilities]

## Available Tools
[List tools with precise descriptions and parameter schemas]

## Behavioral Guidelines
- When to use tools vs. respond directly
- How to handle ambiguous requests
- Error handling approach
- Scope boundaries (what's out of scope)

## Response Format
[Expected structure of agent responses]
```

### Multi-Agent Orchestration

For systems with multiple specialized agents:
- Define clear handoff criteria between agents
- Specify shared context format
- Include conflict resolution guidelines
- Define escalation paths

### Tool Description Best Practices

```
tool_name: Precise action verb + object
description: When to use, what it returns, limitations
parameters:
  - name: Clear parameter name
    description: Expected format, valid values, examples
    required: true/false
```
